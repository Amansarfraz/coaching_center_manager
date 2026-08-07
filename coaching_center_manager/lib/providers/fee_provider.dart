import 'package:flutter/material.dart';
import '../models/fee_model.dart';
import '../services/fee_service.dart';

class FeeProvider extends ChangeNotifier {
  final FeeService _feeService = FeeService();

  List<FeeModel> _feeRecords = [];
  Map<String, dynamic>? _summary;
  bool _isLoading = false;
  String? _errorMessage;

  List<FeeModel> get feeRecords => _feeRecords;
  Map<String, dynamic>? get summary => _summary;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // ---------------- FETCH ALL FEE RECORDS ----------------
  Future<void> fetchFeeRecords({String? month}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _feeService.getAllFeeRecords(month: month);

    _isLoading = false;

    if (result['success'] == true) {
      _feeRecords = result['fees'];
    } else {
      _errorMessage = result['message'];
    }
    notifyListeners();
  }

  // ---------------- FETCH STUDENT FEE RECORDS ----------------
  Future<void> fetchStudentFeeRecords(String studentId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _feeService.getStudentFeeRecords(studentId);

    _isLoading = false;

    if (result['success'] == true) {
      _feeRecords = result['fees'];
    } else {
      _errorMessage = result['message'];
    }
    notifyListeners();
  }

  // ---------------- ADD FEE PAYMENT ----------------
  Future<bool> addFeePayment(Map<String, dynamic> feeData) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _feeService.addFeePayment(feeData);

    _isLoading = false;

    if (result['success'] == true) {
      _feeRecords.add(result['fee']);
      notifyListeners();
      return true;
    } else {
      _errorMessage = result['message'];
      notifyListeners();
      return false;
    }
  }

  // ---------------- UPDATE FEE RECORD ----------------
  Future<bool> updateFeeRecord(String id, Map<String, dynamic> feeData) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _feeService.updateFeeRecord(id, feeData);

    _isLoading = false;

    if (result['success'] == true) {
      final index = _feeRecords.indexWhere((f) => f.id == id);
      if (index != -1) {
        _feeRecords[index] = result['fee'];
      }
      notifyListeners();
      return true;
    } else {
      _errorMessage = result['message'];
      notifyListeners();
      return false;
    }
  }

  // ---------------- DELETE FEE RECORD ----------------
  Future<bool> deleteFeeRecord(String id) async {
    _isLoading = true;
    notifyListeners();

    final result = await _feeService.deleteFeeRecord(id);

    _isLoading = false;

    if (result['success'] == true) {
      _feeRecords.removeWhere((f) => f.id == id);
      notifyListeners();
      return true;
    } else {
      _errorMessage = result['message'];
      notifyListeners();
      return false;
    }
  }

  // ---------------- FETCH FEE SUMMARY (for dashboard) ----------------
  Future<void> fetchFeeSummary({String? month}) async {
    _isLoading = true;
    notifyListeners();

    final result = await _feeService.getFeeSummary(month: month);

    _isLoading = false;

    if (result['success'] == true) {
      _summary = result['summary'];
    } else {
      _errorMessage = result['message'];
    }
    notifyListeners();
  }

  // ---------------- CLEAR ERROR ----------------
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
