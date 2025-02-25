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
    return os.path.join('images', f"{instance.post.idPost}_{filename}")

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