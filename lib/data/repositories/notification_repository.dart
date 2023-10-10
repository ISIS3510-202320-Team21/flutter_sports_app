import 'dart:convert';
import 'package:flutter_app_sports/data/models/notification.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app_sports/data/services/config_service.dart';

class NotificationRepository {
  final String? backendUrl = ConfigService.backendUrl;

  //create future to get matches of one user
  Future<List<Notification>?> getNotifications({required int userid}) async {
    final response = await http.get(
      Uri.parse('$backendUrl/users/$userid/notifications/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      //return list of notifications
      return (jsonDecode(response.body) as List)
          .map((e) => Notification.fromJson(e))
          .toList();
    } else {
      throw Exception('Failed to get matches: ${response.statusCode}');
    }
  }
}