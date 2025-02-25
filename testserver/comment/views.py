from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from .serializers import CommentSerializer, ListCommentSerializer, CommentLikeSerializer
from .models import Post, Comment, CommentLike
from django.shortcuts import get_object_or_404
from django.db.models import Count, Exists, OuterRef, F
from account.models import User
from rest_framework.permissions import IsAuthenticated
from asgiref.sync import async_to_sync
from channels.layers import get_channel_layer

#Sửa comment
class EditCommentView(APIView):
    permission_classes = [IsAuthenticated]
    def put(self, request, comment_id):
        try:
            comment = Comment.objects.get(idComment=comment_id, user=request.user.idUser)  # Chỉ sửa comment của chính mình
            serializer = CommentSerializer(comment, data=request.data, partial=True)  # partial=True để cập nhật từng phần
            if serializer.is_valid():
                serializer.save()
                channel_layer = get_channel_layer()
                async_to_sync(channel_layer.group_send)(
                    f'post_{comment.idPost.idPost}',
                    {
                        'type': 'send_comment_update',
                        'comment': CommentSerializer(comment).data
                    }
                )
                return Response(serializer.data, status=status.HTTP_200_OK)
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        except Comment.DoesNotExist:
            return Response({"error": "Comment not found or unauthorized"}, status=status.HTTP_404_NOT_FOUND)

#Xóa comment
class DeleteCommentView(APIView):
    permission_classes = [IsAuthenticated]
    def delete(self, request, comment_id):
        try:
            comment = Comment.objects.get(idComment=comment_id, user=request.user.idUser)
            idPost = comment.idPost.idPost  # Lưu lại ID bài viết trước khi xóa
            comment_id_deleted = comment.idComment  # Lưu lại ID comment trước khi xóa
            comment.delete()
            channel_layer = get_channel_layer()
            async_to_sync(channel_layer.group_send)(
                f'post_{idPost}',
                {
                    'type': 'send_comment_delete',
                    'comment_id': comment_id_deleted
                }
            )
            return Response({"message": "Comment deleted successfully"}, status=status.HTTP_200_OK)
        except Comment.DoesNotExist:
            return Response({"error": "Comment not found or unauthorized"}, status=status.HTTP_404_NOT_FOUND)

#Create comment mới
class CreateCommentView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request, idPost, *args, **kwargs):
        post = get_object_or_404(Post, idPost=idPost)

        data = {
                'idPost': idPost,
                'user': request.user.idUser,
                'content': request.data.get('content'),
            }
        serializer = CommentSerializer(data=data)
        if serializer.is_valid():
            comment = serializer.save()

            likes = CommentLike.objects.filter(idComment=comment).count()
            is_liked = CommentLike.objects.filter(idComment=comment, idUser=request.user).exists()

            # Kiểm tra is_author (comment của chủ bài viết hay không)
            is_author = (comment.user.idUser == post.user.idUser)

            # Thêm thông tin vào response
            response_data = serializer.data
            response_data['likes'] = likes
            response_data['is_liked'] = is_liked
            response_data['isAuthor'] = is_author

            channel_layer = get_channel_layer()
            async_to_sync(channel_layer.group_send)(
                f'post_{idPost}',
                {
                    'type': 'send_comment',
                    'comment': response_data,
                }
            )
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        print(f"Serializer errors: {serializer.errors}")
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

#Hiện danh sách Comment
class ListCommentsView(APIView):
    permission_classes = [IsAuthenticated]
    def get(self,request, idPost, *args, **kwargs):
        comments = Comment.objects.filter(idPost=idPost).annotate(
            likes=Count('commentlike'),
            is_liked=Exists(
                CommentLike.objects.filter(
                    idComment=OuterRef('pk'),
                    idUser=request.user.idUser
                )
            ),
            is_author=F('idPost__user') 
        ).order_by('-createdAt')
        serializer = ListCommentSerializer(comments, many=True, context={'request': request})
        return Response(serializer.data)


# #Hiện lượt like của Comment
# class CommentLikeCountView(APIView):
#     permission_classes = [IsAuthenticated]
#     def get(self, request, idComment, *args, **kwargs):
#         # Tính số lượt like của comment
#         like_count = CommentLike.objects.filter(idComment=idComment).count()
#         return Response({'like_count': like_count}, status=status.HTTP_200_OK)

# # Trạng thái like của Comment
# class CommentLikeByUserStatusView(APIView):
#     permission_classes = [IsAuthenticated]
#     def get(self, request, idComment, *args, **kwargs):
#         like_exists = CommentLike.objects.filter(idComment=idComment, idUser=request.user.idUser).exists()
#         if like_exists:
#             return Response({'status': 'true'}, status=status.HTTP_200_OK)
#         else:
#             return Response({'status': 'false'}, status=status.HTTP_200_OK)

#Like và unlike Comment      
class LikeAndUnlikeCommentView(APIView):
    permission_classes = [IsAuthenticated] 
    def post(self, request, idComment):
        comment = Comment.objects.get(idComment=idComment)
        user = User.objects.get(idUser=request.user.idUser)
        #Kiểm tra nếu đã like thì unlike
        if CommentLike.objects.filter(idComment=comment, idUser=user).exists():
            cmtLike = CommentLike.objects.get(idComment=comment, idUser=user)
            cmtLike.delete()
            action = "unlike"
            is_liked = False
        #Nếu chưa thì like
        else:
            cmtLike = CommentLike.objects.create(idComment=comment, idUser=user)
            action = "like"
            is_liked = True
        # cmtLike = CommentLike(idComment=comment, idUser=user)
        # cmtLike.save()
        # return Response(CommentLikeSerializer(cmtLike).data, status=status.HTTP_201_CREATED)
        likes = CommentLike.objects.filter(idComment=comment).count()
        # is_liked = CommentLike.objects.filter(idComment=comment, idUser=user).exists()
        updated_comment = {
            'idComment': comment.idComment,
            'is_liked': is_liked,
            'likes': likes,
        }

        channel_layer = get_channel_layer()
        async_to_sync(channel_layer.group_send)(
            f'post_{comment.idPost.idPost}',
            {
                'type': 'update_like',
                'comment': updated_comment
            }
        )
        # serializer = ListCommentSerializer(comment, context={"request": request})
        return Response(updated_comment, status=status.HTTP_200_OK)

#Hiện danh sách phản hồi Comment
class ListRespondCommentView(APIView):
    permission_classes = [IsAuthenticated]
    def get(self, request, idComment, *args, **kwargs):
        comments = Comment.objects.filter(idParentComment=idComment).order_by('-createdAt')
        serializer = ListCommentSerializer(comments, many=True)
        return Response(serializer.data)
    
#Create phản hồi comment mới
class CreateRespondCommentView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request, idPost, idComment, *args, **kwargs):
        data = {
                'idPost': idPost,
                'user': request.user.idUser,
                'idParentComment':idComment,
                'content': request.data.get('content'),
            }
        serializer = CommentSerializer(data=data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=201)
        print(f"Serializer errors: {serializer.errors}")
        return Response(serializer.errors, status=400)
