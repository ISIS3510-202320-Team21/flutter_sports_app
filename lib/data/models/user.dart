class User {
  final String email;
  final String university;
  final String name;
  final String phoneNumber;
  final String role;
  final DateTime bornDate;
  final String gender;
  final String imageUrl;

  User(
      {required this.university,
      required this.email,
      required this.name,
      required this.phoneNumber,
      required this.role,
      required this.bornDate,
      required this.gender,
      required this.imageUrl});

  factory User.fromJson(Map<String, dynamic> json) {
    final dateParts = json['bornDate'].split('/');
    final day = int.parse(dateParts[0]);
    final month = int.parse(dateParts[1]);
    final year = int.parse(dateParts[2]);
    final parsedDate = DateTime(year + 2000, month, day);

    if (json['imageUrl'] == null) {
      json['imageUrl'] = "";
    }

    final user = User(
      university: json['university'],
      email: json['email'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      role: json['role'],
      bornDate: parsedDate,
      gender: json['gender'],
      imageUrl: json["imageUrl"],
    );

    return user;
  }
}
