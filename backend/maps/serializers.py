from rest_framework import serializers

from .models import Coordinates


class CoordinateSerializer(serializers.ModelSerializer):

    class Meta:
        model = Coordinates
        fields = (["latitude", "longitude"])
