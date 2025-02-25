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
    path('username-validation/',views.UsernameValidationView.as_view(),name='username-validation'),
    path('edit-user/', views.EditUserView.as_view(), name='edit-user'),

    path('token/', TokenRefreshView.as_view(), name='token_refresh'),

    path('follow/<int:user_id>/', views.CreateFollowView.as_view(), name='create_follow'),
    path('unfollow/<int:user_id>/', views.UnfollowView.as_view(), name='delete_follow'),
    

    path('list-unfollowed-user/<int:id_user>/', views.ListUnfollowUserView.as_view(), name='list-unfollowed-use'),
    path('follow-user/<int:id_user>/', views.FollowUserView.as_view(), name='follow-user'),
    path('follow-status/<int:id_user>/', views.FollowStatusView.as_view(), name='follow_status'),

    path('detail/<int:idUser>/', views.UserDetailView.as_view(), name='user-detail'),
    path('list-user-by-id/<int:user_id>/', views.ListUserView.as_view(), name='list-user-by-id'),
    path('search/', views.SearchUserAPIView.as_view(), name='search-users'),
    path('viewed-user/create/<int:idUser>/', views.SaveViewedUserAPIView.as_view(), name='create-viewed-users'),
    path('viewed-user/', views.ListViewedUsersAPIView.as_view(), name='list-viewed-users'),
]
