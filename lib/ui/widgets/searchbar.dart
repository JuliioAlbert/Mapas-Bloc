import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps/domain/bloc/blocs.dart';
import 'package:maps/domain/entities/entities.dart';
import 'package:maps/ui/delegates/search_destination_delegate.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return !state.displayManualMarker
            ? const _SearchBarBody()
            : const SizedBox();
      },
    );
  }
}

class _SearchBarBody extends StatelessWidget {
  const _SearchBarBody({Key? key}) : super(key: key);

  void onSearchResult(BuildContext context, SearchResult result) async {
    final searchBloc = context.read<SearchBloc>();
    final locationBloc = context.read<LocationBloc>();
    final mapBloc = context.read<MapBloc>();

    if (result.manual) {
      searchBloc.add(OnActivateManualMarker());
      return;
    }
    if (result.position != null) {
      ///Revisar tienemos posistion
      final destination = await searchBloc.getCoorsStartToEnd(
          locationBloc.state.lastKnowLocation!, result.position!);
      if (destination == null) return;
      await mapBloc.drawRoutePolyline(destination);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.symmetric(horizontal: 30),
        width: double.infinity,
        child: GestureDetector(
          onTap: () async {
            final result = await showSearch<SearchResult>(
                context: context, delegate: SearchDestinationDelegate());
            if (result == null) return;
            onSearchResult(context, result);
          },
          child: FadeInDown(
            duration: const Duration(milliseconds: 400),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
              child: const Text(
                "Donde Quieres ir",
                style: TextStyle(color: Colors.black87),
              ),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      offset: Offset(0, 5),
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
