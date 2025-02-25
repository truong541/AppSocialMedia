from django.db import models
from account.models import User
import os

def upload_to(instance, filename):
    return os.path.join('message', f"{filename}")

class Message(models.Model):
    idMessage = models.AutoField(primary_key=True)
    sender = models.ForeignKey(User, on_delete=models.CASCADE, related_name="sent", db_column='idSender')
    receiver = models.ForeignKey(User, on_delete=models.CASCADE, related_name="received", db_column='idReceiver')
    content = models.TextField()
    image = models.ImageField(upload_to=upload_to, null=True, blank=True)
    isRead = models.BooleanField(default=False)
    isDeleted = models.BooleanField(default=False)
    createdAt = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = "messages"
        ordering = ["-createdAt"]


