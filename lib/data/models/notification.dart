class Notification {
  final String name;
  final String type;
  final String redirectTo;
  final bool seen;
  final DateTime creationDate;

  Notification(
      {required this.name, required this.type, required this.redirectTo, required this.seen, required this.creationDate});

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      name: json['name'],
      type: json['type'],
      redirectTo: json['redirectTo'],
      seen: json['seen'],
      creationDate: DateTime.parse(json['creationDate'])
    );
  }
}