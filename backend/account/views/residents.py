from django.contrib.auth.decorators import login_required
from rest_framework import permissions, parsers, status, viewsets
from rest_framework.authtoken.models import Token
from rest_framework.decorators import api_view, action
from rest_framework.response import Response
from rest_framework.status import HTTP_201_CREATED, HTTP_400_BAD_REQUEST, HTTP_404_NOT_FOUND
from rest_framework.views import APIView


from ..models import Account, UserDetail
from ..serializers import ResidentRegistrationSerializer, UserDetailSerializer, UserLogoSerializer
from ..decorators import resident_required
from ..utils import MultiPartJSONParser


class ResidentRegistrationView(APIView):
    permission_classes = (permissions.AllowAny,)
    parser_classes = (MultiPartJSONParser,)

    def post(self, request, *args, **kwargs):
        serializer = ResidentRegistrationSerializer(data=request.data, context={'request': request})
        data = {}
        if serializer.is_valid():
            account = serializer.save()
            data['response'] = "Successfully registered as a resident."
            data['id'] = account.id
            data['email'] = account.email
            token = Token.objects.get(user=account).key
            data['token'] = token
            return Response(data, status=HTTP_201_CREATED)
        else:
            data = serializer.errors
        return Response(data, status=HTTP_400_BAD_REQUEST)


class UserDetailViewSet(viewsets.ModelViewSet):
    queryset = Account.objects.all()
    serializer_class = UserDetailSerializer
    permission_classes = [permissions.AllowAny]

    @action(detail=True, methods=['post'])
    def set_profile_picture(self, request, pk=None, format=None):
        if pk in ['none', 'self']:  # shortcut to update logged in user without looking for the id
            try:
                userdetail = self.get_queryset().get(user=request.user)
            except UserDetail.DoesNotExist:
                userdetail = None
        else:
            userdetail = self.get_or_create_object()

        serializer = UserLogoSerializer(userdetail, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@login_required
@resident_required
@api_view(['GET'])
def resident_profile_view(request, *args, **kwargs):
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
