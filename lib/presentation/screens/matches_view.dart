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
          title: const Text('Matches view'),
          backgroundColor: const Color.fromRGBO(170, 62, 152, 1),
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
