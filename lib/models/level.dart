class Level {
  final String name;

  Level({required this.name});

  factory Level.fromJson(Map<String, dynamic> json) {
    return Level(
      name: json['name'],
    );
  }
}
