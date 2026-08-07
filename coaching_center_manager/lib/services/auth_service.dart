import 'package:dio/dio.dart';
import '../models/user_model.dart';
import 'api_service.dart';
import 'local_storage_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();

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

      // Save session locally
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

  // ---------------- SIGNUP (Admin creates account) ----------------
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

  // ---------------- LOGOUT ----------------
  Future<void> logout() async {
    await LocalStorageService.clearSession();
  }

  // ---------------- ERROR HANDLER ----------------
  String _handleError(DioException e) {
    if (e.response != null && e.response?.data != null) {
      final data = e.response!.data;
      if (data is Map && data.containsKey('detail')) {
        return data['detail'].toString();
      }
    }
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return 'Connection timeout. Please check your internet.';
    }
    if (e.type == DioExceptionType.connectionError) {
      return 'Could not connect to server. Please check your network.';
    }
    return 'Login failed. Please check your credentials.';
  }
}
