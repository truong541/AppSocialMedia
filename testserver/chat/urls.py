from django.urls import path
from . import views

urlpatterns = [
    path("create/<int:idUser>/", views.CreateMessageView.as_view(), name="create-message"),
    path("list-message/<int:idUser>/", views.ListMessageView.as_view(), name="list-message"),
    path("list-user/", views.ListChatUserView.as_view(), name="list-chat-user"),
]