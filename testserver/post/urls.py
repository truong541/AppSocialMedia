from django.urls import path
from . import views

urlpatterns = [
    path('list-posts/', views.PostListView.as_view(), name='post-list'),
    path('list-by-user/<int:user_id>/', views.PostListByUserView.as_view(), name='post-list-by-user'),
    path('create-post/', views.CreatePostView.as_view(), name='create-post'),
    path('like/<int:post_id>/', views.LikePostView.as_view(), name='like-post'),
    path('unlike/<int:post_id>/', views.UnlikePostView.as_view(), name='unlike-post'),

    path('comment/create/<int:post_id>/', views.CreateComment.as_view(), name='create-comment'),
    path('comment/edit/<int:comment_id>/', views.EditComment.as_view(), name='edit-comment'),
    path('comment/delete/<int:comment_id>/', views.DeleteComment.as_view(), name='delete-comment'),

    path('comment/respond/create/<int:comment_id>/', views.CreateRespondComment.as_view(), name='create-respond-comment'),
    path('comment/respond/edit/<int:respondcomment_id>/', views.EditRespondComment.as_view(), name='edit-respond-comment'),
    path('comment/respond/delete/<int:respondcomment_id>/', views.DeleteRespondComment.as_view(), name='delete-respond-comment'),
]
