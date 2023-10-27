import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:sprinters/assets/constants/constants.dart';
import 'package:sprinters/assets/styles.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:sprinters/utilities/connection.dart';

class MapScreen extends StatefulWidget {
  final Client client;
  final String token;

  const MapScreen({
    Key? key,
    required this.client,
    required this.token,
  }) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LatLng merchantLocation;
  final Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController _googleMapController;
  LocationData? currentLocation;
  bool searching = false;
  bool found = false;
  bool sprinting = false;

  final Map<MarkerId, Marker> _markers = {};

  final Map<PolylineId, Polyline> _polylines = {};

  BitmapDescriptor merchantIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor exchangeZoneIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor sprinterIcon = BitmapDescriptor.defaultMarker;

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void getCurrentLocation() async {
    Location location = Location();

    await location.getLocation().then((location) => currentLocation = location);
    setState(() {});
    _addMarker(
        LatLng(
          currentLocation!.latitude!,
          currentLocation!.longitude!,
        ),
        "sprinter",
        sprinterIcon,
        rotation: currentLocation!.heading!);

    _googleMapController = await _controller.future;

    location.onLocationChanged.listen(
      (newLocation) {
        currentLocation = newLocation;

        if (!found) {
          _googleMapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                zoom: 15,
                target: LatLng(
                  newLocation.latitude!,
                  newLocation.longitude!,
                ),
              ),
            ),
          );
        }
        setState(() {});
      },
    );
  }

  void animateToRoute(LatLng fromLocationLatLng, LatLng toLocationLatLng) {
    _googleMapController.animateCamera(
      CameraUpdate.newLatLngBounds(
          LatLngBounds(
              southwest: LatLng(
                  fromLocationLatLng.latitude <= toLocationLatLng.latitude
                      ? fromLocationLatLng.latitude
                      : toLocationLatLng.latitude,
                  fromLocationLatLng.longitude <= toLocationLatLng.longitude
                      ? fromLocationLatLng.longitude
                      : toLocationLatLng.longitude),
              northeast: LatLng(
                  fromLocationLatLng.latitude <= toLocationLatLng.latitude
                      ? toLocationLatLng.latitude
                      : fromLocationLatLng.latitude,
                  fromLocationLatLng.longitude <= toLocationLatLng.longitude
                      ? toLocationLatLng.longitude
                      : fromLocationLatLng.longitude)),
          100),
    );
  }

  void setCustomMarkerIcon() async {
    await getBytesFromAsset('assets/images/store.bmp', 100).then(
      (icon) {
        merchantIcon = BitmapDescriptor.fromBytes(icon);
      },
    );
    await getBytesFromAsset('assets/images/EZ.bmp', 100).then(
      (icon) {
        exchangeZoneIcon = BitmapDescriptor.fromBytes(icon);
      },
    );
    await getBytesFromAsset('assets/images/arrow.bmp', 50).then(
      (icon) {
        sprinterIcon = BitmapDescriptor.fromBytes(icon);
      },
    );
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor,
      {double rotation = 0.0}) {
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(
        markerId: markerId,
        icon: descriptor,
        position: position,
        rotation: rotation);
    _markers[markerId] = marker;
  }

  _addPolyLine(String id, List<LatLng> polylineCoordinates) {
    PolylineId polylineId = PolylineId(id);
    Polyline polyline = Polyline(
      polylineId: polylineId,
      points: polylineCoordinates,
      color: relaiGreen,
      width: 8,
    );
    _polylines[polylineId] = polyline;
    setState(() {});
  }

  void getPolyPoints(LatLng merchantLocation, LatLng exchangeZoneLocation) async {
    _addMarker(merchantLocation, "merchant", merchantIcon);
    _addMarker(exchangeZoneLocation, "exchangeZoneLocation", exchangeZoneIcon);

    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey,
      PointLatLng(merchantLocation.latitude, merchantLocation.longitude),
      PointLatLng(exchangeZoneLocation.latitude, exchangeZoneLocation.longitude),
    );

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }
    setState(() {});
    _addPolyLine("merchantToExchangeZone", polylineCoordinates);
  }

  void getPolyLine(LatLng merchantLocation) async {
    _addMarker(merchantLocation, "merchant", merchantIcon);
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey,
      PointLatLng(currentLocation!.latitude!, currentLocation!.longitude!),
      // const PointLatLng(37.5561, -77.4661),
      PointLatLng(merchantLocation.latitude, merchantLocation.longitude),
    );

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }
    setState(() {});
    _addPolyLine("sprinterToMerchant", polylineCoordinates);
  }

  @override
  void initState() {
    getCurrentLocation();
    setCustomMarkerIcon();
    super.initState();
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  // Get coordinate and map data from the server
  _load() async {
    final connection = ServerConnect(context, widget.client);
    final response = await connection.getEZRoute(
      widget.token,
      currentLocation!.latitude!,
      currentLocation!.longitude!,
    );
    _showEZRoute(response);
  }

  _showEZRoute(Response response) {
    final data = json.decode(response.body);
    setState(() {
      merchantLocation = const LatLng(
        37.5451594,
        -77.4394543,
      );
    });
    LatLng exchangeZoneLocation = LatLng(
      data['EZ_location']['latitude'],
      data['EZ_location']['longitude'],
    );
    getPolyPoints(merchantLocation, exchangeZoneLocation);
    if (mounted) {
      setState(() {
        found = true;
      });
    }
    animateToRoute(merchantLocation, exchangeZoneLocation);
  }

  @override
  Widget build(BuildContext context) {
    if (currentLocation != null) {
      _markers.addAll({
        const MarkerId("sprinter"): Marker(
          position: LatLng(
            currentLocation!.latitude!,
            currentLocation!.longitude!,
          ),
          markerId: const MarkerId("sprinter"),
          icon: sprinterIcon,
          rotation: currentLocation!.heading!,
        )
      });
    }
    // if (sprinting) {
    //   _polylines.addAll({
    //     const PolylineId("currentToSource"):
    // Polyline(
    //   polylineId: const PolylineId("currentToSource"),
    //   points: polylineCoordinates,
    //   color: relaiGreen,
    //   width: 8,
    // );
    //   })
    //   setState(() {});
    // }
    return currentLocation == null
        ? Center(child: Text("Loading...", style: barlowFont))
        : Stack(
            children: <Widget>[
              GoogleMap(
                zoomControlsEnabled: false,
                zoomGesturesEnabled: false,
                scrollGesturesEnabled: false,
                minMaxZoomPreference: const MinMaxZoomPreference(0.0, 15.0),
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    currentLocation != null
                        ? currentLocation!.latitude!
                        : 37.559258, // Richmond's latitude
                    currentLocation != null
                        ? currentLocation!.longitude!
                        : -77.470910, // Richmond's longitude
                  ),
                  zoom: 17,
                ),
                onMapCreated: (GoogleMapController controller) {
                  _googleMapController = controller;
                },
                polylines: Set<Polyline>.of(_polylines.values),
                markers: Set<Marker>.of(_markers.values),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: found || sprinting
                    ? null
                    : Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FloatingActionButton.extended(
                              label: searching
                                  ? Text("Searching...",
                                      style: barlowFont.copyWith(
                                          fontWeight: FontWeight.bold))
                                  : Text("Start Sprinting",
                                      style: barlowFont.copyWith(
                                          fontWeight: FontWeight.bold)),
                              onPressed: () {
                                if (mounted) {
                                  setState(() {
                                    if (searching) {
                                      searching = false;
                                    } else {
                                      searching = true;
                                    }
                                  });
                                }
                                _load();
                              },
                              backgroundColor: Colors.black87,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(width: 4, color: relaiGreen),
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                          ],
                        ),
                      ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: found && !sprinting
                    ? Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FloatingActionButton.extended(
                              label: Text("Accept Delivery",
                                  style: barlowFont.copyWith(
                                      fontWeight: FontWeight.bold)),
                              onPressed: () async {
                                getPolyLine(merchantLocation);
                                setState(() {
                                  found = false;
                                  sprinting = true;
                                });
                              },
                              backgroundColor: Colors.black87,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(width: 4, color: relaiGreen),
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                          ],
                        ),
                      )
                    : null,
              ),
            ],
          );
  }
}
