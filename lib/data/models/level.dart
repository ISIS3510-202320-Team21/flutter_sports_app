class Level {
  final String name;
  int? id;

  Level({required this.name, this.id});
  factory Level.fromJson(Map<String, dynamic> json) {
    return Level(
      name: json['name'],
      id: json['id'],
    );
  }
}
