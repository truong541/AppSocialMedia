from rest_framework import serializers
from .models import User, Follow

class RegisterSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)
    password2 = serializers.CharField(write_only=True) 

    class Meta:
        model = User
        fields = ['username', 'email', 'password', 'password2']
    
    def create(self, validated_data):
        # Tạo người dùng mới
        user = User.objects.create_user(
            username=validated_data['username'],
            email=validated_data['email'],
            password=validated_data['password']
        )
        return user

class UserActiveSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['idUser', 'username', 'email', 'is_active']

class FollowSerializer(serializers.ModelSerializer):
    class Meta:
        model = Follow
        fields = '__all__'