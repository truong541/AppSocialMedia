from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from .serializers import PostSerializer, ListPostSerializer, LikeSerializer
from .models import Post, Like
from account.models import User
from rest_framework.parsers import MultiPartParser, FormParser
from rest_framework.permissions import IsAuthenticated

# Tạo bài Post mới
class CreatePostView(APIView):
    parser_classes = (MultiPartParser, FormParser) 
    def post(self, request, *args, **kwargs):
        serializer = PostSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        print(serializer.errors)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

# Danh sách cái bài Post
class PostListView(APIView):
    permission_classes = [IsAuthenticated]
    def get(self, request):
        posts = Post.objects.all()
        serializer = ListPostSerializer(posts, many=True, context={'request': request})
        return Response(serializer.data, status=200)

# Các bài Post theo 1 user
class PostListByUserView(APIView):
    permission_classes = [IsAuthenticated]
    def get(self, request, user_id, *args, **kwargs):
        post = Post.objects.filter(user=user_id).order_by('-createdAt') 
        serializer = ListPostSerializer(post, many=True, context={'request': request})
        return Response(serializer.data)

# Like và Unlike bài Post
class LikePostView(APIView):
    permission_classes = [IsAuthenticated] 
    def post(self, request, post_id):
        post = Post.objects.get(idPost=post_id)
        user = User.objects.get(idUser=request.user.idUser)
        if Like.objects.filter(idPost=post, idUser=user).exists():
            like = Like.objects.get(idPost=post, idUser=user)
            like.delete()
            return Response({"detail": "Like removed successfully."}, status=status.HTTP_204_NO_CONTENT)
        like = Like(idPost=post, idUser=user)
        like.save()
        return Response(LikeSerializer(like).data, status=status.HTTP_201_CREATED)

# Like bài Post khi tap vào ảnh
class OnlyLikeView(APIView):
    permission_classes = [IsAuthenticated] 
    def post(self, request, post_id):
        post = Post.objects.get(idPost=post_id)
        user = User.objects.get(idUser=request.user.idUser)
        if Like.objects.filter(idPost=post, idUser=user).exists():
            return Response({"detail": "You were liked the Post"}, status = 204)
        like = Like(idPost=post, idUser=user)
        like.save()
        return Response(LikeSerializer(like).data, status=status.HTTP_201_CREATED)

# Unlike bài Post (Hiện Không sử dụng API này)
class UnlikePostView(APIView):
    permission_classes = [IsAuthenticated] 
    def delete(self, request, post_id):
        post = Post.objects.filter(idPost=post_id).first()
        user = request.user.idUser
        
        like = Like.objects.filter(post=post, user=user).first()
        if not like:
            return Response({"detail": "You haven't liked this post."}, status=status.HTTP_400_BAD_REQUEST)
        like.delete()

        return Response({"detail": "Like removed successfully."}, status=status.HTTP_204_NO_CONTENT)