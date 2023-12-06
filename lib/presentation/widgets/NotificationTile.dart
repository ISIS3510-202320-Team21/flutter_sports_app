//implement stateless widget that returns a container to display a notification
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_sports/logic/blocs/global_events/bloc/global_event.dart';
import 'package:flutter_app_sports/logic/blocs/notification/bloc/notification_bloc.dart';
import 'package:flutter_app_sports/data/models/notification.dart' as _notification;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app_sports/logic/blocs/global_events/bloc/global_bloc.dart';

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
          color: notification.seen ?
          const Color(0xE9E9E9E9) :
          const Color(0xF7F7F7F7),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                notification.name,
                style: TextStyle(
                  color: colorScheme.onBackground, // Color del texto
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Image.asset(
              "assets/arrow_1.png",
              width: 40,
              height: 40,
            ),
          ],
        ),
      ),
      onTap: () {
        _goToNotification(context);
      }
    );
  }

  Future<void> _goToNotification(BuildContext context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      notificationBloc.add(NotificationClickedEvent(notification: notification));
    }
    BlocProvider.of<GlobalBloc>(context)
        .add(NavigateToNotificationEvent(notification));
  }
}