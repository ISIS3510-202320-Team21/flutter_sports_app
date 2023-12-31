import 'package:bloc/bloc.dart';
import 'global_event.dart';
import 'global_state.dart';
import 'package:flutter_app_sports/data/models/match.dart' as externals;
import 'package:flutter_app_sports/data/models/notification.dart' as _notification;

class GlobalBloc extends Bloc<GlobalEvent, GlobalState> {
  GlobalBloc() : super(NavigationStateButtons(0)) {
    on<NavigateToIndexEvent>(_navigateToIndexEvent);
    on<NavigateToSportEvent>(_navigateToSportEvent);
    on<NavigateToPrefferedMatchEvent>(_navigateToPrefferedMatchEvent);
    on<NavigateToMatchEvent>(_navigateToMatchEvent);
    on<NavigateToNotificationEvent>(_navigateToNotificationEvent);
  }

  Future<void> _navigateToIndexEvent(
      NavigateToIndexEvent event, Emitter<GlobalState> emit) async {
    emit(NavigationStateButtons(event.index));
  }

  Future<void> _navigateToSportEvent(
      NavigateToSportEvent event, Emitter<GlobalState> emit) async {
    emit(NavigationSportState(event.sport));
  }

  Future<void> _navigateToPrefferedMatchEvent(
      NavigateToPrefferedMatchEvent event, Emitter<GlobalState> emit) async {
    emit(NavigationPrefferedMatchState(event.sport, event.selectedDate));
  }

  Future<void> _navigateToMatchEvent(
      NavigateToMatchEvent event, Emitter<GlobalState> emit) async {
    externals.Match match = event.match;
    emit(NavigationMatchState(match, event.status));
  }

  Future<void> _navigateToNotificationEvent(
      NavigateToNotificationEvent event, Emitter<GlobalState> emit) async {
    _notification.Notification notification = event.notification;
    emit(NavigationNotificationState(notification));
  }
  

  @override
  Stream<GlobalState> mapEventToState(GlobalEvent event) async* {
    // Implementa cualquier otro manejo de eventos si es necesario
  }
}
