import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_app_sports/data/models/user.dart';
import 'package:flutter_app_sports/data/repositories/auth_repository.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeNotificationButtonClickedEvent>(homeNotificationButtonClickedEvent);
    on<HomeReservationButtonClickedEvent>(homeReservationButtonClickedEvent);
    on<HomeManageMatchesButtonClickedEvent>(
        homeManageMatchesButtonClickedEvent);
    on<HomeQuickMatchButtonClickedEvent>(homeQuickMatchButtonClickedEvent);
    on<HomeNewMatchButtonClickedEvent>(homeNewMatchButtonClickedEvent);
    on<HomeProfileButtonClickedEvent>(homeProfileButtonClickedEvent);
  }

  FutureOr<void> homeNotificationButtonClickedEvent(
      HomeNotificationButtonClickedEvent event, Emitter<HomeState> emit) {
    print('Notifications clicked');
    emit(HomeNavigateToNotificationState());
  }

  FutureOr<void> homeReservationButtonClickedEvent(
      HomeReservationButtonClickedEvent event, Emitter<HomeState> emit) {
    print('Reservation clicked');
    emit(HomeNavigateToReservationState());
  }

  FutureOr<void> homeManageMatchesButtonClickedEvent(
      HomeManageMatchesButtonClickedEvent event, Emitter<HomeState> emit) {
    print('Manage matches clicked');
    emit(HomeNavigateToManageMatchesState());
  }

  FutureOr<void> homeQuickMatchButtonClickedEvent(
      HomeQuickMatchButtonClickedEvent event, Emitter<HomeState> emit) {
    print('Quick match clicked');
    emit(HomeNavigateToQuickMatchState());
  }

  FutureOr<void> homeNewMatchButtonClickedEvent(
      HomeNewMatchButtonClickedEvent event, Emitter<HomeState> emit) {
    print('New match clicked');
    emit(HomeNavigateToNewMatchState());
  }

  FutureOr<void> homeProfileButtonClickedEvent(
      HomeProfileButtonClickedEvent event, Emitter<HomeState> emit) {
    print('Profile clicked');
    emit(HomeNavigateToProfileState());
  }
}
