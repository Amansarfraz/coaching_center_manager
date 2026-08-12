import 'package:dio/dio.dart';
import '../models/attendance_model.dart';
import 'api_service.dart';

class AttendanceService {
  final ApiService _apiService = ApiService();

  // ---------------- MARK ATTENDANCE (bulk for a batch on a date) ----------------
  Future<Map<String, dynamic>> markAttendance({
    required String batchId,
    required DateTime date,
    required List<Map<String, dynamic>> attendanceList,
    // attendanceList example: [{ 'student_id': 'xxx', 'status': 'present' }, ...]
  }) async {
    try {
      final response = await _apiService.dio.post(
        '/attendance/mark',
        data: {
          'batch_id': batchId,
          'date': date.toIso8601String(),
          'attendance': attendanceList,
        },
      );
      return {
        'success': true,
        'message': response.data['message'] ?? 'Attendance marked',
      };
    } on DioException catch (e) {
      return {'success': false, 'message': _handleError(e)};
    } catch (e) {
      return {'success': false, 'message': 'Something went wrong.'};
    }
  }

  // ---------------- GET ATTENDANCE BY BATCH & DATE ----------------
  Future<Map<String, dynamic>> getAttendanceByDate({
    required String batchId,
    required DateTime date,
  }) async {
    try {
      final response = await _apiService.dio.get(
        '/attendance',
        queryParameters: {'batch_id': batchId, 'date': date.toIso8601String()},
      );
      final List data = response.data['attendance'] ?? response.data;
      final records = data.map((e) => AttendanceModel.fromJson(e)).toList();
      return {'success': true, 'records': records};
    } on DioException catch (e) {
      return {'success': false, 'message': _handleError(e)};
    } catch (e) {
      return {'success': false, 'message': 'Something went wrong.'};
    }
  }

  // ---------------- GET ATTENDANCE HISTORY FOR A STUDENT ----------------
  Future<Map<String, dynamic>> getStudentAttendanceHistory(
    String studentId,
  ) async {
    try {
      final response = await _apiService.dio.get(
        '/attendance/student/$studentId',
      );
      final List data = response.data['attendance'] ?? response.data;
      final records = data.map((e) => AttendanceModel.fromJson(e)).toList();
      return {'success': true, 'records': records};
    } on DioException catch (e) {
      return {'success': false, 'message': _handleError(e)};
    } catch (e) {
      return {'success': false, 'message': 'Something went wrong.'};
    }
  }

  // ---------------- GET ATTENDANCE STATS (for dashboard chart) ----------------
  Future<Map<String, dynamic>> getAttendanceStats({
    required String batchId,
    required DateTime date,
  }) async {
    try {
      final response = await _apiService.dio.get(
        '/attendance/stats',
        queryParameters: {'batch_id': batchId, 'date': date.toIso8601String()},
      );
      return {'success': true, 'stats': response.data};
    } on DioException catch (e) {
      return {'success': false, 'message': _handleError(e)};
    } catch (e) {
      return {'success': false, 'message': 'Something went wrong.'};
    }
  }

  // ---------------- ERROR HANDLER ----------------
  String _handleError(DioException e) {
    if (e.response != null && e.response?.data != null) {
      final data = e.response!.data;
      if (data is Map && data.containsKey('detail')) {
        return data['detail'].toString();
      }
    }
    if (e.type == DioExceptionType.connectionError) {
      return 'Could not connect to server. Please check your network.';
    }
    return 'Request failed. Please try again.';
  }

  Future<Map<String, dynamic>> getBatchSummary(String batchId) async {
    try {
      final response = await _apiService.dio.get(
        '/attendance/batch-summary/$batchId',
      );
      return {'success': true, 'summary': response.data};
    } on DioException catch (e) {
      return {'success': false, 'message': _handleError(e)};
    } catch (e) {
      return {'success': false, 'message': 'Something went wrong.'};
    }
  }
}
