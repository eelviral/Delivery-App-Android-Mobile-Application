from django.contrib.auth import get_user_model
from django.contrib.auth import authenticate
from django.utils.translation import ugettext_lazy as _

from rest_framework import serializers
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer as JwtTokenObtainPairSerializer

from .models import Role, Account, UserDetail
from django.contrib.auth import get_user_model


class TokenObtainPairSerializer(JwtTokenObtainPairSerializer):
    username_field = get_user_model().USERNAME_FIELD


class LoginSerializer(serializers.Serializer):
    email = serializers.CharField(max_length=255)
    password = serializers.CharField(
        label=_("Password"),
        style={'input_type': 'password'},
        trim_whitespace=False,
        max_length=128,
        write_only=True
    )

    def validate(self, data):
        username = data.get('email')
        password = data.get('password')

        if username and password:
            user = authenticate(request=self.context.get('request'),
                                username=username, password=password)
            if not user:
                msg = _('Unable to log in with provided credentials.')
                raise serializers.ValidationError(msg, code='authorization')
        else:
            msg = _('Must provide a valid email and password.')
            raise serializers.ValidationError(msg, code='authorization')

        data['user'] = user
        return data


class UserDetailSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserDetail
        fields = '__all__'


class UserLogoSerializer(serializers.ModelSerializer):
    class Meta:
        model = Account
        fields = ['avatar']


class SprinterRegistrationSerializer(serializers.ModelSerializer):
    confirm_password = serializers.CharField(
        style={'input_type': 'password'}, write_only=True)

    class Meta:
        model = Account
        fields = ('email',
                  'first_name',
                  'last_name',
                  'phone',
                  'password',
                  'confirm_password',
                  'home_address',
                  'home_state',
                  'home_unit',
                  'home_city',
                  'date_of_birth',
                  'mailing_address',
                  'mailing_unit',
                  'mailing_city',
                  'mailing_state',)
        extra_kwargs = {'password': {'write_only': True}}

    def create(self, validated_data):
        account = Account.objects.create(
            email=self.validated_data['email'],
            first_name=self.validated_data['first_name'],
            last_name=self.validated_data['last_name'],
            phone=self.validated_data['phone'],
            home_address=self.validated_data['home_address'],
            home_state=self.validated_data['home_state'],
            home_unit=self.validated_data['home_unit'],
            home_city=self.validated_data['home_city'],
            date_of_birth=self.validated_data['date_of_birth'],
            mailing_address=self.validated_data['mailing_address'],
            mailing_unit=self.validated_data['mailing_unit'],
            mailing_city=self.validated_data['mailing_city'],
            mailing_state=self.validated_data['mailing_state'],
        )
        account.roles.add(Role.objects.get(id=Role.SPRINTER))

        password = self.validated_data['password']
        confirm_password = self.validated_data['confirm_password']

        if password != confirm_password:
            raise serializers.ValidationError(
                {'password': 'Passwords must match.'})
        account.set_password(password)
        account.save()
        return account


class ResidentRegistrationSerializer(serializers.ModelSerializer):
    confirm_password = serializers.CharField(
        style={'input_type': 'password'}, write_only=True)

    class Meta:
        model = Account
        fields = ('email',
                  'first_name',
                  'last_name',
                  'phone',
                  #   'avatar',
                  'password',
                  'confirm_password',)
        extra_kwargs = {'password': {'write_only': True}}

    def create(self, validated_data):
        account = Account.objects.create(
            email=self.validated_data['email'],
            first_name=self.validated_data['first_name'],
            last_name=self.validated_data['last_name'],
            phone=self.validated_data['phone'],
            # avatar=self.validated_data['avatar'],
        )
        account.roles.add(Role.objects.get(id=Role.RESIDENT))

        images_data = self.context.get('request').FILES
        if images_data is not None:
            account.avatar = next(iter(images_data.values()))

        password = self.validated_data['password']
        confirm_password = self.validated_data['confirm_password']

        if password != confirm_password:
            raise serializers.ValidationError(
                {'password': 'Passwords must match.'})
        account.set_password(password)
        account.save()
        return account


class ShopperRegistrationSerializer(serializers.ModelSerializer):
    confirm_password = serializers.CharField(
        style={'input_type': 'password'}, write_only=True)

    class Meta:
        model = Account
        fields = ('email',
                  'first_name',
                  'last_name',
                  'phone',
                  #   'avatar',
                  'password',
                  'confirm_password',)
        extra_kwargs = {'password': {'write_only': True}}

    def create(self, validated_data):
        account = Account.objects.create(
            email=self.validated_data['email'],
            first_name=self.validated_data['first_name'],
            last_name=self.validated_data['last_name'],
            phone=self.validated_data['phone'],
            # avatar=self.validated_data['avatar'],
        )
        account.roles.add(Role.objects.get(id=Role.SHOPPER))

        password = self.validated_data['password']
        confirm_password = self.validated_data['confirm_password']

        if password != confirm_password:
            raise serializers.ValidationError(
                {'password': 'Passwords must match.'})
        account.set_password(password)
        account.save()
        return account
