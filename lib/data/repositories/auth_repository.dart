import 'dart:convert';
import 'package:flutter_app_sports/data/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_app_sports/data/services/config_service.dart';

class AuthRepository {
  final String? backendUrl = ConfigService.backendUrl;

  Future<User?> signUp({
    required String email,
    required String password,
    required String name,
    required String phoneNumber,
    required String role,
    required String university,
    required String bornDate,
    required String gender,
  }) async {
    final response = await http.post(
      Uri.parse('$backendUrl/users'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
        'name': name,
        'phoneNumber': phoneNumber,
        'role': role,
        'university': university,
        'bornDate': bornDate,
        'gender': gender,
      }),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to sign up: ${response.statusCode}');
    }
  }

  Future<User?> signIn(
      {required String email, required String password}) async {
    final response = await http.post(
      Uri.parse('$backendUrl/login/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to sign in: ${response.statusCode}');
    }
  }

  Future<void> signOut() async {
    // TODO: Implementa la lógica para cerrar sesión si es necesario.
  }
}
