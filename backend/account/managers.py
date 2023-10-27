from django.contrib.auth.models import BaseUserManager
from datetime import datetime


class AccountManager(BaseUserManager):
    def _create_user(self, email, password, is_staff, is_admin, is_superuser, **extra_fields):
        '''
        Creates and saves a User with the given email and password.
        '''
        if not email:
            raise ValueError('Users must have an email address')
        now = datetime.now()

        user = self.model(
            email=self.normalize_email(email),
            is_staff=is_staff,
            is_admin=is_admin,
            is_superuser=is_superuser,
            is_active=True,
            last_login=now,
            date_joined=now,
            **extra_fields
        )

        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_user(self, email=None, password=None, **extra_fields):
        return self._create_user(
            email=email,
            password=password,
            is_staff=False,
            is_admin=False,
            is_superuser=False,
            **extra_fields)

    def create_superuser(self, email, password, **extra_fields):
        user = self._create_user(
            email=email,
            password=password,
            is_staff=True,
            is_admin=True,
            is_superuser=True,
            **extra_fields)

        user.set_password(password)
        user.save(using=self._db)
        return user
