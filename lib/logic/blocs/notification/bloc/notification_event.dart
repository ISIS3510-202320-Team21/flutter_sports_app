part of 'notification_bloc.dart';

@immutable
abstract class NotificationEvent {}

final class NotificationInitialEvent extends NotificationEvent {}

class NotificationClickedEvent extends NotificationEvent {
  final _notification.Notification notification;
  NotificationClickedEvent({
    required this.notification,
  });
}