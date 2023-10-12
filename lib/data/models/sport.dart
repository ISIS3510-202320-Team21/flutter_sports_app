class Sport {
  final String name;
  final String image;

  Sport({required this.name , required this.image});

  factory Sport.fromJson(Map<String, dynamic> json) {
    return Sport(
      name: json['name'],
      image: json['imageUrl'],
    );
  }
}
