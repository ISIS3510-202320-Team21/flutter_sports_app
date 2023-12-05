import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_app_sports/data/services/config_service.dart';

class ClaimsRepository {
  final String? backendUrl = ConfigService.backendUrl;

  Future<void> submitClaim({
    required int userId,
    required String claimContent,
  }) async {
    final response = await http.post(
      Uri.parse('$backendUrl/claims/'), 
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'user_created_id': userId,
        'content': claimContent,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Claim enviado con éxito.
      print("RESPUESTA ENVIADA CON EXITOOOOO!");
      print("El usuario es:");
      print(userId);
    } else {
      throw Exception('Failed to submit claim: ${response.statusCode}');
    }
  }
}
