import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportsapp/features/match/bloc/match_event.dart';
import 'package:sportsapp/features/match/bloc/match_state.dart';
import 'package:sportsapp/models/match.dart';

class MatchBloc extends Bloc<MatchEvent, MatchState> {
  final MatchRepository matchRepository;

  MatchBloc({required this.matchRepository}) : super(MatchInitialState());

  @override
  Stream<MatchState> mapEventToState(MatchEvent event) async* {
    if (event is MatchInitialEvent) {
      yield MatchLoadingState(); // Emite un estado de carga al principio

      try {
        final List<Match> matches = await matchRepository
            .getMatches(); // Obtiene los matches desde el repositorio
        yield MatchLoadedState(
            matches); // Emite un estado cargado con los matches
      } catch (error) {
        yield MatchErrorState(
            'Error loading matches: $error'); // Emite un estado de error si algo falla
      }
    }

    // Añade más lógica para manejar diferentes eventos aquí
  }
}
