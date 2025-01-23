from django.db import models
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager

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

    def create_user(self, username, email, password=None, **extra_fields):
        if not email:
            raise ValueError('The Email field must be set')
        email = self.normalize_email(email)
        user = self.model(username=username, email=email, **extra_fields)
        user.set_password(password)
        user.save(using=self._db)
        return user
    
    def create_superuser(self, username, email, password=None, **extra_fields):
        extra_fields.setdefault('is_staff', True)  # Đảm bảo is_staff được đặt là True
        extra_fields.setdefault('is_superuser', True)  # Đảm bảo is_superuser được đặt là True
        return self.create_user(username, email, password, **extra_fields)

class User(AbstractBaseUser):
    idUser = models.AutoField(primary_key=True)
    idGoogle = models.CharField(max_length=245)
    username = models.CharField(max_length=50)
    email = models.EmailField(max_length=245, unique=True)
    password = models.CharField(max_length=255)
    profileImage = models.ImageField(upload_to='image/', null=True, blank=True, default='')
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
    
class Follow(models.Model):
    idFollow = models.AutoField(primary_key=True)
    idFollower = models.ForeignKey(User, related_name='idFollower', on_delete=models.CASCADE, db_column='idFollower')
    idFollowing = models.ForeignKey(User, related_name='idFollowing', on_delete=models.CASCADE, db_column='idFollowing')
    createdAt = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'follows'
        unique_together = ('idFollower', 'idFollowing')

    def __str__(self):
        return f"{self.idFollower.username} follows {self.idFollowing.username}"
