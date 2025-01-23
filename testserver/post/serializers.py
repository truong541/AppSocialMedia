from rest_framework import serializers
from .models import User, Post, MediaData, Like, Comment, RespondComment
# from django.db.models import Count

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['idUser', 'username', 'profileImage']

class MediaSerializer(serializers.ModelSerializer):
    class Meta:
        model = MediaData
        fields = "__all__"


class PostSerializer(serializers.ModelSerializer):
    url = MediaSerializer(many=True, read_only=True)
    uploaded_images = serializers.ListField(
        child=serializers.FileField(allow_empty_file=False, use_url=False),
        write_only=True
    )

    class Meta:
        model = Post
        fields = ['idPost', 'user', 'content', 'url','uploaded_images', 'createdAt']
    
    def create(self, validated_data):
        # media_data = validated_data.pop('media', [])
        uploaded_images = validated_data.pop('uploaded_images')
        post = Post.objects.create(**validated_data)
        for media in uploaded_images:
            MediaData.objects.create(post=post, url=media)     
        return post

class ListPostSerializer(serializers.ModelSerializer):
    user = UserSerializer()  # Lấy thông tin người dùng (idUser, username, profileImage)
    url = MediaSerializer(many=True, read_only=True)  # Lấy thông tin media liên quan
    like_count = serializers.SerializerMethodField()

    class Meta:
        model = Post
        fields = ['idPost', 'user', 'content', 'like_count', 'url', 'createdAt']

    def get_like_count(self, obj):
        # Đếm số lượt like của bài post
        return Like.objects.filter(idPost=obj.idPost).count()

class LikeSerializer(serializers.ModelSerializer):
    class Meta:
        model = Like
        fields = ['idLike', 'idPost', 'idUser', 'createdAt']

class CommentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Comment
        fields = "__all__"

class RespondCommentSerializer(serializers.ModelSerializer):
    class Meta:
        model = RespondComment
        fields = "__all__"