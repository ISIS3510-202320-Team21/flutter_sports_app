part of 'notification_bloc.dart';

@immutable
abstract class NotificationState  {}

abstract class NotificationActionState extends NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoadingState extends NotificationState {}

class NotificationLoadedSuccessState extends NotificationState {
  final List<_notification.Notification> notifications;
  NotificationLoadedSuccessState({
    required this.notifications,
  });
}

class NotificationErrorState extends NotificationState {}

class NotificationClickActionState extends NotificationActionState {}

class NewNotificationNavigateActionState extends NotificationActionState {}