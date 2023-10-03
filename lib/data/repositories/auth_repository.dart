import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sportsapp/data/models/user.dart';

class AuthRepository {
  Future<User?> signUp(
      {required String email, required String password}) async {
    final response = await http.post(
      Uri.parse('https://example.com/api/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final user = User.fromJson(jsonDecode(response.body));
      return user;
    } else {
      throw Exception('Failed to sign up: ${response.statusCode}');
    }
  }

  Future<User?> signIn(
      {required String email, required String password}) async {
    final response = await http.post(
      Uri.parse('https://example.com/api/signin'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final user = User.fromJson(jsonDecode(response.body));
      return user;
    } else {
      throw Exception('Failed to sign in: ${response.statusCode}');
    }
  }

  Future<User?> findUserByEmail(String email) async {
    final response = await http.get(
      Uri.parse('https://example.com/api/users/$email'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final user = User.fromJson(jsonDecode(response.body));
      return user;
    } else {
      throw Exception('Failed to find user: ${response.statusCode}');
    }
  }

  Future<void> signOut() async {
    try {} catch (e) {
      throw Exception(e);
    }
  }
}
