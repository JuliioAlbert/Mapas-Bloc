import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:maps/data/services/services.dart';
import 'package:maps/domain/entities/entities.dart';

class TrafficService {
  final Dio _dioTraffic;
  final Dio _dioPlaces;

  final String _baseTrafficUrl = 'https://api.mapbox.com/directions/v5/mapbox';
  final String _basePlacesUrl =
      'https://api.mapbox.com/geocoding/v5/mapbox.places';

  TrafficService()
      : _dioTraffic = Dio()..interceptors.add(TrafficInterceptor()),
        _dioPlaces = Dio()..interceptors.add(PlacesInterceptor());

  ///TODO: Configurar Interceptors

  Future<TrafficResponse?> getCoordsStartToEnd(LatLng start, LatLng end,
      {String tipo = "driving"}) async {
    final coorsString =
        '${start.longitude},${start.latitude};${end.longitude},${end.latitude}';

    final url = '$_baseTrafficUrl/$tipo/$coorsString';

    try {
      final response = await _dioTraffic.get(url);

      final data = TrafficResponse.fromJson(jsonEncode(response.data));

      return data;
    } catch (e) {
      return null;
    }
  }

  Future<List<Feature>> getResultByQuery(LatLng proximity, String query) async {
    if (query.isEmpty) return [];

    final url = '$_basePlacesUrl/$query.json';
    //Convertir datos FromJson
    try {
      final resp = await _dioPlaces.get(url, queryParameters: {
        "limit": 7,
        "proximity": '${proximity.longitude},${proximity.latitude}'
      });

      final placesResponse = PlacesResponse.fromJson(resp.data);

      return placesResponse.features;
    } catch (e) {
      return []; //Features
    }
  }

  Future<Feature> getInformationByCoord(LatLng coors) async {
    final url = '$_basePlacesUrl/${coors.longitude},${coors.latitude}.json';
    final resp = await _dioPlaces.get(url, queryParameters: {
      'limit': 1,
    });

    final placesResponse = PlacesResponse.fromJson(resp.data);

    return placesResponse.features.first;
  }
}
