part of 'notification_bloc.dart';

@immutable
abstract class NotificationEvent {}

final class NotificationInitialEvent extends NotificationEvent {
  final int userId;
  NotificationInitialEvent({
    required this.userId,
  });
}

class NotificationClickedEvent extends NotificationEvent {
  final _notification.Notification notification;
  NotificationClickedEvent({
    required this.notification,
  });
}

class FetchNotificationsStorageRecent extends NotificationEvent{
  FetchNotificationsStorageRecent();
}

class SaveNotificationsStorageRecent extends NotificationEvent{
  final List<_notification.Notification> notifications;
  SaveNotificationsStorageRecent(this.notifications);
}