import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps/domain/bloc/blocs.dart';

class BtnToggleUserRoute extends StatelessWidget {
  const BtnToggleUserRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mapaBloc = context.read<MapBloc>();

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        maxRadius: 25,
        child: IconButton(
          onPressed: () => mapaBloc.add(OnToggleRouteUser()),
          icon: const Icon(
            Icons.more_horiz_outlined,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
