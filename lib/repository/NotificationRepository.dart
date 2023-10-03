import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sportsapp/models/notification.dart';

class NotificationRepository {
  final String baseUrl;

  NotificationRepository({required this.baseUrl});

  Future<Notification> getNotification(String notificationId) async {
    final url = Uri.parse('$baseUrl/notifications/$notificationId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Notification.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load notification');
    }
  }

  // Aquí puedes añadir otros métodos para realizar operaciones CRUD adicionales.
}
