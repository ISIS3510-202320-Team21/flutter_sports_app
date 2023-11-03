part of 'connectivity_bloc.dart';

abstract class ConnectivityEvent extends Equatable {
  const ConnectivityEvent();

  @override
  List<Object> get props => [];
}

class ConnectivityChanged extends ConnectivityEvent {
  final ConnectivityStatus status;

  const ConnectivityChanged(this.status);

  @override
  List<Object> get props => [status];
}
