class User {
  final String email;
  final String? university; 
  final String name;
  final String? phoneNumber; 
  final String? role;
  final DateTime? bornDate;
  final String? gender;
  final String? imageUrl; 
  final String? latitude; 
  final String? longitude; 

  User({
    required this.email,
    this.university, 
    required this.name,
    this.phoneNumber, 
    this.role,
    this.bornDate,
    this.gender,
    this.imageUrl, 
    this.latitude, 
    this.longitude, 
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final dateParts = json['bornDate'].split('/');
    final day = int.parse(dateParts[0]);
    final month = int.parse(dateParts[1]);
    final year = int.parse(dateParts[2]);
    final parsedDate = DateTime(year + 2000, month, day);

    return User(
      university: json['university'],
      email: json['email'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      role: json['role'],
      bornDate: parsedDate,
      gender: json['gender'],
      imageUrl: json["imageUrl"],
      latitude: json["latitude"],
      longitude: json["longitude"],
    );
  }
}
