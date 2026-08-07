import 'package:dio/dio.dart';
import '../models/batch_model.dart';
import 'api_service.dart';

class BatchService {
  final ApiService _apiService = ApiService();

  // ---------------- GET ALL BATCHES ----------------
  Future<Map<String, dynamic>> getAllBatches() async {
    try {
      final response = await _apiService.dio.get('/batches');

      final List data = response.data['batches'] ?? response.data;
      final batches = data.map((e) => BatchModel.fromJson(e)).toList();

      return {'success': true, 'batches': batches};
    } on DioException catch (e) {
      return {'success': false, 'message': _handleError(e)};
    } catch (e) {
      return {'success': false, 'message': 'Something went wrong.'};
    }
  }

  // ---------------- GET SINGLE BATCH ----------------
  Future<Map<String, dynamic>> getBatchById(String id) async {
    try {
      final response = await _apiService.dio.get('/batches/$id');
      final batch = BatchModel.fromJson(response.data);
      return {'success': true, 'batch': batch};
    } on DioException catch (e) {
      return {'success': false, 'message': _handleError(e)};
    } catch (e) {
      return {'success': false, 'message': 'Something went wrong.'};
    }
  }

  // ---------------- ADD BATCH ----------------
  Future<Map<String, dynamic>> addBatch(Map<String, dynamic> batchData) async {
    try {
      final response = await _apiService.dio.post('/batches', data: batchData);
      return {'success': true, 'batch': BatchModel.fromJson(response.data)};
    } on DioException catch (e) {
      return {'success': false, 'message': _handleError(e)};
    } catch (e) {
      return {'success': false, 'message': 'Something went wrong.'};
    }
  }

  // ---------------- UPDATE BATCH ----------------
  Future<Map<String, dynamic>> updateBatch(
    String id,
    Map<String, dynamic> batchData,
  ) async {
    try {
      final response = await _apiService.dio.put(
        '/batches/$id',
        data: batchData,
      );
      return {'success': true, 'batch': BatchModel.fromJson(response.data)};
    } on DioException catch (e) {
      return {'success': false, 'message': _handleError(e)};
    } catch (e) {
      return {'success': false, 'message': 'Something went wrong.'};
    }
  }

  // ---------------- DELETE BATCH ----------------
  Future<Map<String, dynamic>> deleteBatch(String id) async {
    try {
      await _apiService.dio.delete('/batches/$id');
      return {'success': true};
    } on DioException catch (e) {
      return {'success': false, 'message': _handleError(e)};
    } catch (e) {
      return {'success': false, 'message': 'Something went wrong.'};
    }
  }

  // ---------------- GET STUDENTS OF A BATCH ----------------
  Future<Map<String, dynamic>> getBatchStudents(String batchId) async {
    try {
      final response = await _apiService.dio.get('/batches/$batchId/students');
      return {
        'success': true,
        'students': response.data['students'] ?? response.data,
      };
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
