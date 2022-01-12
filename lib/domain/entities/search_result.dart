import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

class SearchResult {
  final bool cancel;
  final bool manual;
  final LatLng? position;
  final String? name;
  final String? descripcion;

  SearchResult({
    required this.cancel,
    this.name,
    this.descripcion,
    this.position,
    this.manual = false,
  });

  @override
  String toString() {
    return '{cancel: $cancel, manual:$manual }';
  }
}
