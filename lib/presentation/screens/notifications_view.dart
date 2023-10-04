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
        title: const Text('Notifications view'),
        backgroundColor: const Color.fromRGBO(170, 62, 152, 1),
      ),
      body: const Center(
        child: Text(
          'Hello, World!',
          style: TextStyle(fontSize: 24),
        ),
      ),
        bottomNavigationBar: const BottomNavigationBarExample()
    );
  }
}
