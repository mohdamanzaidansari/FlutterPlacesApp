import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:places/controllers/db_controller.dart';
import 'package:places/models/place.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _places = [];

  List<Place> get places {
    return [..._places];
  }

  void addPlace(String title, File image, PlaceLocation location) {
    final newPlace = Place(
      id: DateTime.now().toString(),
      title: title,
      image: image,
      location: location,
    );
    print(newPlace.title);
    print(newPlace.location.address);
    _places.add(newPlace);
    DBController.insert("places", {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'loc_lat': newPlace.location.latitude,
      'loc_lon': newPlace.location.longitude,
      'address': newPlace.location.address,
    });
    notifyListeners();
  }

  Place findById(String id) {
    print('finding...');
    print(id);
    final foundPlace = _places.firstWhere((place) => place.id == id);
    print('Found place: ${foundPlace.title}');
    return foundPlace;
  }

  Future<void> fetchAndSetPlaces() async {
    final dataList = await DBController.getData('places');
    _places = dataList
        .map(
          (place) => Place(
            id: place['id'],
            title: place['title'],
            image: File(place['image']),
            location: PlaceLocation(
              latitude: place['loc_lat'],
              longitude: place['loc_lon'],
              address: place['address'],
            ),
          ),
        )
        .toList();

    notifyListeners();
  }
}
