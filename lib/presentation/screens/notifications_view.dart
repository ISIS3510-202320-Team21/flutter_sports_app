import 'package:flutter/material.dart';
import 'package:flutter_app_sports/logic/blocs/notification/bloc/notification_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/blocs/authentication/bloc/authentication_bloc.dart';
import '../widgets/NotificationTile.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  _NotificationsViewState createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  final NotificationBloc notificationBloc = NotificationBloc();

  @override
  void initState() {
    int? userId = BlocProvider.of<AuthenticationBloc>(context).userId;
    notificationBloc.add(NotificationInitialEvent(userId: userId!));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int? userId = BlocProvider.of<AuthenticationBloc>(context).userId;
    return BlocConsumer<NotificationBloc,NotificationState>(
      bloc: notificationBloc,
      listenWhen: (previous, current) => current is NotificationActionState,
      buildWhen: (previous, current) => current is! NotificationActionState,
      listener: (context, state) {},
      builder: (context, state) {
        switch (state.runtimeType) {
          case NotificationLoadingState:
            return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ));
          case NotificationLoadedSuccessState:
            final successState = state as NotificationLoadedSuccessState;
            return Scaffold(
              body: Column(
                children: [
                  //add padding to the top
                  const Padding(
                    padding: EdgeInsets.only(top: 15.0),
                  ),
                  Expanded(
                    child: ListView.builder(
                      //add padding between the items
                      itemCount: successState.notifications.length,
                      itemBuilder: (context, index) {
                        return NotificationTile(
                          notification: successState.notifications[index],
                          notificationBloc: notificationBloc,
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          case NotificationErrorState:
            return const Scaffold(body: Center(child: Text('Error')));
          default:
            return const SizedBox();
        }
      },
    );
  }
}
