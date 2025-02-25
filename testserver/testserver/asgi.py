import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'testserver.settings')
django.setup()

from django.core.asgi import get_asgi_application
from channels.routing import ProtocolTypeRouter, URLRouter
from channels.auth import AuthMiddlewareStack
from account.middleware import JWTAuthMiddleware
from comment.routing import websocket_urlpatterns as comment_urls
from chat.routing import websocket_urlpatterns as chat_urls
# from account.routing import websocket_urlpatterns as account_urls


application = ProtocolTypeRouter({
    "http": get_asgi_application(),
    # "websocket": URLRouter(websocket_urlpatterns)
    "websocket": AuthMiddlewareStack(
        URLRouter(comment_urls + chat_urls)
    ),
})