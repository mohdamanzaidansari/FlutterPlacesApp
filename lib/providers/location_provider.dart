import 'package:flutter/widgets.dart';
import 'package:geocoding/geocoding.dart';
import "package:latlong/latlong.dart";

class LocationCoordinates extends ChangeNotifier {
  LatLng _latLng;
  String _address;

  LatLng get latLng {
    final latLng = _latLng;
    return latLng;
  }

  void setLatLng(LatLng latLng) {
    _latLng = latLng;
    notifyListeners();
  }

  String get address {
    final address = _address;
    return address;
  }

  Future<void> setAddress(LatLng latLng) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latLng.latitude, latLng.longitude);

      _address =
          '${placemarks[0].street}, ${placemarks[0].locality}, ${placemarks[0].subAdministrativeArea}, ${placemarks[0].country}';
      notifyListeners();
    } catch (error) {
      print(error.toString());

      _address = 'Some hard coded address';
    }
  }
}
