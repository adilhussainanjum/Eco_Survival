import 'package:bmind/src/constants/app_contants.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:place_picker/entities/location_result.dart';
import 'package:place_picker/widgets/place_picker.dart';

class MapServices {
  static Future<LocationResult> pickLocation(
    BuildContext context,
    LatLng initLocation,
  ) async {
    print("Here we got :: Inside location::: ");
    Position pos = await Geolocator.getCurrentPosition();
    initLocation = LatLng(pos.latitude, pos.longitude);
    if (await Permission.location.request().isGranted) {
      // final Geolocator geolocator = Geolocator()..forceAndroidLocationManager ;
      // LocationResult result = await showLocationPicker(context, MAP_API);
      LocationResult result =
          await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => PlacePicker(
                    MAP_API,
                    displayLocation: initLocation,
                  )));
      print("Here we got location::: $result");
      return result;
    }
    print("Here we got location :::::  N..");
    return LocationResult();
  }
}
