from rest_framework import serializers
from .models import User, Follow, ViewedUser
from django.conf import settings
import re

from rest_framework_simplejwt.tokens import RefreshToken

class CustomRefreshToken(RefreshToken):
    @classmethod
    def for_user(cls, user):
        token = super().for_user(user)
        token['user_id'] = user.idUser  # Thêm idUser vào token
        return token
    
class RegisterSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)
    password2 = serializers.CharField(write_only=True) 

    class Meta:
        model = User
        fields = ['fullname','username', 'gender', 'email', 'password', 'password2']
    
    def create(self, validated_data):
        # Tạo người dùng mới
        user = User.objects.create_user(
            fullname=validated_data['fullname'],
            username=validated_data['username'],
            gender=validated_data['gender'],
            email=validated_data['email'],
            password=validated_data['password']
        )
        return user

class FollowSerializer(serializers.ModelSerializer):
    class Meta:
        model = Follow
        fields = '__all__'

class ListUserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = '__all__'

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['idUser','fullname', 'username', 'gender', 'email', 'avatar','bio']

class ViewedUserSerializer(serializers.ModelSerializer):
    user = UserSerializer(read_only=True)
    class Meta:
        model = ViewedUser
        fields = ['idViewedUser','user','idViewer','createdAt']

class UsernameValidatorSerializer(serializers.Serializer):
    username = serializers.CharField(max_length=150)

    def validate_username(self, value):
        if any(char.isupper() for char in value):
            raise serializers.ValidationError(
                "Tên người dùng không được chứa chữ in hoa."
            )
        # Kiểm tra xem tên người dùng có chứa dấu cách hay không
        if ' ' in value:
            raise serializers.ValidationError(
                "Tên người dùng không được chứa dấu cách."
            )

        if not re.match(r'^[a-zA-Z0-9._]+$', value):
            raise serializers.ValidationError(
                "Tên người dùng chỉ được chứa chữ cái, chữ số, dấu chấm và dấu gạch dưới."
            )
        return value

