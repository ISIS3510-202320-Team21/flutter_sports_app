import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_app_sports/data/models/notification.dart' as _notification;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/repositories/notification_repository.dart';
part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(NotificationInitial()) {
    on<NotificationInitialEvent>(notificationInitialEvent);
    on<NotificationClickedEvent>(notificationClickedEvent);
    on<FetchNotificationsStorageRecent>(fetchNotificationsStorageRecent);
    on<SaveNotificationsStorageRecent>(saveNotificationsStorageRecent);
  }

  FutureOr<void> notificationInitialEvent(NotificationInitialEvent event, Emitter<NotificationState> emit) async {
    emit(NotificationLoadingState());
    try {
      List<_notification.Notification>? notifications = await NotificationRepository().getNotifications(userid: event.userId);
      emit(NotificationLoadedSuccessState(notifications: notifications!));
    } catch (e) {
      print(e);
      emit(NotificationErrorState());
    }
  }

  Future<FutureOr<void>> notificationClickedEvent(NotificationClickedEvent event, Emitter<NotificationState> emit) async {
    event.notification.seen = true;
    try {
      await NotificationRepository().updateNotification(event.notification.id);
      print("Notification updated");
      emit(NotificationClickActionState());
    } catch (e) {
      print(e);
      emit(NotificationErrorState());
    }
  }

  FutureOr<void> fetchNotificationsStorageRecent(
      FetchNotificationsStorageRecent event, Emitter<NotificationState> emit) async {
    emit(NotificationLoadingState());
    try {
      List<_notification.Notification> notifications =
      await NotificationRepository()
          .getNotificationsStorageRecent();
      emit(NotificationLoadedSuccessState(notifications: notifications!));
    } catch (e) {
      emit(NotificationErrorState());
    }
  }

  FutureOr<void> saveNotificationsStorageRecent(
      SaveNotificationsStorageRecent event, Emitter<NotificationState> emit) async {
    try {
      await NotificationRepository()
          .saveNotificationsStorageRecent(event.notifications);
    } catch (e) {
      emit(NotificationErrorState());
    }
  }
}
