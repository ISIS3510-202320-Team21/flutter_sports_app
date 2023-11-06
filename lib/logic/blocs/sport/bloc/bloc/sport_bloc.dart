import 'package:flutter_app_sports/data/repositories/sport_repository.dart';
import 'package:flutter_app_sports/logic/blocs/sport/bloc/bloc/sport_event.dart';
import 'package:flutter_app_sports/logic/blocs/sport/bloc/bloc/sport_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SportBloc extends Bloc<SportEvent, SportState> {
  final SportRepository sportRepository = SportRepository();

  SportBloc() : super(SportInitial()) {
    on<FetchSportsEvent>((event, emit) async {
      emit(FetchingSports());
      try {
        final sports = await sportRepository.fetchSports();
        emit(SportsLoaded(sports!));
      } catch (e) {
        emit(SportsError());
      }
    });
    on<FetchSportsStorage>((event, emit) async {
      emit(FetchingSports());
      try {
        final sports = await sportRepository.fetchSportsStorage();
        emit(SportsLoaded(sports!));
      } catch (e) {
        emit(SportsError());
      }
    });

    on<SaveMatchSportsEvent>((event, emit) async {
      try {
        await sportRepository.saveSports(event.sports);
      } catch (e) {
        emit(SportsError());
      }
    });




  }
}
