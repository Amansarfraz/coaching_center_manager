import 'package:flutter/material.dart';
import '../models/batch_model.dart';
import '../services/batch_service.dart';

class BatchProvider extends ChangeNotifier {
  final BatchService _batchService = BatchService();

  List<BatchModel> _batches = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<BatchModel> get batches => _batches;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // ---------------- FETCH ALL BATCHES ----------------
  Future<void> fetchBatches() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _batchService.getAllBatches();

    _isLoading = false;

    if (result['success'] == true) {
      _batches = result['batches'];
    } else {
      _errorMessage = result['message'];
    }
    notifyListeners();
  }

  // ---------------- ADD BATCH ----------------
  Future<bool> addBatch(Map<String, dynamic> batchData) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _batchService.addBatch(batchData);

    _isLoading = false;

    if (result['success'] == true) {
      _batches.add(result['batch']);
      notifyListeners();
      return true;
    } else {
      _errorMessage = result['message'];
      notifyListeners();
      return false;
    }
  }

  // ---------------- UPDATE BATCH ----------------
  Future<bool> updateBatch(String id, Map<String, dynamic> batchData) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _batchService.updateBatch(id, batchData);

    _isLoading = false;

    if (result['success'] == true) {
      final index = _batches.indexWhere((b) => b.id == id);
      if (index != -1) {
        _batches[index] = result['batch'];
      }
      notifyListeners();
      return true;
    } else {
      _errorMessage = result['message'];
      notifyListeners();
      return false;
    }
  }

  // ---------------- DELETE BATCH ----------------
  Future<bool> deleteBatch(String id) async {
    _isLoading = true;
    notifyListeners();

    final result = await _batchService.deleteBatch(id);

    _isLoading = false;

    if (result['success'] == true) {
      _batches.removeWhere((b) => b.id == id);
      notifyListeners();
      return true;
    } else {
      _errorMessage = result['message'];
      notifyListeners();
      return false;
    }
  }

  // ---------------- CLEAR ERROR ----------------
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
