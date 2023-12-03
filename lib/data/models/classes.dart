class SportMatchCount {
  final String name;
  final String imageUrl;
  final int matchCount;

  SportMatchCount({required this.name, required this.imageUrl, required this.matchCount});

  factory SportMatchCount.fromJson(Map<String, dynamic> json) {
    return SportMatchCount(
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      matchCount: json['match_count'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'matchCount': matchCount,
    };
  }
}
