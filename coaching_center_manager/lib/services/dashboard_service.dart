import 'package:dio/dio.dart';
import 'api_service.dart';

class DashboardService {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> getDashboardSummary() async {
    try {
      final response = await _apiService.dio.get('/dashboard/summary');
      return {'success': true, 'data': response.data};
    } on DioException catch (e) {
      return {
        'success': false,
        'message': e.message ?? 'Failed to load dashboard',
      };
    } catch (e) {
      return {'success': false, 'message': 'Something went wrong.'};
    }
  }
}
