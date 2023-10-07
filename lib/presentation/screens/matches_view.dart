import 'package:flutter/material.dart';

import 'bottom_bar.dart';

class MatchesView extends StatefulWidget {
  const MatchesView({super.key});

  @override
  _MatchesViewState createState() => _MatchesViewState();
}

class _MatchesViewState extends State<MatchesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            title: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'MATCHES',
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
            'Hello, Matches!',
            style: TextStyle(fontSize: 24),
          ),
        ),
        bottomNavigationBar: const BottomNavigationBarView()
    );
  }
}
