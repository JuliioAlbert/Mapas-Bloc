import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps/data/services/services.dart';
import 'package:maps/domain/entities/entities.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  TrafficService trafficService;

  SearchBloc({
    required this.trafficService,
  }) : super(const SearchState()) {
    ///
    on<OnActivateManualMarker>(
        (event, emit) => emit(state.copyWith(displayManualMarker: true)));

    on<OnDeActivateManualMarker>(
        (event, emit) => emit(state.copyWith(displayManualMarker: false)));

    on<OnNewPlacesFoundEvent>(
        (event, emit) => emit(state.copyWith(places: event.places)));

    ///Todo ultimo elemento al inicio

    on<AddToHistoryEvent>((event, emit) =>
        emit(state.copyWith(history: [event.place, ...state.history])));
  }

  Future getPlacesByQuery(LatLng proximity, String query) async {
    final newPlaces = await trafficService.getResultByQuery(proximity, query);
    add(OnNewPlacesFoundEvent(newPlaces));
  }

  Future<RouteDestination?> getCoorsStartToEnd(LatLng start, LatLng end) async {
    final trafficResponse =
        await trafficService.getCoordsStartToEnd(start, end);

    ///Info Destino
    //
    final endPlace = await trafficService.getInformationByCoord(end);

    if (trafficResponse == null) return null;

    final distance = trafficResponse.routes[0].distance;
    final duration = trafficResponse.routes[0].duration;
    final geometry = trafficResponse.routes[0].geometry;

    ///Decodificar
    final points = decodePolyline(geometry, accuracyExponent: 6)
        .map((e) => LatLng(e[0].toDouble(), e[1].toDouble()))
        .toList();

    return RouteDestination(
      points: points,
      duration: duration,
      distance: distance,
      endPlace: endPlace,
    );
  }
}
