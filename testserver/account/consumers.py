import json
from channels.generic.websocket import AsyncWebsocketConsumer

class ViewedUserConsumer(AsyncWebsocketConsumer):
    async def connect(self):
        self.user_id = self.scope['user']
        print("WebSocket user:", self.scope['user'])
        self.room_group_name = f"user_{self.user_id}"

        await self.channel_layer.group_add(
            self.room_group_name,
            self.channel_name
        )
        await self.accept()

    async def disconnect(self, close_code):
        await self.channel_layer.group_discard(
            self.room_group_name,
            self.channel_name
        )

    async def viewed_user(self, event):
        await self.send(text_data=json.dumps(event["data"]))
