import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../services/notification_service.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationService _service = NotificationService();

  List<dynamic> _notifications = [];
  bool _isLoading = false;
  WebSocketChannel? _channel;

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

    // WebSocket connect karo real-time updates ke liye
    _connectWebSocket(role);
  }

  void _connectWebSocket(String role) {
    // Purani connection band karo agar hai
    _channel?.sink.close();

    try {
      // Chrome/Web ke liye 127.0.0.1, Android emulator ke liye 10.0.2.2 use karo
      _channel = WebSocketChannel.connect(
        Uri.parse('ws://127.0.0.1:8000/api/notifications/ws/$role'),
      );

      _channel!.stream.listen(
        (message) {
          final data = jsonDecode(message);
          // Nayi notification list ke sabse upar add karo
          _notifications.insert(0, data);
          notifyListeners();
        },
        onError: (error) {
          debugPrint('WebSocket error: $error');
        },
        onDone: () {
          debugPrint('WebSocket connection closed');
        },
      );
    } catch (e) {
      debugPrint('WebSocket connection failed: $e');
    }
  }

  Future<void> markAllRead(String role) async {
    await _service.markAllRead(role);
    for (var n in _notifications) {
      n['is_read'] = true;
    }
    notifyListeners();
  }

  void disconnectWebSocket() {
    _channel?.sink.close();
  }

  @override
  void dispose() {
    _channel?.sink.close();
    super.dispose();
  }
}
