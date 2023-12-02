import 'dart:async';

import 'package:camera/camera.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_sports/data/repositories/user_repository.dart';
import 'package:flutter_app_sports/logic/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:flutter_app_sports/logic/blocs/camera/bloc/camera_bloc.dart';
import 'package:flutter_app_sports/logic/blocs/connectivity/bloc/connectivity_bloc.dart';
import 'package:flutter_app_sports/logic/blocs/fetch/bloc/fetch_bloc.dart';
import 'package:flutter_app_sports/logic/blocs/global_events/bloc/global_bloc.dart';
import 'package:flutter_app_sports/logic/blocs/match/bloc/match_bloc.dart';
import 'package:flutter_app_sports/logic/blocs/profile/profile_bloc.dart';
import 'package:flutter_app_sports/logic/blocs/statistics/statistic_bloc.dart';
import 'package:flutter_app_sports/logic/blocs/statistics/statistic_event.dart';
import 'package:flutter_app_sports/presentation/router/app_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  final userRepository = UserRepository();
  runApp(MyApp(userRepository: userRepository));
}

class MyApp extends StatefulWidget {
  final UserRepository userRepository;
  const MyApp({Key? key, required this.userRepository}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppRouter _appRouter = AppRouter();
  String red = 'unknown';
  bool _isConnected = true;
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
    checkInitialConnectivity();
  }

  void checkInitialConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    _updateConnectionStatus(connectivityResult);
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    setState(() {
      _isConnected = result != ConnectivityResult.none;
    });
    if (_isConnected) {
      _retryConnection();
    }
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  void _retryConnection() {}
  @override
  Widget build(BuildContext context) {
    if (_isConnected) {
      red = 'online';
    } else {
      red = 'offline';
    }
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
            create: (context) => AuthenticationBloc()..add(CheckSession())),
        BlocProvider<CameraBloc>(create: (context) => CameraBloc()),
        BlocProvider(create: (context) => GlobalBloc()),
        BlocProvider(
            create: (context) =>
                ConnectivityBloc(connectivity: Connectivity())),
        BlocProvider(create: (context) => FetchBloc()),
        BlocProvider(create: (context) => ProfileBloc()),
        RepositoryProvider<UserRepository>(
          create: (context) => widget.userRepository,
        ),
        BlocProvider(
            create: (context) =>
                StatisticsBloc(userRepository: widget.userRepository),
            ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: _appRouter.onGenerateRoute,
        theme: ThemeData(
          fontFamily: 'Lato',
          primaryColor: const Color(0xFF19647E),
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF19647E),
            secondary: Color(0xFF28AFB0),
            background: Color(0xFFFFFFFF),
            onPrimary: Color(0xFFFFFFFF),
            onSecondary: Color.fromARGB(0, 214, 212, 212),
            onBackground: Color(0xFF37392E),
            onSurface: Color(0xFF37392E),
            surface: Color(0xFFFFFFFF),
            onError: Color(0xFF000000),
            error: Color(0xFF000000),
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Color(0xFF37392E)),
            bodyMedium: TextStyle(color: Color(0xFF000000)),
            bodySmall: TextStyle(color: Color(0xFF000000)),
            headlineLarge: TextStyle(color: Color(0xFF37392E)),
          ),
        ),
        builder: (context, child) {
          return Builder(
            builder: (context) {
              return BlocListener<ConnectivityBloc, ConnectivityState>(
                listener: (context, state) {
                  if (state is ConnectivityOffline) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Internet connection lost. Please check your connection.'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    red = 'offline';
                  } else if (state is ConnectivityOnline && red != 'unknown') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Internet connection restored.'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    red = 'online';
                  }
                },
                child: child,
              );
            },
          );
        },
      ),
    );
  }
}
