class Level {
  final String name;
  final int id;

  Level({required this.name,
    required this.id});

  factory Level.fromJson(Map<String, dynamic> json) {
    return Level(
      name: json['name'],
      id: json['id'],
    );
  }
}
