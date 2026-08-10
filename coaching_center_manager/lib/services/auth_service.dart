import 'package:dio/dio.dart';
import '../models/user_model.dart';
import 'api_service.dart';
import 'local_storage_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();

  // ---------------- SIGNUP ----------------
  Future<Map<String, dynamic>> signup({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String role,
  }) async {
    try {
      final response = await _apiService.dio.post(
        '/auth/signup',
        data: {
          'full_name': fullName,
          'email': email,
          'phone': phone,
          'password': password,
          'role': role,
        },
      );

      return {
        'success': true,
        'message': response.data['message'] ?? 'Account created successfully',
      };
    } on DioException catch (e) {
      return {'success': false, 'message': _handleError(e)};
    } catch (e) {
      return {
        'success': false,
        'message': 'Something went wrong. Please try again.',
      };
    }
  }

  // ---------------- LOGIN ----------------
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      final data = response.data;
      final token = data['access_token'];
      final userJson = data['user'];

      final user = UserModel.fromJson(userJson);

      // Session locally save karo
      await LocalStorageService.saveToken(token);
      await LocalStorageService.saveUserSession(
        userId: user.id,
        userName: user.fullName,
        role: user.role,
      );

      return {'success': true, 'user': user};
    } on DioException catch (e) {
      return {'success': false, 'message': _handleError(e)};
    } catch (e) {
      return {
        'success': false,
        'message': 'Something went wrong. Please try again.',
      };
    }
  }

  // ---------------- LOGOUT ----------------
  Future<void> logout() async {
    await LocalStorageService.clearSession();
  }

  // ---------------- ERROR HANDLER ----------------
  String _handleError(DioException e) {
    // Backend se aaya specific error message
    if (e.response != null && e.response?.data != null) {
      final data = e.response!.data;
      if (data is Map && data.containsKey('detail')) {
        final detail = data['detail'];
        if (detail is String) return detail;
        if (detail is List && detail.isNotEmpty) {
          // FastAPI validation errors (422) list format mein aate hain
          final firstError = detail[0];
          if (firstError is Map && firstError.containsKey('msg')) {
            return firstError['msg'].toString();
          }
        }
      }
    }

    // Network-level errors
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return 'Connection timeout. Please check if the server is running.';
    }
    if (e.type == DioExceptionType.connectionError) {
      return 'Could not connect to server. Please check your network or server status.';
    }

    return 'Something went wrong. Please try again.';
  }
}
