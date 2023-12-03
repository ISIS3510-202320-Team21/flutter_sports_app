abstract class StatisticsEvent {}

class LoadStatistics extends StatisticsEvent {
  final int userId;
  final DateTime startDate;
  final DateTime endDate;

  LoadStatistics({required this.userId, required this.startDate, required this.endDate});
}

class WaitStatistics extends StatisticsEvent {}
class StatisticsResetEvent extends StatisticsEvent {}