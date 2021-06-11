import 'package:flutter/material.dart';
import 'package:places/providers/great_places.dart';
import 'package:places/providers/location_provider.dart';
import 'package:places/widgets/bottom_sheet_map.dart';
import 'package:provider/provider.dart';
import "package:latlong/latlong.dart";

class PlaceDetailScreen extends StatelessWidget {
  static const routename = '/place-details';

  PlaceDetailScreen({Key key}) : super(key: key);
  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  final bool isSelected = true;

  void _selectionModeCallback({bool isSelected}) {
    // this.isSelected = isSelected;
  }

  _openMapBottomSheet(context, LatLng latLng) {
    Provider.of<LocationCoordinates>(context, listen: false).setLatLng(latLng);

    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      builder: (BuildContext context) => BottomSheetMap(
        isLoading: isLoading,
        isSelected: isSelected,
        selectionModeCallback: _selectionModeCallback,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments;
    final selectedPlace =
        Provider.of<GreatPlaces>(context, listen: false).findById(id);

    return Scaffold(
      appBar: AppBar(
        title: Text(selectedPlace.title),
      ),
      body: Column(
        children: [
          Container(
            height: 250,
            width: double.infinity,
            child: Image.file(
              selectedPlace.image,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          SizedBox(height: 10),
          Text(
            selectedPlace.location.address,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 10),
          FlatButton(
            child: Text('View on Map'),
            textColor: Theme.of(context).primaryColor,
            onPressed: () => _openMapBottomSheet(
              context,
              LatLng(
                selectedPlace.location.latitude,
                selectedPlace.location.longitude,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
