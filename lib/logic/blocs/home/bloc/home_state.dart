part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

abstract class HomeActionState extends HomeState {}

class HomeInitial extends HomeState {}

class HomeLoadedSuccessState extends HomeActionState {}

class HomeLoadingState extends HomeState {}

class HomeErrorState extends HomeState {}

class HomeNavigateToNotificationState extends HomeActionState {}

class HomeNavigateToReservationState extends HomeActionState {}

class HomeNavigateToManageMatchesState extends HomeActionState {}

class HomeNavigateToQuickMatchState extends HomeActionState {}

class HomeNavigateToNewMatchState extends HomeActionState {}

class HomeNavigateToProfileState extends HomeActionState {}