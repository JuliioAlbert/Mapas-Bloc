part of 'location_bloc.dart';

class LocationState extends Equatable {
  final bool follwingUser;
  final LatLng? lastKnowLocation;
  final List<LatLng> myLocationHistory;
  //TODO:
  //Ultimo Geolocation:

  //historia

  const LocationState({
    this.follwingUser = false,
    this.lastKnowLocation,
    myLocationHistory,
  }) : myLocationHistory = myLocationHistory ?? const [];

  LocationState copyWith({
    bool? follwingUser,
    LatLng? lastKnowLocation,
    List<LatLng>? myLocationHistory,
  }) =>
      LocationState(
        follwingUser: follwingUser ?? this.follwingUser,
        lastKnowLocation: lastKnowLocation ?? this.lastKnowLocation,
        myLocationHistory: myLocationHistory ?? this.myLocationHistory,
      );

  @override
  List<Object?> get props =>
      [follwingUser, lastKnowLocation, myLocationHistory];
}
