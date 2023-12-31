import 'dart:convert';
import 'package:flutter_app_sports/data/models/level.dart';
import 'package:flutter_app_sports/data/models/match.dart';
import 'package:flutter_app_sports/data/models/user.dart';
import 'package:flutter_app_sports/data/repositories/user_repository.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app_sports/data/services/config_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MatchRepository {
  final String? backendUrl = ConfigService.backendUrl;
  final UserRepository userRepository;

  MatchRepository({required this.userRepository});

  Future<List<Match>?> getMatchesForUser({required int userid}) async {
    final response = await http.get(
      Uri.parse('$backendUrl/users/$userid/matches/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      List<Match> matches = [];
      for (var item in jsonData) {
        matches.add(await Match.createFromJson(item, userRepository));
      }
      return matches;
    } else {
      throw Exception('Failed to get matches: ${response.statusCode}');
    }
  }

  Future<List<Match>> getMatchesForUserStorageRecent() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? matchesJson = prefs.getString('matches');
    if (matchesJson == null) {
      return [];
    }
    List<dynamic> matchesList = jsonDecode(matchesJson) as List;
    return matchesList.map((json) => Match.fromJson(json)).toList();
  }

  Future<void> saveMatchesForUserStorageRecent(List<Match> matches) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String matchesJson = jsonEncode(matches.map((match) => match.toJson()).toList());
    await prefs.setString('matches', matchesJson);
  }

  Future<Match?> changeStatusMatch(int matchId, String status) async {
    final response = await http.put(
      Uri.parse('$backendUrl/matches/$matchId/status?status=$status'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return Match.createFromJson(
          jsonDecode(utf8.decode(response.bodyBytes)), userRepository);
    } else {
      throw Exception('Failed to change status match: ${response.statusCode}');
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
      List<dynamic> jsonData = jsonDecode(utf8.decode(response.bodyBytes));
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

  Future<Match?> createMatch(Match match, int UserId) async {
    final response = await http.post(
      Uri.parse('$backendUrl/users/$UserId/matches/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(match.toJson()),
    );
    if (response.statusCode == 200) {
      return Match.createFromJson(
          jsonDecode(utf8.decode(response.bodyBytes)), userRepository);
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
      List<dynamic> jsonData = jsonDecode(utf8.decode(response.bodyBytes));
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

  Future<Match?> addUserToMatch(int userId, int matchId) async {
    final response = await http.put(
      Uri.parse('$backendUrl/matches/$matchId/users/$userId/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      changeStatusMatch(matchId, "Approved");
      return Match.createFromJson(
          jsonDecode(utf8.decode(response.bodyBytes)), userRepository);
    } else {
      throw Exception('Failed to add user to match: ${response.statusCode}');
    }
  }

  Future<void> rateMatch(User user, Match match, double rating) async {
    bool isUserCreated = user.id == match.userCreated?.id;
    final response = await http.put(
      Uri.parse('$backendUrl/matches/${match.id}/rate?rate=$rating&is_user_created=$isUserCreated'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to rate match: ${response.statusCode}');
    }
  }

  Future<Match?> getMatch({required int matchId}) async {
    final response = await http.get(
      Uri.parse('$backendUrl/matches/$matchId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {

      return Match.createFromJson(
          jsonDecode(utf8.decode(response.bodyBytes)), userRepository);
    } else {
      throw Exception('Failed to get match: ${response.statusCode}');
    }
  }

  Future<int> deleteMatch(int matchId) async {
    final response = await http.put(
      Uri.parse('$backendUrl/matches/$matchId/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return matchId;
    } else {
      throw Exception('Failed to delete match: ${response.statusCode}');
    }
  }

    Future<List<String>> fetchCities() async {
    final response = await http.get(
      Uri.parse('$backendUrl/cities/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> citiesList = jsonDecode(utf8.decode(response.bodyBytes)); 
      return citiesList.cast<String>();
    } else {
      throw Exception('Failed to fetch cities: ${response.statusCode}');
    }
  }

  Future<List<String>> fetchCourts() async {
    final response = await http.get(
      Uri.parse('$backendUrl/courts/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> courtsList = jsonDecode(utf8.decode(response.bodyBytes));
      return courtsList.cast<String>();
    } else {
      throw Exception('Failed to fetch courts: ${response.statusCode}');
    }
  }
}
