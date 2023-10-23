part of 'home_bloc.dart';

@immutable 
abstract class HomeEvent{}

class HomeNotificationButtonClickedEvent extends HomeEvent{
  
}

class HomeReservationButtonClickedEvent extends HomeEvent{
  
}

class HomeManageMatchesButtonClickedEvent extends HomeEvent{
  
}

class HomeQuickMatchButtonClickedEvent extends HomeEvent{
  
}

class HomeNewMatchButtonClickedEvent extends HomeEvent{
  
}

class HomeProfileButtonClickedEvent extends HomeEvent{
  
}

class FetchSportsRecent extends HomeEvent{
  final User user;
  FetchSportsRecent(this.user);
}

class HomeLoadedSuccessEvent extends HomeEvent{
}

