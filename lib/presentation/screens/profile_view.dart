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
            backgroundColor: Colors.white,
            title: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'MY PROFILE',
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
          'Hello, Profile!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
