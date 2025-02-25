from django.urls import path
from . import views

urlpatterns = [
    path('list/<int:idPost>/', views.ListCommentsView.as_view(), name='list-comments'),
    path('create/<int:idPost>/', views.CreateCommentView.as_view(), name='create-comment'),
    path('edit/<int:comment_id>/', views.EditCommentView.as_view(), name='edit-comment'),
    path('delete/<int:comment_id>/', views.DeleteCommentView.as_view(), name='delete-comment'),

    path('respond/list/<int:idPost>/', views.ListRespondCommentView.as_view(), name='list-respond-comments'),
    path('respond/create/<int:idPost>/<int:idComment>/', views.CreateRespondCommentView.as_view(), name='create-respond-comment'),
    
    path('like-unlike/<int:idComment>/', views.LikeAndUnlikeCommentView.as_view(), name='create-like-comment'),

]
