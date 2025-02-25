import json
from channels.generic.websocket import AsyncWebsocketConsumer
from rest_framework_simplejwt.tokens import AccessToken
from account.models import User
from urllib.parse import parse_qs

class ChatConsumer(AsyncWebsocketConsumer):
    async def connect(self):
        query_string = parse_qs(self.scope["query_string"].decode())
        token = query_string.get("token", [None])[0]

        if not token:
            await self.close()
            return
        
        try:
            access_token = AccessToken(token)
            self.user = await User.objects.aget(idUser=access_token["user_id"])
        except Exception as e:
            print(f"Lỗi xác thực WebSocket: {e}")
            await self.close()
            return
        
        self.user_group_name = f"chat_{self.user.idUser}"
        await self.channel_layer.group_add(self.user_group_name, self.channel_name)
        print(f"👥 User {self.user.idUser} đã tham gia group: {self.user_group_name}")
        await self.accept()

    async def disconnect(self, close_code):
        await self.channel_layer.group_discard(self.user_group_name, self.channel_name)

    async def chat_message(self, event):
        print("📩 WebSocket gửi tin nhắn:", event["message"])
        await self.send(text_data=json.dumps({"type": "chat_message", "message": event["message"]}))
