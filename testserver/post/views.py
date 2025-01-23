from rest_framework.views import APIView
from rest_framework.generics import CreateAPIView
from rest_framework.response import Response
from rest_framework import status, generics
from .serializers import PostSerializer, ListPostSerializer, LikeSerializer, CommentSerializer, RespondCommentSerializer
from .models import Post, Like, Comment, RespondComment
from account.models import User
from rest_framework.parsers import MultiPartParser, FormParser
from rest_framework.permissions import IsAuthenticated
from rest_framework_simplejwt.authentication import JWTAuthentication

class CreatePostView(APIView):
    parser_classes = (MultiPartParser, FormParser) 
    def post(self, request, *args, **kwargs):
        serializer = PostSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        print(serializer.errors)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class PostListView(generics.ListAPIView):
    queryset = Post.objects.all()  # Lấy tất cả bài post
    serializer_class = ListPostSerializer

class PostListByUserView(APIView):
    
    def get(self, request, user_id, *args, **kwargs):
        post = Post.objects.filter(user=user_id).order_by('-createdAt') 
        serializer = ListPostSerializer(post, many=True)
        return Response(serializer.data)

class LikePostView(APIView):
    def post(self, request, post_id):
        post = Post.objects.filter(idPost=post_id).first()

        if not post:
            return Response({"detail": "Post not found"}, status=status.HTTP_404_NOT_FOUND)

        user = request.user.idUser

        # Kiểm tra nếu người dùng đã like bài post này chưa
        if Like.objects.filter(post=post, user=user).exists():
            return Response({"detail": "You have already liked this post."}, status=status.HTTP_400_BAD_REQUEST)

        # Tạo lượt like
        like = Like.objects.create(post=post, user=user)

        return Response(LikeSerializer(like).data, status=status.HTTP_201_CREATED)
    # def post(self, request, post_id):
    #     # Lấy bài post từ ID
    #     try:
    #         post = Post.objects.get(idPost=post_id)
    #     except Post.DoesNotExist:
    #         return Response({"detail": "Post not found"}, status=status.HTTP_404_NOT_FOUND)

    #     # Lấy idUser từ request body
    #     user_id = request.data.get('user')
    #     if not user_id:
    #         return Response({"detail": "User ID is required"}, status=status.HTTP_400_BAD_REQUEST)

    #     try:
    #         user = User.objects.get(idUser=user_id)
    #     except User.DoesNotExist:
    #         return Response({"detail": "User not found"}, status=status.HTTP_404_NOT_FOUND)

    #     # Kiểm tra xem người dùng đã like bài viết này chưa
    #     if Like.objects.filter(idPost=post, idUser=user).exists():
    #         return Response({"detail": "You have already liked this post"}, status=status.HTTP_400_BAD_REQUEST)

    #     # Tạo mới lượt like
    #     like = Like(idPost=post, idUser=user)
    #     like.save()

    #     return Response(LikeSerializer(like).data, status=status.HTTP_201_CREATED)

class UnlikePostView(APIView):
    def delete(self, request, post_id):
        post = Post.objects.filter(idPost=post_id).first()

        if not post:
            return Response({"detail": "Post not found"}, status=status.HTTP_404_NOT_FOUND)

        user = request.user.idUser

        # Kiểm tra nếu user đã like bài post này
        like = Like.objects.filter(post=post, user=user).first()
        if not like:
            return Response({"detail": "You haven't liked this post."}, status=status.HTTP_400_BAD_REQUEST)

        # Xóa lượt like
        like.delete()

        return Response({"detail": "Like removed successfully."}, status=status.HTTP_204_NO_CONTENT)
    # def delete(self, request, post_id):
    #     # Lấy idUser từ request body
    #     user_id = request.data.get('idUser')
    #     if not user_id:
    #         return Response({"detail": "User ID is required"}, status=status.HTTP_400_BAD_REQUEST)

    #     try:
    #         post = Post.objects.get(idPost=post_id)
    #         user = User.objects.get(idUser=user_id)
    #     except (Post.DoesNotExist, User.DoesNotExist):
    #         return Response({"detail": "Post or User not found"}, status=status.HTTP_404_NOT_FOUND)

    #     try:
    #         like = Like.objects.get(idPost=post, idUser=user)
    #         like.delete()
    #         return Response({"detail": "Like removed successfully."}, status=status.HTTP_204_NO_CONTENT)
    #     except Like.DoesNotExist:
    #         return Response({"detail": "Like not found"}, status=status.HTTP_404_NOT_FOUND)
        
class CreateComment(APIView):
    # authentication_classes = [JWTAuthentication]
    # permission_classes = [IsAuthenticated]
    def post(self, request, post_id, *args, **kwargs):
        try:
            
            if not request.user.is_authenticated:
                return Response({"error": "User not authenticated"}, status=status.HTTP_401_UNAUTHORIZED)
            user_id = request.user.idUser
            post = Post.objects.get(pk=post_id)
            data = {
                'idPost': post.idPost,
                'idUser': user_id,
                'content': request.data.get('content'),
                'url': request.FILES.get('url')
            }
            serializer = CommentSerializer(data=data)
            if serializer.is_valid():
                serializer.save()
                return Response(serializer.data, status=status.HTTP_201_CREATED)
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        except Post.DoesNotExist:
            return Response({"error": "Post not found"}, status=status.HTTP_404_NOT_FOUND)
        
class EditComment(APIView):
    def put(self, request, comment_id):
        try:
            comment = Comment.objects.get(pk=comment_id, idUser=request.user)  # Chỉ sửa comment của chính mình
            serializer = CommentSerializer(comment, data=request.data, partial=True)  # partial=True để cập nhật từng phần
            if serializer.is_valid():
                serializer.save()
                return Response(serializer.data, status=status.HTTP_200_OK)
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        except Comment.DoesNotExist:
            return Response({"error": "Comment not found or unauthorized"}, status=status.HTTP_404_NOT_FOUND)

class DeleteComment(APIView):
    def delete(self, request, comment_id):
        try:
            comment = Comment.objects.get(pk=comment_id, idUser=request.user)
            comment.delete()
            return Response({"message": "Comment deleted successfully"}, status=status.HTTP_200_OK)
        except Comment.DoesNotExist:
            return Response({"error": "Comment not found or unauthorized"}, status=status.HTTP_404_NOT_FOUND)

class CreateRespondComment(APIView):
    def post(self, request, comment_id, *args, **kwargs):
        try:
            
            if not request.user.is_authenticated:
                return Response({"error": "User not authenticated"}, status=status.HTTP_401_UNAUTHORIZED)
            user_id = request.user.idUser
            comment = Comment.objects.get(pk=comment_id)
            data = {
                'idComment': comment.idComment,
                'idUser': user_id,
                'content': request.data.get('content'),
                'url': request.FILES.get('url')
            }
            serializer =RespondCommentSerializer(data=data)
            if serializer.is_valid():
                serializer.save()
                return Response(serializer.data, status=status.HTTP_201_CREATED)
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        except Comment.DoesNotExist:
            return Response({"error": "Comment not found"}, status=status.HTTP_404_NOT_FOUND)
        
class EditRespondComment(APIView):
    def put(self, request, respondcomment_id):
        try:
            respondcomment = RespondComment.objects.get(pk=respondcomment_id, idUser=request.user)  # Chỉ sửa comment của chính mình
            serializer = RespondCommentSerializer(respondcomment, data=request.data, partial=True)  # partial=True để cập nhật từng phần
            if serializer.is_valid():
                serializer.save()
                return Response(serializer.data, status=status.HTTP_200_OK)
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        except RespondComment.DoesNotExist:
            return Response({"error": "Comment not found or unauthorized"}, status=status.HTTP_404_NOT_FOUND)

class DeleteRespondComment(APIView):
    def delete(self, request, respondcomment_id):
        try:
            respondcomment = RespondComment.objects.get(pk=respondcomment_id, idUser=request.user)
            respondcomment.delete()
            return Response({"message": "Comment deleted successfully"}, status=status.HTTP_200_OK)
        except RespondComment.DoesNotExist:
            return Response({"error": "Comment not found or unauthorized"}, status=status.HTTP_404_NOT_FOUND)
