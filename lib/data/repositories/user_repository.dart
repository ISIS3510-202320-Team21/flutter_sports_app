import 'dart:convert';
import 'package:flutter_app_sports/data/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app_sports/data/services/config_service.dart';

class UserRepository {
  final String? backendUrl = ConfigService.backendUrl;

  Future<User?> changeInfo({
    required String email,
    required String name,
    required String phoneNumber,
    required String role,
    required String university,
    required String bornDate,
    required String gender,
    required int userid
  }) async {

    final response = await http.put(
      Uri.parse('$backendUrl/users/$userid/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'email': email,
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
      throw Exception('Failed to change info of user: ${response.statusCode}');
    }
  }

  Future<User?> changePassword(
      {required String oldPassword, required String newPassword, required int userid}) async {
    final response = await http.put(
      Uri.parse('$backendUrl/users/$userid/password/?=oldPassword$oldPassword&newPassword=$newPassword'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      }
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to change password: ${response.statusCode}');
    }
  }

  //update image for user
  Future<User?> changeImage(
      {required String image, required int userid}) async {
    final response = await http.post(
      Uri.parse('$backendUrl/users/$userid/image/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'imageUrl': image}),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to change image: ${response.statusCode}');
    }
  }

  Future<User?> getInfoUser({required int userid}) async {
    final response = await http.get(
      Uri.parse('$backendUrl/users/$userid'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      }
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to get info of user: ${response.statusCode}');
    }
  }

  Future<List<String>> getRoles() async {
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

  Future<List<String>> getUniversities() async {
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

  Future<List<String>> getGenders() async {
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
}
