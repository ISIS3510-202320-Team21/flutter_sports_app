import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sportsapp/models/level.dart';

class LevelRepository {
  final String baseUrl;

  LevelRepository({required this.baseUrl});

  Future<Level> getLevel(String levelId) async {
    final url = Uri.parse('$baseUrl/levels/$levelId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Level.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load level');
    }
  }

  // Aquí puedes añadir otros métodos para realizar operaciones CRUD adicionales.
}
