import 'package:bloc/bloc.dart';
import 'global_event.dart';
import 'global_state.dart';
import 'package:flutter_app_sports/data/models/match.dart' as externals;

class GlobalBloc extends Bloc<GlobalEvent, GlobalState> {
  GlobalBloc() : super(NavigationStateButtons(0)) {
    on<NavigateToIndexEvent>(_navigateToIndexEvent);
    on<NavigateToSportEvent>(_navigateToSportEvent);
    on<NavigateToPrefferedMatchEvent>(_navigateToPrefferedMatchEvent);
    on<NavigateToMatchEvent>(_navigateToMatchEvent);
  }

  Future<void> _navigateToIndexEvent(
      NavigateToIndexEvent event, Emitter<GlobalState> emit) async {
    // Actualiza el estado con el nuevo índice
    emit(NavigationStateButtons(event.index));
  }

  Future<void> _navigateToSportEvent(
      NavigateToSportEvent event, Emitter<GlobalState> emit) async {
    // Actualiza el estado con el nuevo índice
    emit(NavigationSportState(event.sport));
  }

  Future<void> _navigateToPrefferedMatchEvent(
      NavigateToPrefferedMatchEvent event, Emitter<GlobalState> emit) async {
    // Actualiza el estado con el nuevo índice
    emit(NavigationPrefferedMatchState(event.sport, event.selectedDate));
  }

  Future<void> _navigateToMatchEvent(
      NavigateToMatchEvent event, Emitter<GlobalState> emit) async {
    // Actualiza el estado con el nuevo índice
    externals.Match match = event.match;
    emit(NavigationMatchState(match, event.status));
  }
  

  @override
  Stream<GlobalState> mapEventToState(GlobalEvent event) async* {
    // Implementa cualquier otro manejo de eventos si es necesario
  }
}
