//implement stateless widget that returns a container to display a notification
import 'package:flutter/material.dart';
import 'package:flutter_app_sports/logic/blocs/notification/bloc/notification_bloc.dart';
import 'package:flutter_app_sports/data/models/notification.dart' as _notification;

class NotificationTile extends StatelessWidget {
  final _notification.Notification notification;
  final NotificationBloc notificationBloc;
  const NotificationTile(
      {Key? key, required this.notification, required this.notificationBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    //return a container with the notification info
    return InkWell(
      child: Container(
        //add action if container is clicked
        margin: const EdgeInsets.only(top: 7.5, bottom:7.5),
        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
        decoration: BoxDecoration(
          color: colorScheme.background,
        ),
        child: Column(
          children: [
            Center(
              child: Text(
                notification.name,
                style: TextStyle(
                    fontSize: 20,
                    color: colorScheme.onBackground),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        notificationBloc.add(NotificationClickedEvent(notification: notification));
      },
    );
  }
}