part of 'connectivity_cubit.dart';

@immutable
abstract class ConnectivityState {}

class ConnectivityLoading extends ConnectivityState {}

class InternetConnected extends ConnectivityState {
  InternetConnected();
}

class InternetDisconnected extends ConnectivityState {}
