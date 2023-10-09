import 'package:bloc/bloc.dart';
import 'global_event.dart';
import 'global_state.dart';

class GlobalBloc extends Bloc<GlobalEvent, GlobalState> {
  GlobalBloc() : super(NavigationState(0)) {
    on<NavigateToIndexEvent>(_navigateToIndexEvent);
  }

  Future<void> _navigateToIndexEvent(
      NavigateToIndexEvent event, Emitter<GlobalState> emit) async {
    // Actualiza el estado con el nuevo índice
    emit(NavigationState(event.index));
  }

  @override
  Stream<GlobalState> mapEventToState(GlobalEvent event) async* {
    // Implementa cualquier otro manejo de eventos si es necesario
  }
}
