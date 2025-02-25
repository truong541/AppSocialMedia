from rest_framework import serializers
from .models import Message
from account.models import User
from django.conf import settings

class MessageSerializer(serializers.ModelSerializer):
    content = serializers.CharField(required=False, allow_blank=True) 
    class Meta:
        model = Message
        fields = ['idMessage','sender','receiver','content','image','isRead','isDeleted','createdAt']

class ChatUserSerializer(serializers.ModelSerializer):
    last_message = serializers.SerializerMethodField()
    
    class Meta:
        model = User
        fields = ["idUser", "fullname", "username", "avatar", "last_message"]
    
    def get_last_message(self, obj):
        request = self.context["request"]
        user_id = request.user.idUser
        last_msg = Message.objects.filter(
            sender=obj, receiver_id=user_id
        ).union(
            Message.objects.filter(sender_id=user_id, receiver=obj)
        ).order_by('-createdAt').first()
        
        if last_msg:
            image_url = request.build_absolute_uri(last_msg.image.url) if last_msg.image else None  # Đường dẫn đầy đủ
            return {
                "content": last_msg.content,
                "image": image_url,
                "createdAt": last_msg.createdAt,
                "isRead": last_msg.isRead,
                "isDeleted": last_msg.isDeleted
            }
        return None

