part of 'map_bloc.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object> get props => [];
}

class OnMapInitializeEvent extends MapEvent {
  final GoogleMapController mapController;

  const OnMapInitializeEvent(this.mapController);
}

class OnFollowUser extends MapEvent {}

class OnStopFollow extends MapEvent {}

class UpdateUserPolylines extends MapEvent {
  final List<LatLng> userHistory;

  const UpdateUserPolylines(this.userHistory);
}

class OnToggleRouteUser extends MapEvent {}

class DiplayPolylineEvent extends MapEvent {
  final Map<String, Polyline> polylines;
  final Map<String, Marker> markers;

  const DiplayPolylineEvent(this.polylines, this.markers);
}
