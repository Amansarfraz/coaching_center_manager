import 'package:flutter/material.dart';
import '../services/notification_service.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationService _service = NotificationService();

  List<dynamic> _notifications = [];
  bool _isLoading = false;

  List<dynamic> get notifications => _notifications;
  bool get isLoading => _isLoading;
  int get unreadCount =>
      _notifications.where((n) => n['is_read'] == false).length;

  Future<void> fetchNotifications(String role) async {
    _isLoading = true;
    notifyListeners();

    final result = await _service.getNotifications(role);

    _isLoading = false;
    if (result['success'] == true) {
      _notifications = result['notifications'];
    }
    notifyListeners();
  }

  Future<void> markAllRead(String role) async {
    await _service.markAllRead(role);
    for (var n in _notifications) {
      n['is_read'] = true;
    }
    notifyListeners();
  }
}
