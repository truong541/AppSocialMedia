import json
from channels.generic.websocket import AsyncWebsocketConsumer
from comment.models import CommentLike
from asgiref.sync import sync_to_async

class CommentConsumer(AsyncWebsocketConsumer):
    async def connect(self):
        self.idPost = self.scope['url_route']['kwargs']['idPost']
        self.room_group_name = f'post_{self.idPost}'

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

    async def send_comment(self, event):
        comment = event['comment']
        await self.send(text_data=json.dumps({
            'type': 'new_comment',
            'comment': comment
        }))

    async def update_like(self, event):
        await self.send(text_data=json.dumps({
            'type': 'update_like',
            'comment': event['comment']
        }))

    async def send_comment_update(self, event):
        comment = event['comment']
        await self.send(text_data=json.dumps({
            'type': 'update_comment',
            'comment': comment
        }))

    async def send_comment_delete(self, event):
        comment_id = event['comment_id']
        await self.send(text_data=json.dumps({
            'type': 'delete_comment',
            'comment_id': comment_id
        }))