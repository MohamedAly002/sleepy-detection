import 'dart:async';
import 'package:driver_drowsiness_alert/Api%20models/place_autocomplete_model/place_autocomplete_model.dart';
import 'package:driver_drowsiness_alert/custom%20widgets/custom_list_view.dart';
import 'package:driver_drowsiness_alert/custom%20widgets/search_bar.dart';
import 'package:driver_drowsiness_alert/utils/Location%20Services/Location_Service.dart';
import 'package:driver_drowsiness_alert/utils/Location%20Services/map_services.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

class LocationMap extends StatefulWidget {
  const LocationMap({Key? key}) : super(key: key);
  static const String routeName = 'LocationMap';

  @override
  State<LocationMap> createState() => _LocationMapState();
}

class _LocationMapState extends State<LocationMap> {
  late CameraPosition initalCameraPoistion;
  late MapServices mapServices;
  late TextEditingController textEditingController;
  late GoogleMapController googleMapController;
  String? sesstionToken;
  late Uuid uuid;
  Set<Marker> markers = {};

  List<PlaceModel> places = [];
  Set<Polyline> polyLines = {};
  late LatLng desintation;
  Timer? debounce;

  @override
  void initState() {
    mapServices = MapServices();
    uuid = const Uuid();
    textEditingController = TextEditingController();
    initalCameraPoistion = const CameraPosition(
        zoom: 6, target: LatLng(26.983740518505634, 29.096824430069884));
    fetchPredictions();
    super.initState();
  }

  void fetchPredictions() {
    textEditingController.addListener(() {
      if (debounce?.isActive ?? false) {
        debounce?.cancel();
      }
      debounce = Timer(const Duration(milliseconds: 100), () async {
        sesstionToken ??= uuid.v4();
        await mapServices.getPredictions(
            input: textEditingController.text,
            sesstionToken: sesstionToken!,
            places: places);
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          polylines: polyLines,
          markers: markers,
          onMapCreated: (controller) {
            googleMapController = controller;
            updateCurrentLocation();
          },
          zoomControlsEnabled: false,
          initialCameraPosition: initalCameraPoistion,
        ),
        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: Column(
            children: [
              CustomSearchBar(
                textEditingController: textEditingController,
              ),
              const SizedBox(
                height: 16,
              ),
              CustomListView(
                onPlaceSelect: (placeDetailsModel) async {
                  textEditingController.clear();
                  places.clear();

                  sesstionToken = null;
                  setState(() {});
                  desintation = LatLng(
                      placeDetailsModel.geometry!.location!.lat!,
                      placeDetailsModel.geometry!.location!.lng!);

                  mapServices.addDestinationMarker(
                    destination: desintation,
                    markers: markers,
                  );

                  var points = await mapServices.getRouteData(desintation: desintation);
                  mapServices.displayRoute(points,
                      polyLines: polyLines,
                      googleMapController: googleMapController);
                  setState(() {});
                },
                places: places,
                mapServices: mapServices,
              )
            ],
          ),
        ),
        Positioned(
          bottom: 16.0,
          right: 16.0,
          child: FloatingActionButton(
            onPressed: () {
              moveMapToCurrentLocation();
            },
            child: Icon(Icons.my_location),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    textEditingController.dispose();
    debounce?.cancel();
    googleMapController.dispose();
    super.dispose();
  }

  void updateCurrentLocation() {
    try {
      mapServices.updateCurrentLocation(
        onUpdatecurrentLocation: () {
          if (mounted) {
            setState(() {});
          }
        },
        googleMapController: googleMapController,
        markers: markers,
      );
    } on LocationServiceException catch (e) {
      print('LocationServiceException');
    } on LocationPermissionException catch (e) {
      print('LocationPermissionException');
    } catch (e) {
      print(e);
    }
  }

  void moveMapToCurrentLocation() {
    if (mapServices.currentLocation != null && googleMapController != null) {
      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: mapServices.currentLocation!,
            zoom: 17,
          ),
        ),
      );
    }
  }
}
