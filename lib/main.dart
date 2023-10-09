import 'package:flutter/material.dart';
import 'package:flutter_app_sports/logic/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:flutter_app_sports/logic/blocs/global_events/bloc/global_bloc.dart';
import 'package:flutter_app_sports/logic/blocs/global_events/bloc/global_event.dart';
import 'package:flutter_app_sports/presentation/router/app_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationBloc>(
              create: (context) => AuthenticationBloc()),
          BlocProvider(create: (context) => GlobalBloc()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          onGenerateRoute: _appRouter.onGenerateRoute,
          theme: ThemeData(
            fontFamily: 'Lato',
            primaryColor: const Color(0xFF19647E),
            colorScheme: const ColorScheme(
              primary: Color(0xFF19647E),
              secondary: Color(0xFF28AFB0),
              background: Color(0xFFF5F5F5),
              surface: Color(0x00ebebeb),
              onPrimary: Color(0xFFFFFFFF),
              onSecondary: Color(0x00f5f5f5),
              onBackground: Color(0xFF37392E),
              onSurface: Color(0xFF37392E),
              onError: Color(0xFF000000),
              error: Color(0xFF000000),
              brightness: Brightness.light,
            ),
            visualDensity: VisualDensity.adaptivePlatformDensity,
            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: Color(0xFF37392E)),
              bodyMedium: TextStyle(color: Color(0xFF000000)),
              bodySmall: TextStyle(color: Color(0xFF000000)),
              headlineLarge: TextStyle(color: Color(0xFF37392E)),
            ),
          ),
        ));
  }
}
