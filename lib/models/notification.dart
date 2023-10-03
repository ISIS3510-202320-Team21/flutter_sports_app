class Notification {
  final String name;
  final String type;
  final String redirectTo;

  Notification(
      {required this.name, required this.type, required this.redirectTo});

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      name: json['name'],
      type: json['type'],
      redirectTo: json['redirectTo'],
    );
  }
}
