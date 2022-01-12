import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps/domain/bloc/blocs.dart';

import 'package:maps/domain/entities/entities.dart';

class SearchDestinationDelegate extends SearchDelegate<SearchResult> {
  SearchDestinationDelegate()
      : super(
          searchFieldLabel: 'Buscar...',
        );

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, SearchResult(cancel: true));
      },
      icon: const Icon(Icons.arrow_back_ios),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    final locationBloc = BlocProvider.of<LocationBloc>(context);
    final proximity = locationBloc.state.lastKnowLocation!;

    searchBloc.getPlacesByQuery(proximity, query);

    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        final places = state.places;
        return ListView.separated(
          itemCount: places.length,
          separatorBuilder: (context, int i) => const Divider(),
          itemBuilder: (BuildContext context, int index) {
            final place = places[index];
            return ListTile(
              title: Text(place.text),
              subtitle: Text(place.placeName),
              leading: const Icon(
                Icons.place_outlined,
                color: Colors.black,
              ),
              onTap: () {
                ///Mandar el lugar
                searchBloc.add(AddToHistoryEvent(place));

                close(
                  context,
                  SearchResult(
                    cancel: false,
                    manual: false,
                    position: LatLng(place.center[1], place.center[0]),
                    descripcion: place.placeName,
                    name: place.text,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final history = context.read<SearchBloc>().state.history;
    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.location_on_outlined, color: Colors.black),
          title: const Text(
            "Colocar ubicacion Manual",
            style: TextStyle(color: Colors.black),
          ),
          onTap: () =>
              close(context, SearchResult(cancel: false, manual: true)),
        ),
        ...history.map((place) => ListTile(
              title: Text(place.placeName),
              subtitle: Text(place.placeName),
              leading: const Icon(
                Icons.history,
                color: Colors.black,
              ),
              onTap: () {
                close(
                  context,
                  SearchResult(
                    cancel: false,
                    manual: false,
                    position: LatLng(place.center[1], place.center[0]),
                    descripcion: place.placeName,
                    name: place.text,
                  ),
                );
              },
            ))
        //Lista de elementos
      ],
    );
  }
}
