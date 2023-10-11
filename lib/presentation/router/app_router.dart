import 'package:flutter/material.dart';
import 'package:flutter_app_sports/presentation/screens/login_view.dart';
import 'package:flutter_app_sports/presentation/screens/notifications_view.dart';
import 'package:flutter_app_sports/presentation/screens/signUp_view.dart';
import 'package:flutter_app_sports/presentation/screens/MainLayout.dart';

class AppRouter {
  MaterialPageRoute? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => LoginView(),
        );
      case "/signUp":
        return MaterialPageRoute(
          builder: (_) => const SignUpView(),
        );
      case '/home':
        return MaterialPageRoute(
          builder: (_) => const MainLayout(),
        );
      case '/notifications':
        return MaterialPageRoute(
          builder: (_) => const NotificationsView(),
        );

      default:
        return null;
    }
  }
}
