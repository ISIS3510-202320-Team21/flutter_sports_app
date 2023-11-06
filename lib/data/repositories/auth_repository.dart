import 'dart:convert';
import 'package:flutter_app_sports/data/models/sport.dart';
import 'package:flutter_app_sports/data/models/user.dart';
import 'package:http/http.dart' as http;
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
      Uri.parse('$backendUrl/users/'),
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
        'gender': gender
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
  }

  Future<List<String>> fetchRoles() async {
    final response = await http.get(
      Uri.parse('$backendUrl/roles/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> rolesList = jsonDecode(response.body);
      return rolesList.cast<String>();
    } else {
      throw Exception('Failed to fetch roles: ${response.statusCode}');
    }
  }

  Future<List<String>> fetchUniversities() async {
    final response = await http.get(
      Uri.parse('$backendUrl/universities/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> universitiesList = jsonDecode(response.body);
      return universitiesList.cast<String>();
    } else {
      throw Exception('Failed to fetch universities: ${response.statusCode}');
    }
  }

  Future<List<String>> fetchGenders() async {
    final response = await http.get(
      Uri.parse('$backendUrl/genders/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> gendersList = jsonDecode(response.body);
      return gendersList.cast<String>();
    } else {
      throw Exception('Failed to fetch genders: ${response.statusCode}');
    }
  }

  Future<List<Sport>> fetchSportsRecent(User user) async {
    int userId = user.id!;
    final response = await http.get(
      Uri.parse('$backendUrl/user/$userId/most_reserved_sports_this_week'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> sportsList = jsonDecode(response.body);
      return sportsList.map((e) => Sport.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch sports: ${response.statusCode}');
    }
  }
  
}
