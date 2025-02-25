from rest_framework import serializers
from .models import User, Post, MediaData, Like
from comment.models import Comment

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['idUser', 'fullname', 'username', 'gender', 'bio', 'email', 'avatar']

class MediaSerializer(serializers.ModelSerializer):
    class Meta:
        model = MediaData
        fields = ['idMedia', 'url', 'createdAt']


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
    user = UserSerializer()
    url = MediaSerializer(many=True, read_only=True)  # Lấy thông tin media liên quan
    like_count = serializers.SerializerMethodField(read_only=True)
    comment_count = serializers.SerializerMethodField(read_only=True)
    isLiked = serializers.SerializerMethodField(read_only=True)

    class Meta:
        model = Post
        fields = ['idPost', 'user', 'content', 'like_count', 'comment_count', 'isLiked', 'url', 'createdAt']

    def get_like_count(self, obj):
        return Like.objects.filter(idPost=obj.idPost).count()
    
    def get_comment_count(self, obj):
        return Comment.objects.filter(idPost=obj.idPost).count()
    
    def get_isLiked(self, obj):
        request  = self.context.get('request')
        return Like.objects.filter(idPost=obj, idUser=request.user).exists()
    

class LikeSerializer(serializers.ModelSerializer):
    class Meta:
        model = Like
        fields = "__all__"

