class Sport {
  final String name;
  final String? image;
  final int id;

  Sport({required this.name , required this.image, required this.id});

  factory Sport.fromJson(Map<String, dynamic> json) {
    return Sport(
      name: json['name'],
      image: json['imageUrl'],
      id: json['id'],
    );
  }
}
