from django.contrib.auth.models import update_last_login
from rest_framework.views import APIView
from rest_framework import permissions, parsers
from rest_framework.authtoken.models import Token
from rest_framework.response import Response
from rest_framework.status import HTTP_200_OK

from ..serializers import LoginSerializer


class LoginView(APIView):
    permission_classes = (permissions.AllowAny,)

    def post(self, request, *args, **kwargs):
        serializer = LoginSerializer(data=request.data, context={'request': request})
        serializer.is_valid(raise_exception=True)
        user = serializer.validated_data['user']
        update_last_login(None, user)
        token, created = Token.objects.get_or_create(user=user)
        return Response({"status": HTTP_200_OK,
                         "token": token.key,
                         "id": token.user_id})
