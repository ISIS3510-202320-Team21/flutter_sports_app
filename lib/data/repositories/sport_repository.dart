import 'dart:convert';
import 'package:flutter_app_sports/data/models/sport.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app_sports/data/services/config_service.dart';

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
