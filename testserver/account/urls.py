from django.urls import path
from . import views
from rest_framework.authtoken.views import obtain_auth_token
from rest_framework_simplejwt.views import TokenRefreshView

urlpatterns = [
    path('register/', views.RegisterView.as_view(), name='register'),
    path('login/', views.LoginView.as_view(), name='login'),
    path('logout/', views.LogoutView.as_view(), name='logout'),
    path('api-token-auth/', obtain_auth_token, name='api_token_auth'),
    path('google-login/', views.GoogleLoginAPIView.as_view(), name='google-login'),
    path('status/<int:user_id>/', views.UpdateUserStatusView.as_view(), name='update-user-status'),
    path('current-user/',views.CurrentUser.as_view(),name='current-user'),

    path('token/', TokenRefreshView.as_view(), name='token_refresh'),

    path('follow/<int:user_id>/', views.CreateFollowView.as_view(), name='create_follow'),
    path('unfollow/<int:user_id>/', views.UnfollowView.as_view(), name='delete_follow'),
    path('follow/status/<int:user_id>/', views.FollowStatusView.as_view(), name='follow_status'),
]
