import 'package:flutter/material.dart';
import 'package:flutter_app_sports/presentation/screens/home_view.dart';
import 'package:flutter_app_sports/presentation/screens/login_view.dart';
import 'package:flutter_app_sports/presentation/screens/signUp_view.dart';

class AppRouter {
  MaterialPageRoute? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => LoginView(),
        );
      case '/login':
        return MaterialPageRoute(
          builder: (_) => LoginView(),
        );

      case "/signUp":
        return MaterialPageRoute(
          builder: (_) => const SignUpView(),
        );
      case '/home':
        return MaterialPageRoute(
          builder: (_) => const HomeView(),
        );

      default:
        return null;
    }
  }
}
