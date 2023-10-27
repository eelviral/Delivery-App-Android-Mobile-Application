from django.utils.decorators import method_decorator
from django.contrib.auth.decorators import login_required

from rest_framework import status, permissions
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.status import HTTP_200_OK, HTTP_400_BAD_REQUEST

from account.decorators import sprinter_required
from .models import Coordinates
from .serializers import CoordinateSerializer
from .utils import Location, closest_EZ


class RouteView(APIView):
    permission_classes = (permissions.IsAuthenticated,)

    def post(self, *args, **kwargs):
        serializer = CoordinateSerializer(data=self.request.data)
        data = {}
        if serializer.is_valid():
            latitude = serializer.data['latitude']
            longitude = serializer.data['longitude']
            try:
                data['response'] = "Successfully found closest EZ location"
                sprinter_location = Location(latitude, longitude)
                data['EZ_location'] = closest_EZ(sprinter_location)
            except ValueError:
                data['response'] = "Failed to find closest EZ location"
            return Response(data, status=HTTP_200_OK)
        else:
            data = serializer.errors
        return Response(data, status=HTTP_400_BAD_REQUEST)


@api_view(['GET'])
def get_coordinates(request):
    coordinates = Coordinates.objects.all()
    serializer = CoordinateSerializer(coordinates, many=True)
    return Response(serializer.data)


@api_view(['GET'])
def get_coordinate(request, slug):
    try:
        coordinate = Coordinates.objects.get(slug=slug)
    except Coordinates.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)

    if request.method == "GET":
        serializer = CoordinateSerializer(coordinate)
    return Response(serializer.data)


@api_view(['PUT'])
def update_coordinates(request, slug):
    try:
        coordinates = Coordinates.objects.get(slug=slug)
    except Coordinates.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)

    if request.method == "PUT":
        serializer = CoordinateSerializer(coordinates)
        data = {}
        if serializer.is_valid():
            serializer.save()
            data['success'] = "update successful"
            return Response(data=data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
