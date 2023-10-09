// global_state.dart
abstract class GlobalState {}

class NavigationState extends GlobalState {
  final int selectedIndex;

  NavigationState(this.selectedIndex);
}
