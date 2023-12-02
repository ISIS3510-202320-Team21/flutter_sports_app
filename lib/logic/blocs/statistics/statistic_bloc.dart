import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app_sports/data/repositories/user_repository.dart';
import 'statistic_event.dart';
import 'statistic_state.dart';

class StatisticsBloc extends Bloc<StatisticsEvent, StatisticsState> {
  final UserRepository userRepository;

  StatisticsBloc({required this.userRepository}) : super(StatisticsInitial()) {
    on<LoadStatistics>(_onLoadStatistics);
  }

// En el StatisticsBloc
Future<void> _onLoadStatistics(
    LoadStatistics event, Emitter<StatisticsState> emit) async {
  emit(StatisticsLoading());
  try {
    var statsData = await userRepository.getUserMatchesCountBySport(
      userId: event.userId,
      startDate: event.startDate,
      endDate: event.endDate,
    );
    // Asumiendo que cada elemento de la lista es convertible a String directamente.
    emit(StatisticsLoaded(statsData));
  } catch (e) {
    emit(StatisticsError('Failed to load statistics: ${e.toString()}'));
  }
}

}
