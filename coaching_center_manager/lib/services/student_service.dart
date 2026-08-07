import 'package:dio/dio.dart';
import '../models/student_model.dart';
import 'api_service.dart';

class StudentService {
  final ApiService _apiService = ApiService();

  // ---------------- GET ALL STUDENTS ----------------
  Future<Map<String, dynamic>> getAllStudents() async {
    try {
      final response = await _apiService.dio.get('/students');

      final List data = response.data['students'] ?? response.data;
      final students = data.map((e) => StudentModel.fromJson(e)).toList();

      return {'success': true, 'students': students};
    } on DioException catch (e) {
      return {'success': false, 'message': _handleError(e)};
    } catch (e) {
      return {'success': false, 'message': 'Something went wrong.'};
    }
  }

  // ---------------- GET SINGLE STUDENT ----------------
  Future<Map<String, dynamic>> getStudentById(String id) async {
    try {
      final response = await _apiService.dio.get('/students/$id');
      final student = StudentModel.fromJson(response.data);
      return {'success': true, 'student': student};
    } on DioException catch (e) {
      return {'success': false, 'message': _handleError(e)};
    } catch (e) {
      return {'success': false, 'message': 'Something went wrong.'};
    }
  }

  // ---------------- ADD STUDENT ----------------
  Future<Map<String, dynamic>> addStudent(
    Map<String, dynamic> studentData,
  ) async {
    try {
      final response = await _apiService.dio.post(
        '/students',
        data: studentData,
      );
      return {'success': true, 'student': StudentModel.fromJson(response.data)};
    } on DioException catch (e) {
      return {'success': false, 'message': _handleError(e)};
    } catch (e) {
      return {'success': false, 'message': 'Something went wrong.'};
    }
  }

  // ---------------- UPDATE STUDENT ----------------
  Future<Map<String, dynamic>> updateStudent(
    String id,
    Map<String, dynamic> studentData,
  ) async {
    try {
      final response = await _apiService.dio.put(
        '/students/$id',
        data: studentData,
      );
      return {'success': true, 'student': StudentModel.fromJson(response.data)};
    } on DioException catch (e) {
      return {'success': false, 'message': _handleError(e)};
    } catch (e) {
      return {'success': false, 'message': 'Something went wrong.'};
    }
  }

  // ---------------- DELETE STUDENT ----------------
  Future<Map<String, dynamic>> deleteStudent(String id) async {
    try {
      await _apiService.dio.delete('/students/$id');
      return {'success': true};
    } on DioException catch (e) {
      return {'success': false, 'message': _handleError(e)};
    } catch (e) {
      return {'success': false, 'message': 'Something went wrong.'};
    }
  }

  // ---------------- SEARCH STUDENTS ----------------
  Future<Map<String, dynamic>> searchStudents(String query) async {
    try {
      final response = await _apiService.dio.get(
        '/students/search',
        queryParameters: {'q': query},
      );
      final List data = response.data['students'] ?? response.data;
      final students = data.map((e) => StudentModel.fromJson(e)).toList();
      return {'success': true, 'students': students};
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
