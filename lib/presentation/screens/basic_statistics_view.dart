// statistics_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_app_sports/logic/blocs/statistics/statistic_bloc.dart';
import 'package:flutter_app_sports/logic/blocs/statistics/statistic_event.dart';
import 'package:flutter_app_sports/logic/blocs/statistics/statistic_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatisticsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<StatisticsBloc>(
      create: (context) => StatisticsBloc()..add(LoadStatistics()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Statistics'),
        ),
        body: BlocBuilder<StatisticsBloc, StatisticsState>(
          builder: (context, state) {
            if (state is StatisticsLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is StatisticsLoaded) {
              return ListView.builder(
                itemCount: state.statistics.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(state.statistics[index]),
                ),
              );
            } else if (state is StatisticsError) {
              return Center(child: Text(state.message));
            }
            // Si el estado es inicial o no se reconoce, muestra un mensaje de bienvenida.
            return Center(child: Text('Welcome to Statistics'));
          },
        ),
      ),
    );
  }
}
