from django.db import models
from account.models import User
import os

class Post(models.Model):
    idPost = models.AutoField(primary_key=True) 
    user = models.ForeignKey(User, on_delete=models.CASCADE, db_column='idUser')
    content = models.TextField()
    createdAt = models.DateTimeField(auto_now_add=True, db_column='createdAt')

    def __str__(self):
        return f"Post {self.id} by {self.user.username}"
    class Meta:
        db_table = 'posts'

def upload_to(instance, filename):
    return os.path.join('media', 'images', f"{instance.post.idPost}_{filename}")

class MediaData(models.Model):
    idMedia = models.AutoField(primary_key=True)
    url = models.FileField(upload_to=upload_to)
    MEDIA_TYPE_CHOICES = [
        ('image', 'Image'),
        ('video', 'Video')
    ]
    type = models.CharField(max_length=10, choices=MEDIA_TYPE_CHOICES)
    createdAt = models.DateTimeField(auto_now_add=True, db_column='createdAt')
    updatedAt = models.DateTimeField(auto_now=True, db_column='updatedAt')
    post = models.ForeignKey(Post, on_delete=models.CASCADE, related_name='url', db_column='idPost')

    def __str__(self):
        return f"{self.type.capitalize()} for Post {self.post.idPost}"
    
    class Meta:
        db_table = 'media'


class Like(models.Model):
    idLike = models.AutoField(primary_key=True)
    idPost = models.ForeignKey(Post, on_delete=models.CASCADE, db_column='idPost')
    idUser = models.ForeignKey(User, on_delete=models.CASCADE, db_column='idUser')
    createdAt = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'likes'
        unique_together = ('idPost', 'idUser')  # Đảm bảo mỗi user chỉ like mỗi post 1 lần

    def __str__(self):
        return f"Like by {self.idUser.username} on Post {self.idPost.idPost}"
    
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
    idPost = models.ForeignKey(Post, on_delete=models.CASCADE, db_column='idPost')
    idUser = models.ForeignKey(User, on_delete=models.CASCADE, db_column='idUser')
    content = models.TextField()
    url = models.ImageField(upload_to=upload_image, null=True, blank=True)
    createdAt = models.DateTimeField(auto_now_add=True, db_column='createdAt')
    updatedAt = models.DateTimeField(auto_now=True, db_column='updatedAt')

    class Meta:
        db_table = 'comments'

    def __str__(self):
        return f"Comment by {self.idUser.username} on Post {self.idPost.idPost}"

def upload_image2(instance, filename):
    from .models import RespondComment
    last_comment = (
        RespondComment.objects.filter(idComment=instance.idComment, idUser=instance.idUser)
        .order_by('-idRespondComment')
        .first()
    )
    # Tính toán image_counter
    image_counter = (last_comment.idRespondComment + 1) if last_comment else 1
    return os.path.join('images', f"{instance.idUser.idUser}_{instance.idComment.idComment}_{image_counter}_{filename}")
 
class RespondComment(models.Model):
    idRespondComment = models.AutoField(primary_key=True)
    idComment = models.ForeignKey(Comment, on_delete=models.CASCADE,db_column='idComment' )
    idUser = models.ForeignKey(User, on_delete=models.CASCADE, db_column='idUser')
    content = models.TextField()
    url = models.ImageField(upload_to=upload_image2, null=True, blank=True)
    createdAt = models.DateTimeField(auto_now_add=True, db_column='createdAt')
    updatedAt = models.DateTimeField(auto_now=True, db_column='updatedAt')

    class Meta:
        db_table = 'respondcomments'

    def __str__(self):
        return f"RespondComment by {self.idUser.username} on Comment {self.idComment.idComment}"