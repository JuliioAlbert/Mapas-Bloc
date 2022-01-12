import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps/domain/bloc/blocs.dart';

class GpsAccessScreen extends StatelessWidget {
  const GpsAccessScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocBuilder<GpsBloc, GpsState>(
          builder: (context, state) {
            return !state.isGPSEnable
                ? const _EnableGpsMessage()
                : const _AccessButton();
          },
        ),
        // _AccessButton(),
      ),
    );
  }
}

class _AccessButton extends StatelessWidget {
  const _AccessButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Es necesario el permiso a GPS'),
        MaterialButton(
          color: Colors.black,
          shape: const StadiumBorder(),
          elevation: 0,
          child: const Text(
            "Solicitar Acceso",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () async {
            await context.read<GpsBloc>().askGpsAccess();
          },
        )
      ],
    );
  }
}

class _EnableGpsMessage extends StatelessWidget {
  const _EnableGpsMessage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Debe habilitar el GPS',
      style: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.w300,
      ),
    );
  }
}
