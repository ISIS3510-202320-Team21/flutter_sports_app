abstract class GlobalEvent {}

class NavigateToIndexEvent extends GlobalEvent {
  final int index;

  NavigateToIndexEvent(this.index);
}