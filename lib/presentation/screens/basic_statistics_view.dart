import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_sports/logic/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:flutter_app_sports/logic/blocs/statistics/statistic_bloc.dart';
import 'package:flutter_app_sports/logic/blocs/statistics/statistic_event.dart';
import 'package:flutter_app_sports/logic/blocs/statistics/statistic_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class StatisticsScreen extends StatefulWidget {
  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  DateTime? startDate;
  DateTime? endDate;
  late int userId;
  late bool isPanelOpen = false;
  bool isOffline = false;
  bool stop = false;
  Timer? _updateTimer;

  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    final user = BlocProvider.of<AuthenticationBloc>(context).user!;
    userId = user.id;
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
    checkInitialConnectivity();
    _startPeriodicUpdates();
  }

  void checkInitialConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    _updateConnectionStatus(connectivityResult);
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    setState(() {
      isOffline = result == ConnectivityResult.none;
    });
  }

  void stopPeriodicUpdates() {
    _updateTimer?.cancel(); // Cancela el temporizador
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    _connectivitySubscription?.cancel();
    super.dispose();
  }
  

  void _startPeriodicUpdates() {
    // Detiene el timer si ya está corriendo
    _updateTimer?.cancel();

    // Inicia un nuevo timer
    _updateTimer = Timer.periodic(const Duration(seconds: 20), (timer) {
      if (mounted) {
        if (startDate == null || endDate == null) {
          BlocProvider.of<StatisticsBloc>(context, listen: false)
              .add(WaitStatistics());
        } else {
          BlocProvider.of<StatisticsBloc>(context, listen: false).add(
            LoadStatistics(
                userId: userId, startDate: startDate!, endDate: endDate!),
          );
        }
      }
    });
  }

  void _stopPeriodicUpdates() {
    _updateTimer?.cancel();
    _updateTimer = null;
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
    if (pickedDate == null) return;

    if (isStartDate) {
      if (endDate != null && pickedDate.isAfter(endDate!)) {
        return;
      }
    } else {
      if (startDate != null && pickedDate.isBefore(startDate!)) {
        return;
      }
    }

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
        return StatefulBuilder(
          // Usa StatefulBuilder aquí
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
                    onPressed: () => _showDateRangePicker(context, setState,
                        isStartDate: true),
                  ),
                  _buildDateButton(
                    icon: Icons.calendar_today,
                    label: 'End: ',
                    date: endDate,
                    onPressed: () => _showDateRangePicker(context, setState,
                        isStartDate: false),
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
        body: isOffline ? _buildOfflineWidget() : _buildStatisticsWidget(),
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

  Widget _buildOfflineWidget() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.bar_chart_outlined, size: 80, color: Colors.grey),
          SizedBox(height: 20),
          Text("You are offline and you can't see the statistics."),
        ],
      ),
    );
  }

  Widget _buildStatisticsWidget() {
    return Center(
      child: BlocBuilder<StatisticsBloc, StatisticsState>(
        builder: (context, state) {
          if (state is StatisticsLogout) {
            _stopPeriodicUpdates();
          } else {
            _startPeriodicUpdates();
          }

          return _buildMainContent(context, state);
        },
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, StatisticsState state) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Text(
            'Top Sports by Matches',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Text(
            'Between ${startDate != null ? DateFormat('dd/MM/yyyy').format(startDate!) : 'Start Date'} and ${endDate != null ? DateFormat('dd/MM/yyyy').format(endDate!) : 'End Date'}',
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          // Aquí manejas los diferentes estados
          if (state is StatisticsLoading)
            const Center(child: CircularProgressIndicator())
          else if (state is StatisticsLoaded) ...[
            _buildStatisticsLoadedUI(state, context)
          ] // Usar spread operator
          else if (state is StatisticsError)
            Center(child: Text(state.message))
          else
            const Center(
              child: Text('Select a date range to view statistics.'),
            ),
        ],
      ),
    );
  }

  Widget _buildStatisticsLoadedUI(
      StatisticsLoaded state, BuildContext context) {
    double chartWidth = MediaQuery.of(context).size.width;

    var sortedStatistics = List.of(state.statistics);
    sortedStatistics.sort((a, b) => b.matchCount.compareTo(a.matchCount));
    var top3sports = sortedStatistics.take(3).map((e) => e.name).toList();
    List<Color> topColors = [
      Colors.blue,
      Colors.green,
      Colors.red,
    ];

    List<String> top = ["Top 1", "Top 2", "Top 3"];

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
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    String sportName = state.statistics[group.x.toInt()].name;
                    String value =
                        state.statistics[group.x.toInt()].matchCount.toString();
                    return BarTooltipItem(
                      '$sportName\n$value Matches',
                      const TextStyle(color: Colors.white),
                    );
                  },
                ),
                touchCallback: (FlTouchEvent event, barTouchResponse) {
                  setState(() {
                    if (event.isInterestedForInteractions &&
                        barTouchResponse != null &&
                        barTouchResponse.spot != null) {
                      int touchedIndex =
                          barTouchResponse.spot!.touchedBarGroupIndex;
                      double touchedValue =
                          state.statistics[touchedIndex].matchCount.toDouble();
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
                    getTitlesWidget: (double value, TitleMeta meta) {
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
              barGroups: state.statistics.asMap().entries.map((entry) {
                int index = top3sports.indexOf(entry.value.name);
                Color barColor = index != -1 ? topColors[index] : Colors.grey;

                return BarChartGroupData(
                  x: entry.key,
                  barRods: [
                    BarChartRodData(
                      toY: entry.value.matchCount.toDouble(),
                      color: barColor,
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
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
