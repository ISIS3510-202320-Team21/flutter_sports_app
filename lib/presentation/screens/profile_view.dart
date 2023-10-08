import 'package:flutter/material.dart';
import 'package:flutter_app_sports/presentation/widgets/SquareIconButton.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  Widget _iconButtonWithBackground(IconData iconData, VoidCallback onPressed) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8.0),
      ),
      margin: const EdgeInsets.all(4.0),
      child: IconButton(
        icon: Icon(
          iconData,
          color: colorScheme.onBackground,
          size: 30, // Aumentado el tamaño para que se vea más grueso
        ),
        onPressed: onPressed,
      ),
    );
  }

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
          "MY PROFILE",
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
      body: const Stack(
        children: [
          SafeArea(
            child: Center(
              child: Text(
                'Hello, Profile!',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
          ),
        ],
      ),
    );
  }
}
