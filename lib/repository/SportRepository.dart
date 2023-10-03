import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sportsapp/models/sport.dart';

class SportRepository {
  final String baseUrl;

  SportRepository({required this.baseUrl});

  Future<Sport> getSport(String sportId) async {
    final url = Uri.parse('$baseUrl/sports/$sportId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Sport.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load sport');
    }
  }

  // Aquí puedes añadir otros métodos para realizar operaciones CRUD adicionales.
}
