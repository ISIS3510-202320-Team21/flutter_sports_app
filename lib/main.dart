import 'package:camera/camera.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_sports/logic/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:flutter_app_sports/logic/blocs/camera/bloc/camera_bloc.dart';
import 'package:flutter_app_sports/logic/blocs/connectivity/bloc/connectivity_bloc.dart';
import 'package:flutter_app_sports/logic/blocs/fetch/bloc/fetch_bloc.dart';
import 'package:flutter_app_sports/logic/blocs/global_events/bloc/global_bloc.dart';
import 'package:flutter_app_sports/logic/blocs/match/bloc/match_bloc.dart';
import 'package:flutter_app_sports/logic/blocs/profile/profile_bloc.dart';
import 'package:flutter_app_sports/presentation/router/app_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppRouter _appRouter = AppRouter();
  String red = 'unknown';
  @override
  Widget build(BuildContext context) {
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
            surface: Color(0x00EBEBEB),
            onPrimary: Color(0xFFFFFFFF),
            onSecondary: Color(0x00F5F5F5),
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

        builder: (context, child) {
          return Builder(
            builder: (context) {
              return BlocListener<ConnectivityBloc, ConnectivityState>(
                listener: (context, state) {
                  if (state is ConnectivityOffline) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Se perdió la conexión a Internet.'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    red = 'offline';
                  } else if (state is ConnectivityOnline && red != 'unknown') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Se recuperó la conexión a Internet.'),
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
