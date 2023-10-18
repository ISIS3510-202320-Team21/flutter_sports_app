import 'dart:convert';
import 'package:flutter_app_sports/data/models/level.dart';
import 'package:flutter_app_sports/data/models/match.dart';
import 'package:flutter_app_sports/data/repositories/user_repository.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app_sports/data/services/config_service.dart';

class MatchRepository {
  final String? backendUrl = ConfigService.backendUrl;
  final UserRepository userRepository;

  MatchRepository({required this.userRepository});

  Future<List<Match>?> getMatchesForUser({required int userid}) async {
    print("userid");
    print(userid);
    final response = await http.get(
      Uri.parse('$backendUrl/users/$userid/matches/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      List<Match> matches = [];
      for (var item in jsonData) {
        matches.add(await Match.createFromJson(item, userRepository));
      }
      return matches;
    } else {
      throw Exception('Failed to get matches: ${response.statusCode}');
    }
  }

  Future<List<Match>?> getMatchesForSport(
      {required int sportId, required DateTime? date}) async {
    final response = await http.get(
      Uri.parse('$backendUrl/sports/$sportId/matches/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      List<Match> matches = [];

      for (var item in jsonData) {
        Match matchItem = await Match.createFromJson(item, userRepository);
        if (date == null ||
            (matchItem.date?.day == date.day &&
                matchItem.date?.month == date.month &&
                matchItem.date?.year == date.year)) {
          matches.add(matchItem);
        }
      }

      return matches;
    } else {
      throw Exception(
          'Failed to get matches for sport: ${response.statusCode}');
    }
  }

  Future<Match?> createMatch(Match match,int UserId) async {
    print("userid");
    print(UserId);
    final response = await http.post(
      Uri.parse('$backendUrl/users/$UserId/matches/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(match.toJson()),
    );
    
    if (response.statusCode == 200) {
      return Match.createFromJson(jsonDecode(response.body), userRepository);
    } else {
      throw Exception('Failed to create match: ${response.statusCode}');
    }
  }

  Future<List<Level>?> getLevels() async {
    final response = await http.get(
      Uri.parse('$backendUrl/levels/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      List<Level> levels = [];

      for (var item in jsonData) {
        Level levelData = await Level.fromJson(item);
        levels.add(levelData);
      }
      
      return levels;
    } else {
      throw Exception('Failed to get levels for sport: ${response.statusCode}');
    }
  }
}
