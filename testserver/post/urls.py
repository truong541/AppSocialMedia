from django.urls import path
from . import views

urlpatterns = [
    path('list-posts/', views.PostListView.as_view(), name='post-list'),
    path('list-by-user/<int:user_id>/', views.PostListByUserView.as_view(), name='post-list-by-user'),
    path('create-post/', views.CreatePostView.as_view(), name='create-post'),
    path('like/<int:post_id>/', views.LikePostView.as_view(), name='like-post'),
    path('only-like/<int:post_id>/', views.OnlyLikeView.as_view(), name='only-like'),
]
