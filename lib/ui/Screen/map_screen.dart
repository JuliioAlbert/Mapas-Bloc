import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:maps/domain/bloc/blocs.dart';
import 'package:maps/ui/view/views.dart';
import 'package:maps/ui/widgets/widgets.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LocationBloc locationBloc;

  @override
  void initState() {
    super.initState();
    locationBloc = context.read<LocationBloc>();
    // context.read<LocationBloc>().getCurrentPosition();
    locationBloc.starFollowingUser();
  }

  @override
  void dispose() {
    locationBloc.stopFollowingUser();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LocationBloc, LocationState>(
        builder: (context, locationState) {
          if (locationState.lastKnowLocation == null) {
            return const Center(
              child: Text("Espere por favor"),
            );
          }
          return BlocBuilder<MapBloc, MapState>(
            builder: (context, state) {
              Map<String, Polyline> polylines =
                  Map<String, Polyline>.from(state.polylines);

              if (!state.showMyRoute) {
                polylines.removeWhere((key, value) => key == "miRuta");
              }

              return SingleChildScrollView(
                child: Stack(
                  children: [
                    MapView(
                      initialLocation: locationState.lastKnowLocation!,
                      polylines: polylines.values.toSet(),
                      markers: state.markers.values.toSet(),
                    ),
                    const SearchBar(),
                    const ManualMarker(),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          BtnFollowUser(),
          BtnCurrentLocation(),
          BtnToggleUserRoute(),
        ],
      ),
    );
  }
}
