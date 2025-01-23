from django import forms
from django.contrib.auth.forms import UserCreationForm
from .models import AccountUser

class RegistrationForm(UserCreationForm):
    email = forms.EmailField(required=True)

    class Meta:
        model = AccountUser
        fields = ['username', 'email', 'password1', 'password2', 'bio', 'url']
