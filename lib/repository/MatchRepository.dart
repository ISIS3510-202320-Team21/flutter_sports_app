import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sportsapp/models/match.dart';

class MatchRepository {
  final String baseUrl;

  MatchRepository({required this.baseUrl});

  Future<Match> getMatch(String matchId) async {
    final url = Uri.parse('$baseUrl/matches/$matchId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Match.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load match');
    }
  }

  // Aquí puedes añadir otros métodos para realizar operaciones CRUD adicionales.
}
