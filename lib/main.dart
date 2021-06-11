import 'package:flutter/material.dart';
import 'package:places/providers/great_places.dart';
import 'package:places/providers/location_provider.dart';
import 'package:places/screens/add_place_screen.dart';
import 'package:places/screens/place_detail_screen.dart';
import 'package:places/screens/places_list_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => GreatPlaces(),
        ),
        ChangeNotifierProvider(
          create: (_) => LocationCoordinates(),
        ),
      ],
      child: MaterialApp(
        title: 'Greate Places',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          accentColor: Colors.amber,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: PlacesListScreen(),
        routes: {
          AddPlaceScreen.routeName: (context) => AddPlaceScreen(),
          PlacesListScreen.routeName: (context) => PlacesListScreen(),
          PlaceDetailScreen.routename: (context) => PlaceDetailScreen(),
        },
      ),
    );
  }
}
