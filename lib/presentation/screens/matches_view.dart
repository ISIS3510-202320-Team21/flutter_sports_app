import 'package:flutter/material.dart';
import 'package:flutter_app_sports/presentation/widgets/CustomBottomNavigationBar.dart';
import 'package:flutter_app_sports/presentation/widgets/SquareIconButton.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MatchesView extends StatefulWidget {
  const MatchesView({super.key});

  @override
  _MatchesViewState createState() => _MatchesViewState();
}

class _MatchesViewState extends State<MatchesView> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    ScreenUtil.init(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: colorScheme.onPrimary,
        elevation: 0.0,
        title: Text(
          "MATCHES",
          style: textTheme.headlineSmall?.copyWith(
            color: colorScheme.onBackground,
            fontWeight: FontWeight.bold,
          ),
        ),
        toolbarHeight: 0.1 * ScreenUtil().screenHeight,
        iconTheme: IconThemeData(
          color: colorScheme.onBackground,
        ),
        actions: [
          SquareIconButton(
            iconData: Icons.message,
            onPressed: () {
              // Acción para el ícono de mensajes
            },
          ),
          SquareIconButton(
            iconData: Icons.notifications,
            onPressed: () {
              // Acción para el ícono de notificaciones
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          const SafeArea(
            child: Center(
              child: Text(
                'Hello, Matches!',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SquareIconButton(
                  iconData: Icons.add,
                  onPressed: () {
                    // Acción para el ícono de notificaciones
                  },
                )),
          ),
        ],
      ),
    );
  }
}
