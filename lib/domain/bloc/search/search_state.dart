part of 'search_bloc.dart';

class SearchState extends Equatable {
  final bool displayManualMarker;
  final List<Feature> places;
  final List<Feature> history;

  const SearchState({
    this.history = const [],
    this.places = const [],
    this.displayManualMarker = false,
  });

  SearchState copyWith({
    bool? displayManualMarker,
    List<Feature>? places,
    List<Feature>? history,
  }) =>
      SearchState(
        displayManualMarker: displayManualMarker ?? this.displayManualMarker,
        places: places ?? this.places,
        history: history ?? this.history,
      );

  @override
  List<Object> get props => [displayManualMarker, places, history];
}
