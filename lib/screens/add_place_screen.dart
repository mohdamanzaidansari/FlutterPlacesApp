import 'dart:io';

import 'package:flutter/material.dart';
import 'package:places/models/place.dart';
import 'package:places/providers/great_places.dart';
import 'package:places/providers/location_provider.dart';
import 'package:places/widgets/image_input.dart';
import 'package:places/widgets/location_input.dart';
import 'package:provider/provider.dart';

class AddPlaceScreen extends StatefulWidget {
  static const routeName = '/add-place';

  @override
  _AddPlaceScreenState createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _formKey = GlobalKey<FormState>();

  File _pickedImage;
  String _title;

  LocationCoordinates locData;

  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  void _savePlace(BuildContext context) {
    if (_pickedImage == null) {
      showDialog(
        context: context,
        child: AlertDialog(
          title: Text('Please select an image'),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    if (locData.latLng == null) {
      showDialog(
        context: context,
        child: AlertDialog(
          title: Text('Please pick a Location'),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    if (_formKey.currentState.validate()) {
      final placeLocation = PlaceLocation(
        latitude: locData.latLng.latitude,
        longitude: locData.latLng.longitude,
        address: locData.address,
      );

      Provider.of<GreatPlaces>(context, listen: false).addPlace(
        _title,
        _pickedImage,
        placeLocation,
      );

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    locData = Provider.of<LocationCoordinates>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Place'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: TextFormField(
                        decoration:
                            InputDecoration(labelText: 'New place name'),
                        validator: (value) {
                          if (value == null) {
                            return 'Please enter title.';
                          }
                          return null;
                        },
                        onChanged: (value) => _title = value,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ImageInput(_selectImage),
                    SizedBox(
                      height: 10,
                    ),
                    LocationInput(),
                  ],
                ),
              ),
            ),
          ),
          RaisedButton.icon(
            icon: Icon(Icons.add),
            label: Text('Add New Place'),
            color: Theme.of(context).accentColor,
            elevation: 0,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onPressed: () => _savePlace(context),
          )
        ],
      ),
    );
  }
}
