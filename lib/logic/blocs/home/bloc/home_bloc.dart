import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_app_sports/data/models/sport.dart';
import 'package:flutter_app_sports/data/models/user.dart';
import 'package:flutter_app_sports/data/repositories/auth_repository.dart';
import 'package:flutter_app_sports/data/repositories/user_repository.dart';
//import 'package:equatable/equatable.dart';
//import 'package:flutter_app_sports/data/models/user.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AuthRepository _authRepository = AuthRepository();
  final UserRepository _userRepository = UserRepository();
  HomeBloc() : super(HomeInitial()) {
    on<HomeNotificationButtonClickedEvent>(homeNotificationButtonClickedEvent);
    on<HomeReservationButtonClickedEvent>(homeReservationButtonClickedEvent);
    on<HomeManageMatchesButtonClickedEvent>(
        homeManageMatchesButtonClickedEvent);
    on<HomeQuickMatchButtonClickedEvent>(homeQuickMatchButtonClickedEvent);
    on<HomeNewMatchButtonClickedEvent>(homeNewMatchButtonClickedEvent);
    on<HomeProfileButtonClickedEvent>(homeProfileButtonClickedEvent);
    on<FetchSportsRecent>(fetchRecentSportsEvent);
    on<HomeLoadedSuccessEvent>(homeLoadedSuccessEvent);
    on<FetchSportsUserStorageRecent>(fetchSportsUserStorageRecentEvent);
    on<SaveSportsUserStorageRecent>(saveSportsUserStorageRecentEvent);
  }

  FutureOr<void> homeNotificationButtonClickedEvent(
      HomeNotificationButtonClickedEvent event, Emitter<HomeState> emit) {
    emit(HomeNavigateToNotificationState());
  }

  FutureOr<void> homeReservationButtonClickedEvent(
      HomeReservationButtonClickedEvent event, Emitter<HomeState> emit) {
    emit(HomeNavigateToReservationState());
  }

  FutureOr<void> homeManageMatchesButtonClickedEvent(
      HomeManageMatchesButtonClickedEvent event, Emitter<HomeState> emit) {
    emit(HomeNavigateToManageMatchesState());
  }

  FutureOr<void> homeQuickMatchButtonClickedEvent(
      HomeQuickMatchButtonClickedEvent event, Emitter<HomeState> emit) {
    emit(HomeNavigateToQuickMatchState());
  }

  FutureOr<void> homeNewMatchButtonClickedEvent(
      HomeNewMatchButtonClickedEvent event, Emitter<HomeState> emit) {
    emit(HomeNavigateToNewMatchState());
  }

  FutureOr<void> homeProfileButtonClickedEvent(
      HomeProfileButtonClickedEvent event, Emitter<HomeState> emit) {
    emit(HomeNavigateToProfileState());
  }

  FutureOr<void> fetchRecentSportsEvent(
      FetchSportsRecent event, Emitter<HomeState> emit) async {
          emit(SportsLoadingRecent());
      try {
        List<Sport> sports = await _authRepository.fetchSportsRecent(event.user);
        
        emit(RecentSportsLoaded(sports));
      } catch (e) {
        emit(FetchErrorState(e.toString().replaceAll("Exception: ", "")));
      }
  }

  FutureOr<void> homeLoadedSuccessEvent(
      HomeLoadedSuccessEvent event, Emitter<HomeState> emit) {
    emit(HomeLoadedSuccessState());
  }

  FutureOr<void> fetchSportsUserStorageRecentEvent(
      FetchSportsUserStorageRecent event, Emitter<HomeState> emit) async {
    emit(SportsLoadingRecent());
    try {
      List<Sport> sports = await _userRepository.fetchSportsUserStorageRecent();
      emit(RecentSportsLoaded(sports));
    } catch (e) {
      emit(FetchErrorState(e.toString().replaceAll("Exception: ", "")));
    }
  }

  FutureOr<void> saveSportsUserStorageRecentEvent(
      SaveSportsUserStorageRecent event, Emitter<HomeState> emit) async {
    try {
      await _userRepository.saveSportsUserStorageRecent(event.sports);
    } catch (e) {
      emit(FetchErrorState(e.toString().replaceAll("Exception: ", "")));
    }
  }
}
