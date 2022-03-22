import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps/data/services/services.dart';
import 'package:maps/domain/bloc/blocs.dart';
import 'package:maps/ui/Screen/screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<GpsBloc>(create: (context) => GpsBloc()),
      BlocProvider<LocationBloc>(create: (context) => LocationBloc()),
      BlocProvider<MapBloc>(
          create: (context) =>
              MapBloc(locationBloc: context.read<LocationBloc>())),
      BlocProvider<SearchBloc>(
          create: (context) => SearchBloc(
                trafficService: TrafficService(),
              ))
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: LoadingScreen(),
    );
  }
}
