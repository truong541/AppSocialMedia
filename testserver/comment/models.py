from django.db import models
from django.utils.timezone import localtime, now
from account.models import User
from post.models import Post
import os

def upload_image(instance, filename):
    from .models import Comment
    last_comment = (
        Comment.objects.filter(idPost=instance.idPost, idUser=instance.idUser)
        .order_by('-idComment')
        .first()
    )
    # Tính toán image_counter
    image_counter = (last_comment.idComment + 1) if last_comment else 1
    return os.path.join('images', f"{instance.idUser.idUser}_{instance.idPost.idPost}_{image_counter}_{filename}")

class Comment(models.Model):
    idComment = models.AutoField(primary_key=True)
    idPost = models.ForeignKey(Post, on_delete=models.CASCADE, db_column='idPost', related_name='comments')
    user = models.ForeignKey(User, on_delete=models.CASCADE, db_column='idUser', related_name='comments')
    idParentComment = models.ForeignKey('self', on_delete=models.CASCADE, null=True, blank=True, db_column='idParentComment', related_name='replies')
    content = models.TextField()
    url = models.ImageField(upload_to=upload_image, null=True, blank=True)
    createdAt = models.DateTimeField(default=now, db_column='createdAt')
    updatedAt = models.DateTimeField(auto_now=True, db_column='updatedAt')

    class Meta:
        db_table = 'comments'

    def __str__(self):
        return f"Comment by {self.user.username} on Post {self.idPost.idPost}"

class CommentLike(models.Model):
    idCommentLike = models.AutoField(primary_key=True)
    idComment = models.ForeignKey(Comment,  on_delete=models.CASCADE, db_column='idComment')
    idUser = models.ForeignKey(User, on_delete=models.CASCADE, db_column='idUser')
    createdAt = models.DateTimeField(auto_now_add=True, db_column='createdAt')

    class Meta:
        db_table = 'commentlikes'

    def __str__(self):
        return f"CommentLike by {self.idUser.idUser} on Comment {self.idComment.idComment}"
