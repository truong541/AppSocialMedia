from rest_framework.permissions import IsAuthenticated
from rest_framework.authentication import TokenAuthentication
from rest_framework.views import APIView
from .serializers import RegisterSerializer, FollowSerializer
from rest_framework.response import Response
from rest_framework import status
from django.contrib.auth import get_user_model
from .models import User, Follow
from post.models import Post
from django.db import IntegrityError
from django.views.decorators.csrf import csrf_exempt
from django.utils.decorators import method_decorator
from rest_framework_simplejwt.tokens import RefreshToken
from django.http import HttpResponseForbidden

# # User = get_user_model()
@method_decorator(csrf_exempt, name='dispatch')
class RegisterView(APIView):
    def post(self, request):
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
    refresh = RefreshToken.for_user(user)
    # refresh['user_id'] = user.idUser
    return {
        'access_token': str(refresh.access_token),
        'refresh_token': str(refresh)
    }

class LoginView(APIView):
    def post(self, request, *args, **kwargs):
        email = request.data.get('email')
        password = request.data.get('password')

        try:
            user = User.objects.get(email=email)
        except User.DoesNotExist:
            return Response({'message': 'User with this email does not exist'}, status=404)

        if user.check_password(password):
            tokens = create_tokens_for_user(user)

            return Response({
                'access_token': tokens['access_token'],
                'refresh_token': tokens['refresh_token'],
                'message': 'Login successful'
            }, status=200)
        return Response({'message': 'Invalid credentials'}, status=400)

class LogoutView(APIView):
    permission_classes = [IsAuthenticated]
    authentication_classes = [TokenAuthentication]

    def post(self, request):
        request.user.auth_token.delete()  # Xóa token hiện tại của người dùng
        return Response({
            'message': 'Successfully logged out.'
        }, status=status.HTTP_200_OK)



class GoogleLoginAPIView(APIView):
    def post(self, request):
        # Lấy thông tin từ frontend (Google Sign-In)
        id_google = request.data.get('idGoogle')
        username = request.data.get('username')
        email = request.data.get('email')
        profile_image = request.data.get('profileImage')  # Nếu có
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
                profileImage=profile_image,
                bio=bio
            )
            return Response({"message": "User created successfully!"}, status=status.HTTP_201_CREATED)
        else:
            # Nếu người dùng đã tồn tại, trả về thông tin người dùng
            return Response({"message": "User already exists.", "user": user.username}, status=status.HTTP_200_OK)

class CurrentUser(APIView):
    def get(self, request):
        if request.user.is_authenticated:
            user_id = request.user.idUser
            print(user_id)
            try:
                user = User.objects.get(idUser=user_id)
                following = Follow.objects.filter(idFollowing=user_id).count()
                follower = Follow.objects.filter(idFollower=user_id).count()
                post = Post.objects.filter(user=user_id).count()
                return Response({
                    'idUser': user.idUser,
                    'username': user.username,
                    'email': user.email,
                    # 'profileImage': user.profileImage,
                    'bio': user.bio,
                    'post': post,
                    'following': following,
                    'followers': follower,
                    
                })
            except User.DoesNotExist:
                return Response({'error': 'User not found'}, status=404)
        else:
            return Response({'error': 'User not authenticated'}, status=401)
       
class UpdateUserStatusView(APIView):
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
                'error': 'User not found.'\
            }, status=status.HTTP_404_NOT_FOUND)

class CreateFollowView(APIView):
    def post (self, request, user_id):
        following_user = User.objects.get(id=user_id)
        if request.user == following_user:
            return HttpResponseForbidden("You cannot follow yourself.")
        if Follow.objects.filter(follower=request.user, following=following_user).exists():
            return HttpResponseForbidden("You are already following this user.")
        data = {
            'idFollower': request.user.idUser,
            'idFollowing': following_user,
        }
        serializer = FollowSerializer(data=data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
class UnfollowView(APIView):
    def delete (self, request, user_id):
        
        try:
            following_user = User.objects.get(id=user_id)
            if request.user.idUser == following_user:
                return HttpResponseForbidden("You cannot unfollow yourself.")
            follow = Follow.objects.filter(idFollower=request.user.idUser, idFollowing=following_user).first()
            follow.delete()
            return Response({"message": "Unfollow success"}, status=status.HTTP_200_OK)
        except Follow.DoesNotExist:
            return Response({"error": "Comment not found or unauthorized"}, status=status.HTTP_404_NOT_FOUND)
        
class FollowStatusView(APIView):
    def get (self, request, user_id):
        try:
            following_user = User.objects.get(id=user_id)
        except User.DoesNotExist:
            return Response({'error': 'User not found'}, status=404)
        
        is_following = Follow.objects.filter(follower=request.user.idUser, following=following_user).exists()
        return Response({'is_following': is_following}) #True or False