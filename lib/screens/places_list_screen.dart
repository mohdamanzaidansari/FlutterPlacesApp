import 'package:flutter/material.dart';
import 'package:places/providers/great_places.dart';
import 'package:places/screens/add_place_screen.dart';
import 'package:places/screens/place_detail_screen.dart';
import 'package:provider/provider.dart';

class PlacesListScreen extends StatelessWidget {
  static const routeName = '/places-list';

  const PlacesListScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Places'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
            },
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder(
          future: Provider.of<GreatPlaces>(context, listen: false)
              .fetchAndSetPlaces(),
          builder: (context, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? Center(child: CircularProgressIndicator())
              : Consumer<GreatPlaces>(
                  child: Text('Got no places yet, start adding some!'),
                  builder: (context, greatPlaces, child) =>
                      greatPlaces.places.length <= 0
                          ? child
                          : ListView.builder(
                              itemCount: greatPlaces.places.length,
                              itemBuilder: (context, index) => ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: FileImage(
                                    greatPlaces.places[index].image,
                                  ),
                                ),
                                title: Text(greatPlaces.places[index].title),
                                subtitle: Text(
                                  greatPlaces.places[index].location.address,
                                ),
                                onTap: () {
                                  // Go to details page....
                                  Navigator.of(context).pushNamed(
                                      PlaceDetailScreen.routename,
                                      arguments: greatPlaces.places[index].id);
                                },
                              ),
                            ),
                ),
        ),
      ),
    );
  }
}
