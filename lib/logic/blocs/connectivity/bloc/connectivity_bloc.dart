// connectivity_bloc.dart

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_app_sports/main.dart';
import 'package:meta/meta.dart';

part 'connectivity_event.dart';
part 'connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final Connectivity _connectivity;
  StreamSubscription? _connectivitySubscription;

  ConnectivityBloc({required Connectivity connectivity})
      : _connectivity = connectivity,
        super(ConnectivityInitial()) {
    on<ConnectivityChanged>(_onConnectivityChanged);
    
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (ConnectivityResult result) {
        add(ConnectivityChanged(result == ConnectivityResult.none
            ? ConnectivityStatus.offline
            : ConnectivityStatus.online));
      },
    );
  }

  void _onConnectivityChanged(
      ConnectivityChanged event,
      Emitter<ConnectivityState> emit,
    ) {
      emit(event.status == ConnectivityStatus.online
          ? ConnectivityOnline()
          : ConnectivityOffline());
    }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
