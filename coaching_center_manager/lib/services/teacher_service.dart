import 'package:dio/dio.dart';
import '../models/teacher_model.dart';
import 'api_service.dart';

class TeacherService {
  final ApiService _apiService = ApiService();

  // ---------------- GET ALL TEACHERS ----------------
  Future<Map<String, dynamic>> getAllTeachers() async {
    try {
      final response = await _apiService.dio.get('/teachers');

      final List data = response.data['teachers'] ?? response.data;
      final teachers = data.map((e) => TeacherModel.fromJson(e)).toList();

      return {'success': true, 'teachers': teachers};
    } on DioException catch (e) {
      return {'success': false, 'message': _handleError(e)};
    } catch (e) {
      return {'success': false, 'message': 'Something went wrong.'};
    }
  }

  // ---------------- GET SINGLE TEACHER ----------------
  Future<Map<String, dynamic>> getTeacherById(String id) async {
    try {
      final response = await _apiService.dio.get('/teachers/$id');
      final teacher = TeacherModel.fromJson(response.data);
      return {'success': true, 'teacher': teacher};
    } on DioException catch (e) {
      return {'success': false, 'message': _handleError(e)};
    } catch (e) {
      return {'success': false, 'message': 'Something went wrong.'};
    }
  }

  // ---------------- ADD TEACHER ----------------
  Future<Map<String, dynamic>> addTeacher(
    Map<String, dynamic> teacherData,
  ) async {
    try {
      final response = await _apiService.dio.post(
        '/teachers',
        data: teacherData,
      );
      return {'success': true, 'teacher': TeacherModel.fromJson(response.data)};
    } on DioException catch (e) {
      return {'success': false, 'message': _handleError(e)};
    } catch (e) {
      return {'success': false, 'message': 'Something went wrong.'};
    }
  }

  // ---------------- UPDATE TEACHER ----------------
  Future<Map<String, dynamic>> updateTeacher(
    String id,
    Map<String, dynamic> teacherData,
  ) async {
    try {
      final response = await _apiService.dio.put(
        '/teachers/$id',
        data: teacherData,
      );
      return {'success': true, 'teacher': TeacherModel.fromJson(response.data)};
    } on DioException catch (e) {
      return {'success': false, 'message': _handleError(e)};
    } catch (e) {
      return {'success': false, 'message': 'Something went wrong.'};
    }
  }

  // ---------------- DELETE TEACHER ----------------
  Future<Map<String, dynamic>> deleteTeacher(String id) async {
    try {
      await _apiService.dio.delete('/teachers/$id');
      return {'success': true};
    } on DioException catch (e) {
      return {'success': false, 'message': _handleError(e)};
    } catch (e) {
      return {'success': false, 'message': 'Something went wrong.'};
    }
  }

  // ---------------- SEARCH TEACHERS ----------------
  Future<Map<String, dynamic>> searchTeachers(String query) async {
    try {
      final response = await _apiService.dio.get(
        '/teachers/search',
        queryParameters: {'q': query},
      );
      final List data = response.data['teachers'] ?? response.data;
      final teachers = data.map((e) => TeacherModel.fromJson(e)).toList();
      return {'success': true, 'teachers': teachers};
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
}
