import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps/domain/bloc/blocs.dart';
import 'package:maps/domain/entities/entities.dart';
import 'package:maps/domain/helpers/helpers.dart';
import 'package:maps/ui/theme/themes.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final LocationBloc locationBloc;

  StreamSubscription<LocationState>? locationStrem;

  GoogleMapController? _mapController;

  LatLng? mapCenter;

  MapBloc({required this.locationBloc}) : super(const MapState()) {
    on<OnMapInitializeEvent>(_onInitMap);
    on<OnFollowUser>(_onStartFollowUser);
    on<OnStopFollow>(
        (event, emit) => emit(state.copyWith(isFollowingUser: false)));

    on<UpdateUserPolylines>(_onUpdatePolylineHistory);

    on<OnToggleRouteUser>(
        (event, emit) => emit(state.copyWith(showMyRoute: !state.showMyRoute)));

    on<DiplayPolylineEvent>((event, emit) => emit(
        state.copyWith(polylines: event.polylines, markers: event.markers)));

    locationStrem = locationBloc.stream.listen((locationState) {
      if (locationState.lastKnowLocation != null) {
        add(UpdateUserPolylines(locationState.myLocationHistory));
      }

      if (!state.isFollowingUser) return;
      if (locationState.lastKnowLocation == null) return;
      moveCamera(locationState.lastKnowLocation!);
    });
  }

  void _onInitMap(OnMapInitializeEvent event, Emitter<MapState> emit) {
    _mapController = event.mapController;
    _mapController!.setMapStyle(jsonEncode(uber_map_theme));
    emit(state.copyWith(isMapInitialized: true));
  }

  void moveCamera(LatLng newLocation) {
    final cameraUpdate = CameraUpdate.newLatLng(newLocation);
    _mapController?.animateCamera(cameraUpdate);
  }

  void _onStartFollowUser(OnFollowUser event, Emitter<MapState> emit) {
    emit(state.copyWith(isFollowingUser: !state.isFollowingUser));
    if (locationBloc.state.lastKnowLocation == null) return;

    moveCamera(locationBloc.state.lastKnowLocation!);
  }

  void _onUpdatePolylineHistory(
      UpdateUserPolylines event, Emitter<MapState> emit) {
    final myRoute = Polyline(
      polylineId: const PolylineId("miRuta"),
      color: Colors.black,
      width: 3,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      points: event.userHistory,
    );

    final currentPolylines = Map<String, Polyline>.from(state.polylines);
    currentPolylines["miRuta"] = myRoute;

    emit(state.copyWith(polylines: currentPolylines));
  }

  Future drawRoutePolyline(RouteDestination destination) async {
    final myRoute = Polyline(
      polylineId: const PolylineId('route'),
      color: Colors.black,
      points: destination.points,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      width: 5,
    );

    double kms = destination.distance / 1000;
    kms = (kms * 100).floorToDouble();
    kms /= 100;

    double tripDuration = (destination.duration / 60).floorToDouble();

    ///Custom Markers
    ///
    final startMarkerImage = await getAssetImageMarker();
    final endMarkerImage = await getNetworkImage();

    ///WidgetsMarker
    final startWidgetMarkerImage = await getStartCustomMarker(
        tripDuration.toInt(), destination.endPlace.text);

    final endWidgetMarkerImage =
        await getEndCustomMarker(kms.toInt(), destination.endPlace.placeName);

    final startMarker = Marker(
      markerId: const MarkerId("start"),
      position: destination.points.first,
      icon: startWidgetMarkerImage,
      anchor: const Offset(0.1, .9),
      // infoWindow: InfoWindow(
      //   title: "Inicio",
      //   snippet: "Kms $kms, Duration: $tripDuration",
      // ),
    );

    final endMarker = Marker(
      markerId: const MarkerId("end"),
      position: destination.points.last,
      icon: endWidgetMarkerImage,
      // anchor: const Offset(10, 10),
      // infoWindow: InfoWindow(
      //   title: destination.endPlace.text,
      //   snippet: destination.endPlace.placeName,
      // ),
    );

    ///Copiar el Estado
    final currentPolylines = Map<String, Polyline>.from(state.polylines);
    currentPolylines['route'] = myRoute;

    final currentMarker = Map<String, Marker>.from(state.markers);
    currentMarker["start"] = startMarker;
    currentMarker["end"] = endMarker;

    add(DiplayPolylineEvent(currentPolylines, currentMarker));

    await Future.delayed(const Duration(milliseconds: 300));

    _mapController?.showMarkerInfoWindow(const MarkerId("start"));
  }

  @override
  Future<void> close() {
    locationStrem?.cancel();
    return super.close();
  }
}
