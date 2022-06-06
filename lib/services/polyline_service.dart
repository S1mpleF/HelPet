import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:helpet/utilities/constants.dart';

class PolylineService {
  static Future<Polyline> drawPolyline(LatLng from, LatLng to) async {
    List<LatLng> polylineCoordinates = [];

    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        Constants.apiKey,
        PointLatLng(from.latitude, from.longitude),
        PointLatLng(to.latitude, to.longitude));

    result.points.forEach((PointLatLng point) {
      polylineCoordinates.add(LatLng(point.latitude, point.longitude));
    });
    return Polyline(
        polylineId: PolylineId("polyline_id ${result.points.length}"),
        color: Colors.blue,
        points: polylineCoordinates);
  }
}
