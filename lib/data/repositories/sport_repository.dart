import 'dart:convert';
import 'package:flutter_app_sports/data/models/sport.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app_sports/data/services/config_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SportRepository {
  final String? backendUrl = ConfigService.backendUrl;

  Future<List<Sport>?> fetchSports() async {
    // Agrega un retraso de 5 segundos

    final response = await http.get(
      Uri.parse('$backendUrl/sports/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((e) => Sport.fromJson(e))
          .toList();
    } else {
      throw Exception('Failed to fetch sports: ${response.statusCode}');
    }
  }

  Future<void> saveSports(List<Sport> sports) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String sportsJson =
        jsonEncode(sports.map((sport) => sport.toJson()).toList());
    await prefs.setString('sports_matches', sportsJson);
  }

  Future<List<Sport>?> fetchSportsStorage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sportsJson = prefs.getString('sports_matches');
    if (sportsJson == null) {
      return [];
    }
    List<dynamic> sportsList = jsonDecode(sportsJson) as List;
    return sportsList.map((json) => Sport.fromJson(json)).toList();
  }

  Future<Sport?> getSport({required int sportId}) async {
    final response = await http.get(
      Uri.parse('$backendUrl/sports/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return Sport.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get sport: ${response.statusCode}');
    }
  }
}
