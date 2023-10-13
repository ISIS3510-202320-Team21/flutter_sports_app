import 'package:bloc/bloc.dart';
import 'global_event.dart';
import 'global_state.dart';

class GlobalBloc extends Bloc<GlobalEvent, GlobalState> {
  GlobalBloc() : super(NavigationStateButtons(0)) {
    on<NavigateToIndexEvent>(_navigateToIndexEvent);
    on<NavigateToSportEvent>(_navigateToSportEvent);
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

  @override
  Stream<GlobalState> mapEventToState(GlobalEvent event) async* {
    // Implementa cualquier otro manejo de eventos si es necesario
  }
}
