import datetime
from django.db import models
from django.core.mail import send_mail
from django.contrib.auth.models import PermissionsMixin
from django.contrib.auth.base_user import AbstractBaseUser
from rest_framework.authtoken.models import Token
from django.utils.translation import ugettext_lazy as _

from django.dispatch import receiver
from django.db.models.signals import post_save
from django.conf import settings

from .managers import AccountManager


class Role(models.Model):
    '''
    The Role entries are managed by the system,
    automatically created via a Django data migration.
    '''
    SPRINTER = 1
    RESIDENT = 2
    SHOPPER = 3
    ADMIN = 4
    ROLE_CHOICES = (
        (SPRINTER, 'sprinter'),
        (RESIDENT, 'resident'),
        (SHOPPER, 'shopper'),
        (ADMIN, 'admin'),
    )

    id = models.PositiveSmallIntegerField(choices=ROLE_CHOICES, primary_key=True)

    def __str__(self):
        return self.get_id_display()


class Account(AbstractBaseUser, PermissionsMixin):
    roles = models.ManyToManyField(Role)
    is_sprinter = models.BooleanField(default=False)
    is_resident = models.BooleanField(default=False)
    is_shopper = models.BooleanField(default=False)

    email = models.EmailField(verbose_name="email", max_length=60, unique=True)
    first_name = models.CharField(verbose_name="first name", max_length=60, null=True)
    last_name = models.CharField(verbose_name="last name", max_length=60, null=True)
    phone = models.CharField(verbose_name="phone", max_length=20, null=True)
    avatar = models.ImageField(upload_to="avatars/users/", null=True, blank=True, default="avatars/default/default-avatar.png")

    home_address = models.CharField(verbose_name="home address", max_length=100, null=True)
    home_state = models.CharField(verbose_name="home state", max_length=15, null=True)
    home_unit = models.CharField(verbose_name="home unit", max_length=15, null=True)
    home_city = models.CharField(verbose_name="home city", max_length=50, null=True)
    date_of_birth = models.DateField(verbose_name="date of birth", max_length=8, default=datetime.date.today)
    mailing_address = models.CharField(verbose_name="mailing address", max_length=100, null=True)
    mailing_unit = models.CharField(verbose_name="mailing unit", max_length=15, null=True)
    mailing_city = models.CharField(verbose_name="mailing city", max_length=50, null=True)
    mailing_state = models.CharField(verbose_name="mailing state", max_length=15, null=True)

    is_active = models.BooleanField(default=True)
    date_joined = models.DateTimeField(verbose_name="date joined", auto_now_add=True)
    last_login = models.DateTimeField(verbose_name="last login", auto_now=True)
    is_staff = models.BooleanField(default=False)
    is_admin = models.BooleanField(default=False)
    is_superuser = models.BooleanField(default=False)

    objects = AccountManager()

    USERNAME_FIELD = 'email'
    EMAIL_FIELD = 'email'
    REQUIRED_FIELDS = []

    class Meta:
        verbose_name = _('account')
        verbose_name_plural = _('accounts')

    def __str__(self):
        return self.email

    def get_absolute_url(self):
        return "accounts/profile/%i/" % (self.pk)

    def has_perm(self, perm, obj=None):
        return True
        # return self.is_admin

    # Determines if user has permission to view app
    def has_module_perms(self, app_label):
        return True

    def get_full_name(self):
        '''
        Returns the first_name plus the last_name, with a space in between.
        '''
        full_name = '%s %s' % (self.first_name, self.last_name)
        return full_name.strip()

    def get_short_name(self):
        '''
        Returns the short name for the user.
        '''
        return self.first_name

    def email_user(self, subject, message, from_email=None, **kwargs):
        '''
        Sends an email to this User.
        '''
        send_mail(subject, message, from_email, [self.email], **kwargs)


class UserDetail(models.Model):
    user = models.OneToOneField(Account, on_delete=models.CASCADE, primary_key=True)
    avatar = models.ImageField(upload_to='avatars/')


class Sprinter(models.Model):
    account = models.OneToOneField(settings.AUTH_USER_MODEL, on_delete=models.CASCADE,
                                   primary_key=True, related_name="profile")

    def __str__(self):
        return self.account.username


class Resident(models.Model):
    account = models.OneToOneField(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, primary_key=True)

    def __str__(self):
        return self.account.username


class Shopper(models.Model):
    account = models.OneToOneField(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, primary_key=True)

    def __str__(self):
        return self.account.username


@receiver(post_save, sender=settings.AUTH_USER_MODEL)
def create_auth_token(sender, instance=None, created=False, **kwargs):
    if created:
        Token.objects.create(user=instance)
