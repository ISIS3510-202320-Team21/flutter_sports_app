import 'package:flutter/material.dart';

import 'bottom_bar.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile view'),
        backgroundColor: const Color.fromRGBO(170, 62, 152, 1),
      ),
      body: const Center(
        child: Text(
          'Hello, Profile!',
          style: TextStyle(fontSize: 24),
        ),
      ),
        bottomNavigationBar: const BottomNavigationBarView()
    );
  }
}
