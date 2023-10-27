from django.urls import path
from .views import(
    RouteView,
    get_coordinate,
    get_coordinates,
    update_coordinates
)

app_name = "maps"

urlpatterns = [
    path('route/', RouteView.as_view(), name="find route"),
    path('', get_coordinates, name="get_all coordinates"),
    path('<str:slug>/', get_coordinate, name="get coordinates"),
    path('<str:slug>/update/', update_coordinates, name="update coordinates"),
]
