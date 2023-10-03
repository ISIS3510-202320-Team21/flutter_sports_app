class Sport {
  final String name;

  Sport({required this.name});

  factory Sport.fromJson(Map<String, dynamic> json) {
    return Sport(
      name: json['name'],
    );
  }
}
