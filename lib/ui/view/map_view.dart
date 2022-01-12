import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps/domain/bloc/blocs.dart';

class MapView extends StatelessWidget {
  final LatLng initialLocation;
  final Set<Polyline> polylines;
  final Set<Marker> markers;

  const MapView({
    Key? key,
    required this.initialLocation,
    required this.polylines,
    required this.markers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mapBloc = context.read<MapBloc>();

    final CameraPosition initialCameraPosition = CameraPosition(
      bearing: 192.8334901395799,
      target: initialLocation,
      // tilt: 59.440717697143555,
      zoom: 15,
    );

    final size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width,
      height: size.height,
      child: Listener(
        onPointerMove: (PointerMoveEvent event) => mapBloc.add(OnStopFollow()),
        child: GoogleMap(
          onMapCreated: (controller) =>
              context.read<MapBloc>().add(OnMapInitializeEvent(controller)),
          initialCameraPosition: initialCameraPosition,
          compassEnabled: false,
          myLocationEnabled: true,
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,
          polylines: polylines,
          markers: markers,
          onCameraMove: (CameraPosition position) =>
              mapBloc.mapCenter = position.target,
        ),
      ),
    );
  }
}
