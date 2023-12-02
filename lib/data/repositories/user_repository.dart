import 'dart:convert';
import 'package:flutter_app_sports/data/models/classes.dart';
import 'package:flutter_app_sports/data/models/sport.dart';
import 'package:flutter_app_sports/data/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app_sports/data/services/config_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  final String? backendUrl = ConfigService.backendUrl;

  Future<User?> changeInfo(
      {required String email,
      required String name,
      required String phoneNumber,
      required String role,
      required String university,
      required String bornDate,
      required String gender,
      required int userid}) async {
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
      {required String oldPassword,
      required String newPassword,
      required int userid}) async {
    final response = await http.put(
        Uri.parse(
            '$backendUrl/users/$userid/password/?=oldPassword$oldPassword&newPassword=$newPassword'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });

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
    final response = await http
        .get(Uri.parse('$backendUrl/users/$userid'), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });

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

  Future<List<Sport>> fetchSportsUserStorageRecent() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sportsJson = prefs.getString('sports');
    if (sportsJson == null) {
      return [];
    }
    List<dynamic> sportsList = jsonDecode(sportsJson) as List;
    return sportsList.map((json) => Sport.fromJson(json)).toList();
  }

  Future<void> saveSportsUserStorageRecent(List<Sport> sports) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String sportsJson =
        jsonEncode(sports.map((sport) => sport.toJson()).toList());
    await prefs.setString('sports', sportsJson);
  }

  Future<List<SportMatchCount>> getUserMatchesCountBySport({
    required int userId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final response = await http.get(
      Uri.parse('$backendUrl/users/$userId/matches/count-by-sport')
          .replace(queryParameters: {
        'start_date': startDate.toIso8601String(),
        'end_date': endDate.toIso8601String(),
      }),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      // Convertimos la respuesta JSON en una lista de objetos SportMatchCount
      List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData
          .map<SportMatchCount>((json) => SportMatchCount.fromJson(json))
          .toList();
    } else {
      throw Exception(
          'Failed to fetch user matches count by sport: ${response.statusCode}');
    }
  }
}
