import 'dart:convert';
import 'package:flutter_app_sports/data/models/notification.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app_sports/data/services/config_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      List<dynamic> jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      List<Notification> notifications = [];
      for (var item in jsonData) {
        notifications.add(Notification.fromJson(item));
      }
      notifications.sort((a, b) => b.creationDate.compareTo(a.creationDate));
      return notifications;
    } else {
      throw Exception('Failed to get matches: ${response.statusCode}');
    }
  }

  Future<List<Notification>> getNotificationsStorageRecent() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? matchesJson = prefs.getString('notifications');
    if (matchesJson == null) {
      return [];
    }
    List<dynamic> notificationsList = jsonDecode(matchesJson) as List;
    return notificationsList.map((json) => Notification.fromJson(json)).toList();
  }

  Future<void> saveNotificationsStorageRecent(List<Notification> notifications) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String notificationsJson = jsonEncode(notifications.map((notification) => notification.toJson()).toList());
    await prefs.setString('notifications', notificationsJson);
  }

  Future<Notification> updateNotification(int notificationId) async {
    final response = await http.put(
      Uri.parse('$backendUrl/notifications/$notificationId/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return Notification.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to change status of notification: ${response.statusCode}');
    }
  }
}