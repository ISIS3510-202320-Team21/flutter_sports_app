import 'package:flutter/material.dart';
import 'package:flutter_app_sports/logic/blocs/notification/bloc/notification_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../logic/blocs/authentication/bloc/authentication_bloc.dart';
import '../../widgets/NotificationTile.dart';

import 'package:flutter_app_sports/data/models/notification.dart' as _notification;

class DetailedNotificationView extends StatefulWidget {
  final _notification.Notification notification;

  const DetailedNotificationView({super.key, required this.notification});

  @override
  _DetailedNotificationViewState createState() => _DetailedNotificationViewState();
}

class _DetailedNotificationViewState extends State<DetailedNotificationView> {
  final NotificationBloc notificationBloc = NotificationBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Building");
    return BlocConsumer<NotificationBloc,NotificationState>(
      bloc: notificationBloc,
      listenWhen: (previous, current) => current is NotificationActionState,
      buildWhen: (previous, current) => current is! NotificationActionState,
      listener: (context, state) {},
      builder: (context, state) {
        //show notification name and creationDate using a column that's centered
        return Scaffold(
          body: Center(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                ListTile(
                  leading: IconButton(
                    icon: Icon(Icons.notifications),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  title: Text(
                    widget.notification.name,
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 10),
                ListTile(
                  leading: IconButton(
                    icon: Icon(Icons.date_range),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  title: Text(
                    widget.notification.creationDate.toString().substring(0,16),
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
