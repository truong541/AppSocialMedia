from rest_framework import serializers
from .models import User, Comment, CommentLike
from django.conf import settings

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['idUser', 'fullname', 'username','gender', 'bio', 'email', 'avatar']

class CommentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Comment
        fields = "__all__"

    def to_representation(self, instance):
        representation = super().to_representation(instance)
        
        avatar_url = f"{settings.MEDIA_URL}{instance.user.avatar}" if instance.user.avatar else None
        if avatar_url and not avatar_url.startswith("http"):
            avatar_url = f"{settings.SITE_URL}{avatar_url}"

        representation['user'] = {
            'idUser': instance.user.idUser,
            'username': instance.user.username,
            'email': instance.user.email,
            'avatar': avatar_url,
        }
        return representation
    
class CommentLikeSerializer(serializers.ModelSerializer):
    class Meta:
        model = CommentLike
        fields = "__all__"

class ListCommentSerializer(serializers.ModelSerializer):
    user = UserSerializer()
    isAuthor = serializers.SerializerMethodField(read_only=True)
    likes = serializers.SerializerMethodField()
    is_liked = serializers.SerializerMethodField()
    class Meta:
        model = Comment
        fields = ['idComment', 'idPost', 'user', 'idParentComment','content', 'createdAt', 'updatedAt','isAuthor', 'likes', 'is_liked']
    
    def get_isAuthor(self, obj):
        return obj.user.idUser == obj.is_author
    
    def get_likes(self, obj):
        return obj.likes

    def get_is_liked(self, obj):
        return obj.is_liked
