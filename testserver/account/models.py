from django.db import models
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager
from django.core.validators import RegexValidator

class UserManager(BaseUserManager):
    def normalize_email(self, email):
    # Đảm bảo email không bị thay đổi phần domain
        email = email or ''
        try:
            email_name, domain_part = email.strip().rsplit('@', 1)
            email = email_name + '@' + domain_part.lower()
        except ValueError:
            pass
        return email

    def create_user(self, fullname, username, gender, email, password=None, **extra_fields):
        if not email:
            raise ValueError('The Email field must be set')
        email = self.normalize_email(email)
        user = self.model(fullname=fullname, username=username, gender=gender, email=email, **extra_fields)
        user.set_password(password)
        user.save(using=self._db)
        return user
    
    def create_superuser(self, fullname, username, gender, email, password=None, **extra_fields):
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)
        return self.create_user(fullname, username, gender, email, password, **extra_fields)

class User(AbstractBaseUser):
    idUser = models.AutoField(primary_key=True)
    idGoogle = models.CharField(max_length=245)
    fullname = models.CharField(max_length=100)
    username_validator = RegexValidator(
        regex=r'^[a-zA-Z0-9_.]+$', 
        message="Username can only contain letters, numbers, '_' and '.'"
    )
    username = models.CharField(max_length=50, unique=True, validators=[username_validator])
    gender = models.CharField(max_length=10)
    email = models.EmailField(max_length=245, unique=True)
    password = models.CharField(max_length=255)
    avatar = models.ImageField(upload_to='avatar/')
    bio = models.TextField(null=True, blank=True)
    createdAt = models.DateTimeField(auto_now_add=True)
    is_staff = models.BooleanField(default=False)  # Đảm bảo trường này có mặt
    is_active = models.BooleanField(default=True)
    last_login = models.DateTimeField(null=True, blank=True)

    objects = UserManager()

    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['username']

    class Meta:
        db_table = 'users'

    def __str__(self):
        return self.username
    
    def save(self, *args, **kwargs):
        if not self.avatar:
            if self.gender == 'female':
                self.avatar = 'avatar/default_female_avatar.png'
            else:
                self.avatar = 'avatar/default_male_avatar.png'
        super().save(*args, **kwargs)
    
class Follow(models.Model):
    idFollow = models.AutoField(primary_key=True)
    idFollower = models.ForeignKey(User, related_name='user_tap_follow', on_delete=models.CASCADE, db_column='idFollower')
    idFollowing = models.ForeignKey(User, related_name='user_is_following', on_delete=models.CASCADE, db_column='idFollowing')
    createdAt = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'follows'
        unique_together = ('idFollower', 'idFollowing')

    def __str__(self):
        return f"{self.idFollower.username} follows {self.idFollowing.username}"

class ViewedUser(models.Model):
    idViewedUser = models.AutoField(primary_key=True)
    user = models.ForeignKey(User, related_name='viewed_by_users', on_delete=models.CASCADE, db_column='idUser')
    idViewer = models.ForeignKey(User, related_name='viewed_users', on_delete=models.CASCADE, db_column='idViewer')
    createdAt = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'viewedusers'

    def __str__(self):
        return f"{self.user.idUser} follows {self.idViewer.idUser}"