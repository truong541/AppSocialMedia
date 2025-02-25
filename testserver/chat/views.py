from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from rest_framework import status
from django.conf import settings
from django.db.models import Q, Max
from .models import Message
from account.models import User
from .serializers import MessageSerializer, ChatUserSerializer
from channels.layers import get_channel_layer
from asgiref.sync import async_to_sync
from rest_framework.parsers import MultiPartParser, FormParser

# Tạo tin nhắn mới
class CreateMessageView(APIView):
    permission_classes = [IsAuthenticated]
    parser_classes = (MultiPartParser, FormParser) 
    def post(self, request, idUser):
        data = request.data.copy()
        data["sender"] = request.user.idUser
        data["receiver"] = idUser

        serializer = MessageSerializer(data=data)
        if serializer.is_valid():
            message = serializer.save()
            message_data = serializer.data
            if message.image:
                message_data["image"] = request.build_absolute_uri(message.image.url)

            channel_layer = get_channel_layer()
            try:
                async_to_sync(channel_layer.group_send)(
                    f"chat_{message.receiver.idUser}",
                    {
                        "type": "chat_message",
                        "message": message_data
                    }
                )
                async_to_sync(channel_layer.group_send)(
                    f"chat_{message.sender.idUser}",
                    {
                        "type": "chat_message",
                        "message": message_data
                    }
                )
                print("✅ Gửi thành công qua WebSocket")
            except Exception as e:
                print(f"❌ Lỗi khi gửi WebSocket: {e}")

            return Response(serializer.data, status=201)
        print(serializer.errors)
        return Response(serializer.errors, status=400)

# Hiện tin nhắn
class ListMessageView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, idUser):
        user_current = request.user.idUser

        messages = Message.objects.filter(
            Q(sender=user_current, receiver=idUser) | 
            Q(sender=idUser, receiver=user_current)
        ).order_by("createdAt")
        data = []
        for message in messages:
            serialized_message = MessageSerializer(message).data
            if message.image:
                serialized_message["image"] = request.build_absolute_uri(message.image.url)
            data.append(serialized_message)

        return Response(data)
    
# Danh sách user đã nhắn tin
class ListChatUserView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        user_current = request.user.idUser
        # Lấy danh sách người đã nhắn tin với user hiện tại
        chat_users = User.objects.filter(
            idUser__in=Message.objects.filter(sender_id=user_current).values_list("receiver_id", flat=True)
        ).union(
            User.objects.filter(idUser__in=Message.objects.filter(receiver_id=user_current).values_list("sender_id", flat=True))
        )

        serializer = ChatUserSerializer(chat_users, many=True, context={"request": request})
        return Response(serializer.data)