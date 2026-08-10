import 'package:dio/dio.dart';
import 'local_storage_service.dart';

class ApiService {
  // Chrome/Web ke liye: 127.0.0.1
  // Android Emulator ke liye: 10.0.2.2
  // Real phone ke liye: apne laptop ka local IP (jaise 192.168.1.5)
  static const String baseUrl = "http://127.0.0.1:8000/api";

  late Dio dio;

  ApiService() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await LocalStorageService.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          return handler.next(e);
        },
      ),
    );
  }
}
