import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps/domain/bloc/blocs.dart';
import 'package:maps/domain/helpers/helpers.dart';

class ManualMarker extends StatelessWidget {
  const ManualMarker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return state.displayManualMarker
            ? const _ManualMarkerBody()
            : const SizedBox();
      },
    );
  }
}

class _ManualMarkerBody extends StatelessWidget {
  const _ManualMarkerBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final searchBloc = context.read<SearchBloc>();
    final locationBloc = context.read<LocationBloc>();
    final mapBloc = context.read<MapBloc>();

    return SizedBox(
      width: size.width,
      height: size.height,
      child: Stack(
        children: [
          const Positioned(top: 30, left: 20, child: _BtnBack()),
          Center(
              child: Transform.translate(
                  offset: const Offset(0, -23),
                  child: BounceInDown(
                    child: const Icon(
                      Icons.location_on_rounded,
                      size: 60,
                    ),
                    from: 100,
                  ))),

          //Bototn de confirmar
          Positioned(
            bottom: 70,
            left: 40,
            child: FadeInUp(
              duration: const Duration(milliseconds: 300),
              child: MaterialButton(
                minWidth: size.width - 120,
                onPressed: () async {
                  final start = locationBloc.state.lastKnowLocation;
                  if (start == null) return;

                  final end = mapBloc.mapCenter;
                  if (end == null) return;

                  showLoadingMessage(context);

                  final destination =
                      await searchBloc.getCoorsStartToEnd(start, end);
                  if (destination == null) return;
                  await mapBloc.drawRoutePolyline(destination);

                  searchBloc.add(OnDeActivateManualMarker());

                  Navigator.pop(context);
                },
                color: Colors.black,
                elevation: 10,
                height: 50,
                shape: const StadiumBorder(),
                child: const Text(
                  "Confirmar destino",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w300),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _BtnBack extends StatelessWidget {
  const _BtnBack({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeInLeft(
      duration: const Duration(milliseconds: 300),
      child: CircleAvatar(
        maxRadius: 25,
        backgroundColor: Colors.white,
        child: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
          onPressed: () {
            print("Deactive");
            context.read<SearchBloc>().add(OnDeActivateManualMarker());
          },
        ),
      ),
    );
  }
}
