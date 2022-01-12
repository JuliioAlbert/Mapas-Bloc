import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps/domain/bloc/blocs.dart';
import 'package:maps/ui/widgets/widgets.dart';

class BtnCurrentLocation extends StatelessWidget {
  const BtnCurrentLocation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locationBloc = context.read<LocationBloc>();
    final mapaBloc = context.read<MapBloc>();

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        maxRadius: 25,
        child: IconButton(
          onPressed: () {
            final userLocation = locationBloc.state.lastKnowLocation;
            if (userLocation == null) {
              final snak = CustomSnakBar(texto: "No hay ubicacion");
              ScaffoldMessenger.of(context).showSnackBar(snak);
              return;
            }
            mapaBloc.moveCamera(userLocation);
          },
          icon: const Icon(
            Icons.my_location_outlined,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
