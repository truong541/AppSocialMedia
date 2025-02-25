from django.shortcuts import get_object_or_404
from rest_framework.permissions import IsAuthenticated
from rest_framework.views import APIView
from .serializers import CustomRefreshToken, RegisterSerializer, FollowSerializer, ListUserSerializer, UserSerializer, UsernameValidatorSerializer, ViewedUserSerializer
from rest_framework.response import Response
from rest_framework import status
from django.contrib.auth import logout
from .models import User, Follow, ViewedUser
from post.models import Post
from django.db import IntegrityError
from django.views.decorators.csrf import csrf_exempt
from django.utils.decorators import method_decorator
from rest_framework.parsers import MultiPartParser, FormParser
from django.http import HttpResponseForbidden
from django.db.models import Q
from channels.layers import get_channel_layer
from asgiref.sync import async_to_sync

@method_decorator(csrf_exempt, name='dispatch')
class RegisterView(APIView):
    def post(self, request):
        
        username = request.data.get('username')
        if User.objects.filter(username=username).exists():
            return Response({'error': 'Username already exists.'}, status=status.HTTP_200_OK) 
        email = request.data.get('email')
        if User.objects.filter(email=email).exists():
            return Response({'error': 'Email already exists.'}, status=status.HTTP_200_OK)    
        
        password= request.data.get('password')
        password2= request.data.get('password2')
        if password != password2:
           return Response({'error': 'Please enter correct password.'}, status=status.HTTP_200_OK) 
        
        serializer = RegisterSerializer(data=request.data)
        if serializer.is_valid():
            try:
                user = serializer.save()
                tokens = create_tokens_for_user(user)
                return Response({
                    'message': 'User created successfully.',
                    'access_token': tokens['access_token'],
                    'refresh_token': tokens['refresh_token'],
                }, status=status.HTTP_201_CREATED)
            except IntegrityError:
                return Response({'error': 'Email already exists.'}, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
def create_tokens_for_user(user):
    refresh = CustomRefreshToken.for_user(user)
    # refresh = RefreshToken.for_user(user)
    refresh['user_id'] = user.idUser
    return {
        'access_token': str(refresh.access_token),
        'refresh_token': str(refresh)
    }

class LoginView(APIView):
    def post(self, request, *args, **kwargs):
        email = request.data.get('email')
        password = request.data.get('password')
        user = get_object_or_404(User, email=email)
        if not user.is_active or not user.check_password(password):
            return Response({'message': 'Invalid credentials'}, status=400)

        tokens = create_tokens_for_user(user)
        return Response({
            'access_token': tokens['access_token'],
            'refresh_token': tokens['refresh_token'],
            'message': 'Login successful'
        }, status=200)

class LogoutView(APIView):
    def post(self, request, *args, **kwargs):
        # Xóa session của người dùng
        logout(request)
        
        return Response({'message': 'Logout successful'}, status=200)


class GoogleLoginAPIView(APIView):
    def post(self, request):
        # Lấy thông tin từ frontend (Google Sign-In)
        id_google = request.data.get('idGoogle')
        username = request.data.get('username')
        email = request.data.get('email')
        avatar = request.data.get('avatar')  # Nếu có
        bio = request.data.get('bio')  # Nếu có

        # Kiểm tra nếu người dùng đã tồn tại với idGoogle hoặc email
        user = User.objects.filter(idGoogle=id_google).first()  # Tìm theo idGoogle
        if not user:
            user = User.objects.filter(email=email).first()  # Tìm theo email nếu chưa có idGoogle

        if not user:
            # Nếu người dùng chưa tồn tại, tạo mới user
            user = User.objects.create_user(
                username=username,
                email=email,
                idGoogle=id_google,
                avatar=avatar,
                bio=bio
            )
            return Response({"message": "User created successfully!"}, status=status.HTTP_201_CREATED)
        else:
            # Nếu người dùng đã tồn tại, trả về thông tin người dùng
            return Response({"message": "User already exists.", "user": user.username}, status=status.HTTP_200_OK)

class CurrentUser(APIView):
    permission_classes = [IsAuthenticated]
    def get(self, request):
        if request.user.is_authenticated:
            user_id = request.user.idUser
            try:
                user = User.objects.get(idUser=user_id)
                following = Follow.objects.filter(idFollowing=user_id).count()
                follower = Follow.objects.filter(idFollower=user_id).count()
                post = Post.objects.filter(user=user_id).count()
                # avatar_url = user.avatar.url if user.avatar else None
                avatar_url = request.build_absolute_uri(user.avatar.url) if user.avatar else ""

                return Response({
                    'idUser': user.idUser,
                    'fullname': user.fullname,
                    'username': user.username,
                    'gender': user.gender,
                    'email': user.email,
                    'avatar': avatar_url,
                    'bio': user.bio,
                    'post': post,
                    'following': following,
                    'followers': follower,
                    
                })
            except User.DoesNotExist:
                return Response({'error': 'User not found'}, status=404)
        else:
            return Response({'error': 'User not authenticated'}, status=401)

class UserDetailView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, idUser, *args, **kwargs):
        user = get_object_or_404(User, idUser=idUser)
        serializer = UserSerializer(user)
        avatar_url = request.build_absolute_uri(user.avatar.url) if user.avatar else None
        followers_count = Follow.objects.filter(idFollowing=user).count()
        following_count = Follow.objects.filter(idFollower=user).count()
        post_count = Post.objects.filter(user=user).count()

        response_data = serializer.data
        response_data['followers_count'] = followers_count
        response_data['following_count'] = following_count
        response_data['posts_count'] = post_count
        response_data['avatar']=avatar_url
        
        return Response(response_data)

class UpdateUserStatusView(APIView):
    permission_classes = [IsAuthenticated]
    def patch(self, request, user_id):
        
        try:
            # Lấy người dùng theo ID
            user = User.objects.get(idUser=user_id)
            
            # Cập nhật giá trị is_active từ dữ liệu gửi đến
            is_active = request.data.get('is_active')
            
            # Kiểm tra xem giá trị is_active có hợp lệ hay không
            if is_active is not None:
                user.is_active = is_active
                user.save()
                return Response({
                    'message': 'User status updated successfully.',
                    'is_active': user.is_active
                }, status=status.HTTP_200_OK)
            else:
                return Response({
                    'error': 'is_active value is required.'
                }, status=status.HTTP_400_BAD_REQUEST)
        
        except User.DoesNotExist:
            return Response({
                'error': 'User not found.'
            }, status=status.HTTP_404_NOT_FOUND)
        
class UsernameValidationView(APIView):
    permission_classes = [IsAuthenticated]
    def post(self, request):
        if User.objects.filter(username=request.data['username']).exclude(idUser=request.user.idUser).exists():
            return Response({'error': 'Username already exists.'}, status=201)
        serializer = UsernameValidatorSerializer(data=request.data)
        if serializer.is_valid():
            return Response({"message": "Valid username."}, status=200)
        else:
            return Response(serializer.errors, status=202)
    
class EditUserView(APIView):
    permission_classes = [IsAuthenticated]
    parser_classes = (MultiPartParser, FormParser)

    def patch(self, request):
        
        username = request.data.get('username')
        if User.objects.filter(username=username).exists():
            return Response({'error': 'Username already exists.'}, status=200)
        
        user = request.user
        serializer = ListUserSerializer(user, data=request.data, partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response({'message': 'Update successful', 'data': serializer.data}, status=200)
        return Response(serializer.errors, status=400)

class CreateFollowView(APIView):
    permission_classes = [IsAuthenticated] 
    def post (self, request, user_id):
        following_user = User.objects.get(idUser=user_id)
        if request.user == following_user:
            return HttpResponseForbidden("You cannot follow yourself.")
        if Follow.objects.filter(idFollower=request.user.idUser, idFollowing=following_user).exists():
            return HttpResponseForbidden("You are already following this user.")
        data = {
            'idFollower': request.user.idUser,
            'idFollowing': user_id,
        }
        serializer = FollowSerializer(data=data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=201)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
class UnfollowView(APIView):
    permission_classes = [IsAuthenticated] 
    def delete (self, request, user_id):
        
        try:
            following_user = User.objects.get(idUser=user_id)
            if request.user.idUser == following_user:
                return HttpResponseForbidden("You cannot unfollow yourself.")
            follow = Follow.objects.filter(idFollower=request.user.idUser, idFollowing=following_user).first()
            follow.delete()
            return Response({"message": "Unfollow success"}, status=status.HTTP_200_OK)
        except Follow.DoesNotExist:
            return Response({"error": "Comment not found or unauthorized"}, status=status.HTTP_404_NOT_FOUND)

class ListUserView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, user_id):
        followed_users = Follow.objects.filter(idFollower=user_id).values_list('idFollowing', flat=True)
        unfollowed_users = User.objects.filter(~Q(idUser__in=followed_users)).exclude(idUser=user_id)
        serializer = UserSerializer(unfollowed_users, many=True)
        return Response(serializer.data, status=200)

# danh sách các user chưa follow
class ListUnfollowUserView(APIView):
    permission_classes = [IsAuthenticated]
    def get(self, request, id_user):
        idUser = request.user.idUser
        followed_users = Follow.objects.filter(idFollower=idUser).values_list('idFollowing', flat=True)
        unfollowed_users = User.objects.filter(~Q(idUser__in=followed_users)).exclude(idUser__in=[idUser, id_user])
        serializer = UserSerializer(unfollowed_users, many=True)
        for user in serializer.data:
            if user['avatar']:
                user['avatar'] = request.build_absolute_uri(user['avatar'])
        return Response(serializer.data, status=200)

# api create & delete follow
class FollowUserView(APIView):
    permission_classes = [IsAuthenticated]
    def post(self, request, id_user):
        user_current = User.objects.get(idUser=request.user.idUser)
        following_user = get_object_or_404(User, idUser=id_user)
        if user_current == following_user:
            return HttpResponseForbidden("You cannot follow yourself.")
        follow, created = Follow.objects.get_or_create(idFollower=user_current, idFollowing=following_user)
        if not created:
            follow.delete()
            return Response({"message": "Unfollow success"}, status=200)
        
        return Response(FollowSerializer(follow).data, status=201)

#   Trả về thông tin user đã follow hay chưa
class FollowStatusView(APIView):
    permission_classes = [IsAuthenticated]
    def get (self, request, id_user):
        try:
            following_user = User.objects.get(idUser=id_user)
        except User.DoesNotExist:
            return Response({'error': 'User not found'}, status=404)
        
        is_following = Follow.objects.filter(idFollower=request.user.idUser, idFollowing=following_user).exists()
        return Response({'is_following': is_following}, status=200) #True or False
    
class SearchUserAPIView(APIView):
    def get(self, request):
        query = request.GET.get('query', '')
        if query:
            users = User.objects.filter(
                Q(username__icontains=query) | Q(fullname__icontains=query) 
            )
        else:
            users = User.objects.none()
        serializer = ListUserSerializer(users, many=True)
        return Response(serializer.data)
    
class SaveViewedUserAPIView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request, idUser):
        viewer = get_object_or_404(User, idUser=request.user.idUser)
        user_to_view = get_object_or_404(User, idUser=idUser)
        has_user = ViewedUser.objects.filter(user=idUser, idViewer=viewer).exists()
        if has_user: #kiểm tra user đã xem hay chưa
            return Response({"message": "You have viewed this user!"}, status=200)
   
        viewed_user = ViewedUser.objects.create(user=user_to_view, idViewer=viewer)
 
        serializer = ViewedUserSerializer(instance=viewed_user)
  
           
        channel_layer = get_channel_layer()
        async_to_sync(channel_layer.group_send)(
            f"user_{idUser}",
            {"type": "viewed.user", "data": serializer.data}
        )
        return Response(serializer.data, status=201)

class ListViewedUsersAPIView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        viewed_users = ViewedUser.objects.filter(idViewer=request.user.idUser).order_by('-createdAt')
        serializer = ViewedUserSerializer(viewed_users, many=True)
        return Response(serializer.data)