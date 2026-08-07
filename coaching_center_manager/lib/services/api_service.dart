import 'package:dio/dio.dart';
import 'local_storage_service.dart';

class ApiService {
  // Android Emulator ke liye localhost = 10.0.2.2
  // Real phone pe test karne ke liye apne laptop ka local IP daalna (jaise http://192.168.1.5:8000)
  static const String baseUrl = "http://10.0.2.2:8000/api";

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
          // Yahan future mein global error handling / logout on 401 add karenge
          return handler.next(e);
        },
      ),
    );
  }
}
