import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_sports/logic/blocs/notification/bloc/notification_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app_sports/data/models/notification.dart' as _notification;
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
    super.initState();
  }

  Future<void> checkInitialConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      notificationBloc.add(FetchNotificationsStorageRecent());
    } else {
      int? userId = BlocProvider.of<AuthenticationBloc>(context).user?.id;
      notificationBloc.add(NotificationInitialEvent(userId: userId!));
    }
  }

  @override
  Widget build(BuildContext context) {
    checkInitialConnectivity();
    return BlocConsumer<NotificationBloc,NotificationState>(
      bloc: notificationBloc,
      listenWhen: (previous, current) => current is NotificationActionState,
      buildWhen: (previous, current) => current is! NotificationActionState,
      listener: (context, state) {
        if (state is NotificationLoadedSuccessState) {
          notificationBloc.add(
              SaveNotificationsStorageRecent(state.notifications));
        } else if (state is NotificationClickActionState) {

        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case NotificationLoadingState:
            return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ));
          case NotificationLoadedSuccessState:
            final successState = state as NotificationLoadedSuccessState;
            notificationBloc.add(
                SaveNotificationsStorageRecent(state.notifications));
            return RefreshIndicator(
              onRefresh: checkInitialConnectivity,
              child: Scaffold(
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
