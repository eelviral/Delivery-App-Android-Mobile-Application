import datetime
from django.conf import settings
import googlemaps
import pandas as pd


class Location:

    def __init__(self, latitude: float, longitude: float):
        self._latitude = latitude
        self._longitude = longitude

    @property
    def latitude(self):
        return self._latitude

    @latitude.setter
    def latitude(self, value):
        if isinstance(value, float):
            self._latitude = value
        else:
            raise TypeError("latitude must be a float")

    @property
    def longitude(self):
        return self._longitude

    @longitude.setter
    def longitude(self, value):
        if isinstance(value, float):
            self._longitude = value
        else:
            raise TypeError("longitude must be a float")

    def as_tuple(self):
        return (self._latitude, self._longitude)

    def reset_coordinates(self, latitude, longitude):
        self._latitude = latitude
        self._longitude = longitude


def find_distance(gmaps: googlemaps.Client, origin: tuple,
                  destination: tuple, transport_mode: str) -> datetime:
    distance = gmaps.distance_matrix(
        origin, destination,
        mode=transport_mode)["rows"][0]["elements"][0]["distance"]["value"]
    return distance / 1.609344


def find_duration(gmaps: googlemaps.Client, origin: tuple,
                  destination: tuple, transport_mode: str) -> datetime:
    seconds = gmaps.distance_matrix(
        origin, destination,
        mode=transport_mode)["rows"][0]["elements"][0]["duration"]["value"]
    return datetime.timedelta(seconds=seconds)


def closest_EZ(sprinter: Location) -> dict:
    df = pd.read_csv(settings.BASE_DIR / 'static/EZ_locations.csv')
    gmaps = googlemaps.Client(key=settings.GOOGLE_MAPS_API_KEY)

    LatOrigin = sprinter.latitude
    LongOrigin = sprinter.longitude
    origin = (LatOrigin, LongOrigin)

    shortest_distance = float("inf")
    ShortOrigin = Location(0, 0)
    ShortDest = Location(0, 0)
    closest_EZ = {
        "id": "",
        "address": "",
        "latitude": "",
        "longitude": "",
        "EZ Distance": "",
        "walking": "",
        "bicycling": "",
        "driving": "",
    }

    for _, row in df.iterrows():
        LatDest = row["latitude"]
        LongDest = row["longitude"]
        destination = (LatDest, LongDest)
        walking_distance = find_distance(gmaps, origin, destination, "walking")
        if walking_distance < shortest_distance:
            shortest_distance = walking_distance
            ShortOrigin.reset_coordinates(origin[0], origin[1])
            ShortDest.reset_coordinates(destination[0], destination[1])

    short_origin = ShortOrigin.as_tuple()
    short_dest = ShortDest.as_tuple()
    walking_duration = find_duration(gmaps, short_origin, short_dest, "walking")
    driving_distance = find_distance(gmaps, short_origin, short_dest, "driving")
    driving_duration = find_duration(gmaps, short_origin, short_dest, "driving")
    bicycling_distance = find_distance(gmaps, short_origin, short_dest, "bicycling")
    bicycling_duration = find_duration(gmaps, short_origin, short_dest, "bicycling")
    closest_EZ = {
        "id": row["id"],
        "address": row["address"],
        "latitude": ShortDest.latitude,
        "longitude": ShortDest.longitude,
        "walking": {
            "distance_km": str(round(shortest_distance / 1000, 3)),
            "duration": str(walking_duration),
        },
        "bicycling": {
            "distance_km": str(round(bicycling_distance / 1000, 3)),
            "duration": str(bicycling_duration),
        },
        "driving": {
            "distance_km": str(round(driving_distance / 1000, 3)),
            "duration": str(driving_duration),
        },
    }
    return closest_EZ
