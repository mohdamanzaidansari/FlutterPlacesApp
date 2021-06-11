import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:places/providers/location_provider.dart';
import 'package:places/widgets/bottom_sheet_map.dart';
import 'package:places/widgets/map.dart';
import "package:latlong/latlong.dart" as latLng;
import 'package:provider/provider.dart';

class LocationInput extends StatefulWidget {
  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  bool isSelected = false;
  LocationCoordinates locData;

  void _selectionModeCallback({bool isSelected}) {
    this.isSelected = isSelected;
  }

  Future<void> _getCurrentUserLocation() async {
    isLoading.value = true;
    final loc = await Location().getLocation();

    locData.setLatLng(latLng.LatLng(loc.latitude, loc.longitude));

    isLoading.value = false;
    print(locData.latLng);
  }

  _openMapBottomSheet() {
    if (locData.latLng == null) {
      _getCurrentUserLocation();
    }

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
    locData = Provider.of<LocationCoordinates>(context, listen: true);

    return Column(
      children: <Widget>[
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: ValueListenableBuilder(
            valueListenable: isLoading,
            builder: (BuildContext context, bool isLoading, _) => isLoading
                ? CircularProgressIndicator()
                : locData.latLng == null
                    ? Text(
                        'No Location Chosen',
                        textAlign: TextAlign.center,
                      )
                    : PlaceMap(
                        isSelected: isSelected,
                      ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlatButton.icon(
              icon: Icon(Icons.location_on),
              label: Text('Current Location'),
              textColor: Theme.of(context).primaryColor,
              onPressed: _getCurrentUserLocation,
            ),
            FlatButton.icon(
              icon: Icon(Icons.map),
              label: Text('Select on map'),
              textColor: Theme.of(context).primaryColor,
              onPressed: _openMapBottomSheet,
            ),
          ],
        )
      ],
    );
  }
}
