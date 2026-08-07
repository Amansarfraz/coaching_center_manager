import 'package:dio/dio.dart';
import '../models/fee_model.dart';
import 'api_service.dart';

class FeeService {
  final ApiService _apiService = ApiService();

  // ---------------- GET ALL FEE RECORDS (with optional month filter) ----------------
  Future<Map<String, dynamic>> getAllFeeRecords({String? month}) async {
    try {
      final response = await _apiService.dio.get(
        '/fees',
        queryParameters: month != null ? {'month': month} : null,
      );

      final List data = response.data['fees'] ?? response.data;
      final fees = data.map((e) => FeeModel.fromJson(e)).toList();

      return {'success': true, 'fees': fees};
    } on DioException catch (e) {
      return {'success': false, 'message': _handleError(e)};
    } catch (e) {
      return {'success': false, 'message': 'Something went wrong.'};
    }
  }

  // ---------------- GET FEE RECORDS FOR A STUDENT ----------------
  Future<Map<String, dynamic>> getStudentFeeRecords(String studentId) async {
    try {
      final response = await _apiService.dio.get('/fees/student/$studentId');
      final List data = response.data['fees'] ?? response.data;
      final fees = data.map((e) => FeeModel.fromJson(e)).toList();
      return {'success': true, 'fees': fees};
    } on DioException catch (e) {
      return {'success': false, 'message': _handleError(e)};
    } catch (e) {
      return {'success': false, 'message': 'Something went wrong.'};
    }
  }

  // ---------------- ADD FEE PAYMENT ----------------
  Future<Map<String, dynamic>> addFeePayment(
    Map<String, dynamic> feeData,
  ) async {
    try {
      final response = await _apiService.dio.post('/fees', data: feeData);
      return {'success': true, 'fee': FeeModel.fromJson(response.data)};
    } on DioException catch (e) {
      return {'success': false, 'message': _handleError(e)};
    } catch (e) {
      return {'success': false, 'message': 'Something went wrong.'};
    }
  }

  // ---------------- UPDATE FEE RECORD ----------------
  Future<Map<String, dynamic>> updateFeeRecord(
    String id,
    Map<String, dynamic> feeData,
  ) async {
    try {
      final response = await _apiService.dio.put('/fees/$id', data: feeData);
      return {'success': true, 'fee': FeeModel.fromJson(response.data)};
    } on DioException catch (e) {
      return {'success': false, 'message': _handleError(e)};
    } catch (e) {
      return {'success': false, 'message': 'Something went wrong.'};
    }
  }

  // ---------------- DELETE FEE RECORD ----------------
  Future<Map<String, dynamic>> deleteFeeRecord(String id) async {
    try {
      await _apiService.dio.delete('/fees/$id');
      return {'success': true};
    } on DioException catch (e) {
      return {'success': false, 'message': _handleError(e)};
    } catch (e) {
      return {'success': false, 'message': 'Something went wrong.'};
    }
  }

  // ---------------- GET FEE COLLECTION SUMMARY (for dashboard) ----------------
  Future<Map<String, dynamic>> getFeeSummary({String? month}) async {
    try {
      final response = await _apiService.dio.get(
        '/fees/summary',
        queryParameters: month != null ? {'month': month} : null,
      );
      return {'success': true, 'summary': response.data};
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
