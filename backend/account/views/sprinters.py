from django.contrib.auth.decorators import login_required
from rest_framework import permissions
from rest_framework.authtoken.models import Token
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework.status import HTTP_201_CREATED, HTTP_400_BAD_REQUEST, HTTP_404_NOT_FOUND
from rest_framework.views import APIView
from rest_framework.renderers import JSONRenderer, BrowsableAPIRenderer

from ..models import Account
from ..serializers import SprinterRegistrationSerializer
from ..decorators import sprinter_required


class SprinterRegistrationView(APIView):
    permission_classes = (permissions.AllowAny,)
    renderer_classes = [JSONRenderer, BrowsableAPIRenderer]

    def post(self, request, *args, **kwargs):
        serializer = SprinterRegistrationSerializer(data=request.data)
        data = {}
        if serializer.is_valid():
            account = serializer.save()
            data['response'] = "Successfully registered as a sprinter."
            data['id'] = account.id
            data['email'] = account.email
            token = Token.objects.get(user=account).key
            data['token'] = token
            return Response(data, status=HTTP_201_CREATED)
        else:
            data = serializer.errors
        return Response(data, status=HTTP_400_BAD_REQUEST)


# @login_required
# @sprinter_required
@api_view(['GET'])
def sprinter_profile_view(request, *args, **kwargs):
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
        data['home_address'] = account.home_address
        data['home_unit'] = account.home_unit
        data['home_city'] = account.home_city
        data['home_state'] = account.home_state
        data['date_of_birth'] = account.date_of_birth
        data['mailing_address'] = account.mailing_address
        data['mailing_unit'] = account.mailing_unit
        data['mailing_city'] = account.mailing_city
        data['mailing_state'] = account.mailing_state
        # context['hide_email'] = account.hide_email

        # data['BASE_URL'] = settings.BASE_URL

    return Response(data)
