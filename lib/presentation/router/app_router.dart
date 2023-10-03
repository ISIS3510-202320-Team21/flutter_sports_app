import 'package:flutter/material.dart';
import 'package:sportsapp/presentation/screens/home_view.dart';
import 'package:sportsapp/presentation/screens/login_view.dart';
import 'package:sportsapp/presentation/screens/signUp_view.dart';

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
          builder: (_) => SignUpView(),
        );
      case '/home':
        return MaterialPageRoute(
          builder: (_) => HomeView(),
        );

      default:
        return null;
    }
  }
}
