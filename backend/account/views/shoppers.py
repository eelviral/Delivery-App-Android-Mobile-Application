from django.contrib.auth.decorators import login_required
from rest_framework import permissions
from rest_framework.authtoken.models import Token
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework.status import HTTP_201_CREATED, HTTP_400_BAD_REQUEST, HTTP_404_NOT_FOUND
from rest_framework.views import APIView

from ..models import Account
from ..serializers import ShopperRegistrationSerializer
from ..decorators import shopper_required


class ShopperRegistrationView(APIView):
    permission_classes = (permissions.AllowAny,)

    def post(self, request, *args, **kwargs):
        serializer = ShopperRegistrationSerializer(data=request.data)
        data = {}
        if serializer.is_valid():
            account = serializer.save()
            data['response'] = "Successfully registered as a shopper."
            data['id'] = account.id
            data['email'] = account.email
            token = Token.objects.get(user=account).key
            data['token'] = token
            return Response(data, status=HTTP_201_CREATED)
        else:
            data = serializer.errors
        return Response(data, status=HTTP_400_BAD_REQUEST)


@login_required
@shopper_required
@api_view(['GET'])
def shopper_profile_view(request, *args, **kwargs):
    data = {}
    id = kwargs.get("id")
    try:
        account = Account.objects.get(pk=id)
    except Account.DoesNotExist:
        return Response(data, status=HTTP_404_NOT_FOUND)
    if account:
        data['id'] = account.id
        data['email'] = account.email
        data['first_name'] = account.first_name
        data['last_name'] = account.last_name
        data['phone'] = account.phone

    return Response(data)
