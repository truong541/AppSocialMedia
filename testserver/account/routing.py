from django.urls import path
from .consumers import ViewedUserConsumer

websocket_urlpatterns = [
    path("ws/viewed-user/", ViewedUserConsumer.as_asgi()),
]
