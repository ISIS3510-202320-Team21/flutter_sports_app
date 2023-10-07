import 'package:flutter/material.dart';

import 'bottom_bar.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  _NotificationsViewState createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
            backgroundColor: Colors.white,
            title: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'NOTIFICATIONS',
                style: TextStyle(
                  color: Color(0xFF37392E),
                  fontSize: 29,
                  fontFamily: 'Lato',
                ),
              ),
              
            ) 
          ),
      body: const Center(
        child: Text(
          'Hello, Notifications!',
          style: TextStyle(fontSize: 24),
        ),
      ),
        bottomNavigationBar: const BottomNavigationBarView()
    );
  }
}
