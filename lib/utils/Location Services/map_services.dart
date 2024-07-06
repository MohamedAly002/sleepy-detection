import 'dart:math';
import 'dart:typed_data';
import 'package:driver_drowsiness_alert/utils/Location%20Services/routes_service.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;

import '../../Api models/location_info/lat_lng.dart';
import '../../Api models/location_info/location.dart';
import '../../Api models/location_info/location_info.dart';
import '../../Api models/place_autocomplete_model/place_autocomplete_model.dart';
import '../../Api models/place_details_model/place_details_model.dart';
import '../../Api models/routes_model/routes_model.dart';
import 'Location_Service.dart';
import 'google_maps_place_service.dart';

class MapServices {
  PlacesService placesService = PlacesService();
  LocationService locationService = LocationService();
  RoutesService routesService = RoutesService();
  LatLng? currentLocation;
  bool firstcall = true;

  Future<BitmapDescriptor> getCustomMarker() async {
    final Uint8List markerIcon = await getBytesFromAsset('assets/home_location.png', 100);
    return BitmapDescriptor.fromBytes(markerIcon);
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  Future<void> getPredictions(
      {required String input,
        required String sesstionToken,
        required List<PlaceModel> places}) async {
    if (input.isNotEmpty) {
      var result = await placesService.getPredictions(
          sesstionToken: sesstionToken, input: input);

      places.clear();
      places.addAll(result);
    } else {
      places.clear();
    }
  }

  Future<List<LatLng>> getRouteData({required LatLng desintation}) async {
    LocationInfoModel origin = LocationInfoModel(
      location: LocationModel(
          latLng: LatLngModel(
            latitude: currentLocation!.latitude,
            longitude: currentLocation!.longitude,
          )),
    );
    LocationInfoModel destination = LocationInfoModel(
      location: LocationModel(
          latLng: LatLngModel(
            latitude: desintation.latitude,
            longitude: desintation.longitude,
          )),
    );
    RoutesModel routes = await routesService.fetchRoutes(
        origin: origin, destination: destination);
    PolylinePoints polylinePoints = PolylinePoints();
    List<LatLng> points = getDecodedRoute(polylinePoints, routes);
    return points;
  }

  List<LatLng> getDecodedRoute(
      PolylinePoints polylinePoints, RoutesModel routes) {
    List<PointLatLng> result = polylinePoints.decodePolyline(
      routes.routes!.first.polyline!.encodedPolyline!,
    );

    List<LatLng> points =
    result.map((e) => LatLng(e.latitude, e.longitude)).toList();
    return points;
  }

  void displayRoute(List<LatLng> points,
      {required Set<Polyline> polyLines,
        required GoogleMapController googleMapController}) {
    Polyline route = Polyline(
      color: Colors.blue,
      width: 5,
      polylineId: const PolylineId('route'),
      points: points,
    );

    polyLines.add(route);

    LatLngBounds bounds = getLatLngBounds(points);
    googleMapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 32));
  }

  LatLngBounds getLatLngBounds(List<LatLng> points) {
    var southWestLatitude = points.first.latitude;
    var southWestLongitude = points.first.longitude;
    var northEastLatitude = points.first.latitude;
    var northEastLongitude = points.first.longitude;

    for (var point in points) {
      southWestLatitude = min(southWestLatitude, point.latitude);
      southWestLongitude = min(southWestLongitude, point.longitude);
      northEastLatitude = max(northEastLatitude, point.latitude);
      northEastLongitude = max(northEastLongitude, point.longitude);
    }

    return LatLngBounds(
        southwest: LatLng(southWestLatitude, southWestLongitude),
        northeast: LatLng(northEastLatitude, northEastLongitude));
  }

  void updateCurrentLocation(
      {required GoogleMapController googleMapController,
        required Set<Marker> markers,
        required Function onUpdatecurrentLocation}) async {

    BitmapDescriptor customMarker = await getCustomMarker();

    locationService.getRealTimeLocationData((locationData) {
      currentLocation = LatLng(locationData.latitude!, locationData.longitude!);

      Marker currentLocationMarker = Marker(
        markerId: MarkerId('my location'),
        position: currentLocation!,
        icon: customMarker,
      );

      markers.removeWhere((marker) => marker.markerId.value == 'my location');
      markers.add(currentLocationMarker);

      if (firstcall) {
        CameraPosition myCurrentCameraPoistion = CameraPosition(
          target: currentLocation!,
          zoom: 17,
        );
        googleMapController.animateCamera(
            CameraUpdate.newCameraPosition(myCurrentCameraPoistion));
        firstcall = false;
      }

      onUpdatecurrentLocation();
    });
  }

  void addDestinationMarker(
      {required LatLng destination, required Set<Marker> markers}) {
    Marker destinationMarker = Marker(
      markerId: MarkerId('destination'),
      position: destination,
    );

    markers.removeWhere((marker) => marker.markerId.value == 'destination');
    markers.add(destinationMarker);
  }

  Future<PlaceDetailsModel> getPlaceDetails({required String placeId}) async {
    return await placesService.getPlaceDetails(placeId: placeId);
  }
}
