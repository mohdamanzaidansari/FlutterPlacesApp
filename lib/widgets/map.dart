import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:places/providers/location_provider.dart';
import 'package:provider/provider.dart';
import "package:latlong/latlong.dart";

class PlaceMap extends StatefulWidget {
  final bool isSelected;
  const PlaceMap({
    Key key,
    this.isSelected,
  }) : super(key: key);

  @override
  _PlaceMapState createState() => _PlaceMapState();
}

class _PlaceMapState extends State<PlaceMap> {
  LatLng markerPoint;

  @override
  Widget build(BuildContext context) {
    final locData = Provider.of<LocationCoordinates>(context, listen: false);
    markerPoint = locData.latLng;

    return FlutterMap(
      options: MapOptions(
        onTap: (point) {
          if (!widget.isSelected) {
            print(point.latitude);
            print(point.longitude);
            setState(() {
              markerPoint = point;
            });
            locData.setLatLng(point);
            locData.setAddress(point);
          }
        },
        center: markerPoint,
        zoom: 13.0,
      ),
      layers: [
        TileLayerOptions(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c']),
        MarkerLayerOptions(
          markers: [
            Marker(
              width: 80,
              height: 80.0,
              point: markerPoint,
              builder: (ctx) => Container(child: Icon(Icons.location_on)),
            ),
          ],
        ),
      ],
    );
  }
}
