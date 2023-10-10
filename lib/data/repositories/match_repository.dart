import 'dart:convert';
import 'package:flutter_app_sports/data/models/match.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app_sports/data/services/config_service.dart';
class MatchRepository {
  final String? backendUrl = ConfigService.backendUrl;

  //create future to get matches of one user
  Future<List<Match>?> getMatches({required int userid}) async {
    final response = await http.get(
      Uri.parse('$backendUrl/users/$userid/matches/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      //return list of matches
      return (jsonDecode(response.body) as List)
          .map((e) => Match.fromJson(e))
          .toList();
    } else {
      throw Exception('Failed to get matches: ${response.statusCode}');
    }
  }
}