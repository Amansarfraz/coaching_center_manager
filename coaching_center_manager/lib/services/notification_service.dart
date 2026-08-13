import 'package:dio/dio.dart';
import 'api_service.dart';

class NotificationService {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> getNotifications(String role) async {
    try {
      final response = await _apiService.dio.get(
        '/notifications',
        queryParameters: {'role': role},
      );
      return {'success': true, 'notifications': response.data['notifications']};
    } on DioException catch (e) {
      return {
        'success': false,
        'message': e.message ?? 'Failed to load notifications',
      };
    }
  }

  Future<void> markAllRead(String role) async {
    try {
      await _apiService.dio.put(
        '/notifications/mark-all-read',
        queryParameters: {'role': role},
      );
    } catch (_) {}
  }
}
