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
  }

  FutureOr<void> notificationInitialEvent(NotificationInitialEvent event, Emitter<NotificationState> emit) async {
    emit(NotificationLoadingState());
    try {
      List<_notification.Notification>? notifications = await NotificationRepository().getNotifications(userid: 1);
      emit(NotificationLoadedSuccessState(notifications: notifications!));
    } catch (e) {
      print(e);
      emit(NotificationErrorState());
    }
  }

  FutureOr<void> notificationClickedEvent(NotificationClickedEvent event, Emitter<NotificationState> emit) {
    print('Notification clicked');
    emit(NotificationClickActionState());
  }
}
