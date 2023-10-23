part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

abstract class HomeActionState extends HomeState {}

class HomeInitial extends HomeState {}

class HomeLoadedSuccessState extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeErrorState extends HomeState {}

class HomeNavigateToNotificationState extends HomeActionState {}

class HomeNavigateToReservationState extends HomeActionState {}

class HomeNavigateToManageMatchesState extends HomeActionState {}

class HomeNavigateToQuickMatchState extends HomeActionState {}

class HomeNavigateToNewMatchState extends HomeActionState {}

class HomeNavigateToProfileState extends HomeActionState {}

class RecentSportsLoaded extends HomeActionState {
  final List<Sport> sports;

  RecentSportsLoaded(this.sports);

  @override
  List<Object?> get props => [sports];
}

class SportsLoadingRecent extends HomeState {}

class FetchErrorState extends HomeActionState {
  final String error;

  FetchErrorState(this.error);

  @override
  List<Object?> get props => [error];
}
