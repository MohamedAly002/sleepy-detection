import 'dart:math';

import 'package:driver_drowsiness_alert/Api%20models/location_info/lat_lng.dart';
import 'package:driver_drowsiness_alert/Api%20models/location_info/location.dart';
import 'package:driver_drowsiness_alert/Api%20models/location_info/location_info.dart';
import 'package:driver_drowsiness_alert/Api%20models/place_autocomplete_model/place_autocomplete_model.dart';
import 'package:driver_drowsiness_alert/Api%20models/place_details_model/place_details_model.dart';
import 'package:driver_drowsiness_alert/Api%20models/routes_model/routes_model.dart';
import 'package:driver_drowsiness_alert/utils/Location%20Services/Location_Service.dart';
import 'package:driver_drowsiness_alert/utils/Location%20Services/google_maps_place_service.dart';
import 'package:driver_drowsiness_alert/utils/Location%20Services/routes_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapServices {
  PlacesService placesService = PlacesService();
  LocationService locationService = LocationService();
  RoutesService routesService = RoutesService();
  LatLng? currentLocation;
  bool firstcall = true;
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
        required Function onUpdatecurrentLocation}) {
    locationService.getRealTimeLocationData((locationData) {
      currentLocation = LatLng(locationData.latitude!, locationData.longitude!);

      // Only add marker if it's not already added
      if (!markers.any((marker) => marker.markerId.value == 'my location')) {
        Marker currentLocationMarker = Marker(
          markerId: MarkerId('my location'),
          position: currentLocation!,
        );
        markers.add(currentLocationMarker);
      }

      // Check if it's the first call, if so, move the camera to current location
      if (firstcall) {
        CameraPosition myCurrentCameraPoistion = CameraPosition(
          target: currentLocation!,
          zoom: 17,
        );
        googleMapController.animateCamera(
            CameraUpdate.newCameraPosition(myCurrentCameraPoistion));
        firstcall = false; // Set first call to false after the initial camera update
      }

      // No camera update here to prevent automatic centering on user's location

      onUpdatecurrentLocation();
    });
  }


  Future<PlaceDetailsModel> getPlaceDetails({required String placeId}) async {
    return await placesService.getPlaceDetails(placeId: placeId);
  }
}
