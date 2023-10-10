// global_state.dart
abstract class GlobalState {}

class NavigationStateButtons extends GlobalState {
  final int selectedIndex;

  NavigationStateButtons(this.selectedIndex);
}
