import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sportsapp/data/models/user.dart';

class AuthRepository {
  Future<User?> signUp(
      {required String email, required String password}) async {
    final backendUrl = dotenv.env[
        'BACKEND_URL']; // Obtén la URL del backend desde las variables de entorno
    print(backendUrl);
    final response = await http.post(
      Uri.parse('$backendUrl/api/signup'), // Utiliza la URL del backend
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
    final backendUrl = dotenv.env[
        'BACKEND_URL']; // Obtén la URL del backend desde las variables de entorno
    final response = await http.post(
      Uri.parse('$backendUrl/api/signin'), // Utiliza la URL del backend
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
    final backendUrl = dotenv.env[
        'BACKEND_URL']; // Obtén la URL del backend desde las variables de entorno
    final response = await http.get(
      Uri.parse('$backendUrl/api/users/$email'), // Utiliza la URL del backend
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
    try {
      // Implementa la lógica para cerrar sesión si es necesario
    } catch (e) {
      throw Exception(e);
    }
  }
}
