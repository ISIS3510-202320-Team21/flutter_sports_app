// statistic_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'statistic_event.dart';
import 'statistic_state.dart';

class StatisticsBloc extends Bloc<StatisticsEvent, StatisticsState> {
  StatisticsBloc() : super(StatisticsInitial()) {
    on<LoadStatistics>(_onLoadStatistics);
  }

  Future<void> _onLoadStatistics(
      LoadStatistics event, Emitter<StatisticsState> emit) async {
    emit(StatisticsLoading());
    try {
      // Aquí es donde cargarías tus datos reales
      await Future.delayed(const Duration(seconds: 2)); // Simulación
      emit(StatisticsLoaded(['Stat 1', 'Stat 2', 'Stat 3']));
    } catch (e) {
      emit(StatisticsError('Failed to load statistics'));
    }
  }
}
