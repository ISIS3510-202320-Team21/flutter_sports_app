import 'dart:async';
import 'dart:ffi';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_sports/data/models/classes.dart';
import 'package:flutter_app_sports/data/repositories/user_repository.dart';
import 'package:flutter_app_sports/logic/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:flutter_app_sports/logic/blocs/statistics/statistic_bloc.dart';
import 'package:flutter_app_sports/logic/blocs/statistics/statistic_event.dart';
import 'package:flutter_app_sports/logic/blocs/statistics/statistic_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class StatisticsScreen extends StatefulWidget {
  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  DateTime? startDate;
  DateTime? endDate;
  late int userId;
  late bool isPanelOpen = false;
  @override
  void initState() {
    super.initState();
    final user = BlocProvider.of<AuthenticationBloc>(context).user!;
    userId = user.id;
    _startPeriodicUpdates();
  }

  void _startPeriodicUpdates() {
    if (startDate == null || endDate == null) {
      BlocProvider.of<StatisticsBloc>(context, listen: false)
          .add(WaitStatistics());
    } else {
      Timer.periodic(const Duration(seconds: 10), (timer) {
        BlocProvider.of<StatisticsBloc>(context, listen: false).add(
          LoadStatistics(
              userId: userId, startDate: startDate!, endDate: endDate!),
        );
      });
    }
  }

Future<void> _showDateRangePicker(BuildContext context, StateSetter setState,
    {bool isStartDate = true}) async {
    final DateTime initialDate =
        (isStartDate ? startDate : endDate) ?? DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate == null) return; // User canceled

    setState(() {
      if (isStartDate) {
        startDate = pickedDate;
      } else {
        endDate = pickedDate;
      }
    });
    _loadStatistics();
  }

  void _loadStatistics() {
    if (startDate != null && endDate != null) {
      BlocProvider.of<StatisticsBloc>(context).add(
        LoadStatistics(
            userId: userId, startDate: startDate!, endDate: endDate!),
      );
    }
  }

void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return StatefulBuilder(  // Usa StatefulBuilder aquí
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildDateButton(
                    icon: Icons.calendar_today,
                    label: 'Start: ',
                    date: startDate,
                    onPressed: () => _showDateRangePicker(
                        context, setState, isStartDate: true),
                  ),
                  _buildDateButton(
                    icon: Icons.calendar_today,
                    label: 'End: ',
                    date: endDate,
                    onPressed: () => _showDateRangePicker(
                        context, setState, isStartDate: false),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: BlocBuilder<StatisticsBloc, StatisticsState>(
            builder: (context, state) {
              // Aquí, pasas el estado actual al método _buildMainContent.
              return _buildMainContent(state);
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: "statistics",
          onPressed: () => _showBottomSheet(context),
          child: const Icon(Icons.date_range),
        ),
      ),
    );
  }

  Widget _buildLegendItem(String name, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 20,
          height: 20,
          color: color,
        ),
        const SizedBox(width: 8),
        Text(name),
      ],
    );
  }

  Widget _buildMainContent(StatisticsState state) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Text(
            'Top Sports by Matches',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),

          // Rango de fechas debajo del título principal
          Text(
            'Between ${startDate != null ? DateFormat('dd/MM/yyyy').format(startDate!) : 'Start Date'} and ${endDate != null ? DateFormat('dd/MM/yyyy').format(endDate!) : 'End Date'}',
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),

          // Espacio después del título
          const SizedBox(height: 10),
          BlocBuilder<StatisticsBloc, StatisticsState>(
            builder: (context, state) {
              if (state is StatisticsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is StatisticsLoaded) {
                double chartWidth = MediaQuery.of(context).size.width;

                // Determinar los top 3 deportes y colores
                var sortedStatistics = List.of(state.statistics);
                sortedStatistics
                    .sort((a, b) => b.matchCount.compareTo(a.matchCount));
                var top3sports =
                    sortedStatistics.take(3).map((e) => e.name).toList();
                List<Color> topColors = [
                  Colors.blue,
                  Colors.green,
                  Colors.red,
                ];

                List<String> top = ["Top 1", "Top 2", "Top 3"];

                // Crear leyenda
                List<Widget> legendItems = List.generate(
                  top3sports.length,
                  (index) => _buildLegendItem(top[index], topColors[index]),
                );

                return Column(
                  children: [
                    SizedBox(
                      width: chartWidth,
                      height: 400,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          barTouchData: BarTouchData(
                            touchTooltipData: BarTouchTooltipData(
                              tooltipBgColor: Colors.grey,
                              getTooltipItem:
                                  (group, groupIndex, rod, rodIndex) {
                                String sportName =
                                    state.statistics[group.x.toInt()].name;
                                String value = state
                                    .statistics[group.x.toInt()].matchCount
                                    .toString();
                                return BarTooltipItem(
                                  '$sportName\n$value Matches',
                                  const TextStyle(color: Colors.white),
                                );
                              },
                            ),
                            touchCallback:
                                (FlTouchEvent event, barTouchResponse) {
                              setState(() {
                                if (event.isInterestedForInteractions &&
                                    barTouchResponse != null &&
                                    barTouchResponse.spot != null) {
                                  int touchedIndex = barTouchResponse
                                      .spot!.touchedBarGroupIndex;
                                  double touchedValue = state
                                      .statistics[touchedIndex].matchCount
                                      .toDouble();
                                  // Aquí puedes hacer algo con el valor tocado
                                  print(
                                      "Barra tocada: $touchedIndex, Valor: $touchedValue");
                                }
                              });
                            },
                          ),
                          titlesData: FlTitlesData(
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 100,
                                getTitlesWidget:
                                    (double value, TitleMeta meta) {
                                  final String sportName =
                                      state.statistics[value.toInt()].name;
                                  return RotatedBox(
                                    quarterTurns: 3, // Rota el texto 90 grados
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        sportName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          gridData: const FlGridData(show: false),
                          borderData: FlBorderData(show: false),
                          barGroups:
                              state.statistics.asMap().entries.map((entry) {
                            int index = top3sports.indexOf(entry.value.name);
                            Color barColor =
                                index != -1 ? topColors[index] : Colors.grey;

                            return BarChartGroupData(
                              x: entry.key,
                              barRods: [
                                BarChartRodData(
                                  toY: entry.value.matchCount.toDouble(),
                                  color: barColor,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4)),
                                  rodStackItems: [],
                                ),
                              ],
                              showingTooltipIndicators: [],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 300,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: legendItems,
                      ),
                    ),
                  ],
                );
              } else if (state is StatisticsError) {
                return Center(child: Text(state.message));
              }
              return const Center(
                child: Text('Select a date range to view statistics.'),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDateButton(
      {required IconData icon,
      required String label,
      DateTime? date,
      required VoidCallback onPressed}) {
    return TextButton(
      onPressed: onPressed,
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          Text(
              date != null
                  ? '$label${DateFormat('dd/MM/yyyy').format(date)}'
                  : '$label Not Set',
              style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

}
