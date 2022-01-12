part of 'map_bloc.dart';

class MapState extends Equatable {
  final bool isMapInitialized;
  final bool isFollowingUser;
  final bool showMyRoute;

  //Polylines
  final Map<String, Polyline> polylines;

  //Markers
  final Map<String, Marker> markers;

  const MapState({
    this.showMyRoute = false,
    this.isMapInitialized = false,
    this.isFollowingUser = true,
    Map<String, Polyline>? polylines,
    Map<String, Marker>? markers,
  })  : polylines = polylines ?? const {},
        markers = markers ?? const {};

  MapState copyWith({
    bool? isMapInitialized,
    bool? isFollowingUser,
    bool? showMyRoute,
    Map<String, Polyline>? polylines,
    Map<String, Marker>? markers,
  }) =>
      MapState(
        isMapInitialized: isMapInitialized ?? this.isMapInitialized,
        isFollowingUser: isFollowingUser ?? this.isFollowingUser,
        polylines: polylines ?? this.polylines,
        showMyRoute: showMyRoute ?? this.showMyRoute,
        markers: markers ?? this.markers,
      );

  @override
  List<Object> get props => [
        isMapInitialized,
        isFollowingUser,
        polylines,
        showMyRoute,
        markers,
      ];
}
