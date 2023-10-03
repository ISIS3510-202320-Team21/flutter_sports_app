import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sportsapp/models/user.dart';

class UserRepository {
  final String baseUrl;

  UserRepository({required this.baseUrl});

  Future<User> getUser(String userId) async {
    final url = Uri.parse('$baseUrl/users/$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw HttpException('Failed to load user: ${response.statusCode}');
    }
  }
}

class HttpException implements Exception {
  final String message;

  HttpException(this.message);

  @override
  String toString() => message;
}
