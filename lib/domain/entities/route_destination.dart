import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:maps/domain/entities/places_response.dart';

class RouteDestination {
  final List<LatLng> points;
  final double duration;
  final double distance;
  final Feature endPlace;

  const RouteDestination({
    required this.endPlace,
    required this.points,
    required this.duration,
    required this.distance,
  });
}
