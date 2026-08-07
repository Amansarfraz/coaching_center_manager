import 'package:flutter/material.dart';
import '../models/attendance_model.dart';
import '../services/attendance_service.dart';

class AttendanceProvider extends ChangeNotifier {
  final AttendanceService _attendanceService = AttendanceService();

  List<AttendanceModel> _attendanceRecords = [];
  Map<String, dynamic>? _stats;
  bool _isLoading = false;
  String? _errorMessage;

  List<AttendanceModel> get attendanceRecords => _attendanceRecords;
  Map<String, dynamic>? get stats => _stats;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // ---------------- MARK ATTENDANCE ----------------
  Future<bool> markAttendance({
    required String batchId,
    required DateTime date,
    required List<Map<String, dynamic>> attendanceList,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _attendanceService.markAttendance(
      batchId: batchId,
      date: date,
      attendanceList: attendanceList,
    );

    _isLoading = false;

    if (result['success'] == true) {
      notifyListeners();
      return true;
    } else {
      _errorMessage = result['message'];
      notifyListeners();
      return false;
    }
  }

  // ---------------- FETCH ATTENDANCE BY BATCH & DATE ----------------
  Future<void> fetchAttendanceByDate({
    required String batchId,
    required DateTime date,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _attendanceService.getAttendanceByDate(
      batchId: batchId,
      date: date,
    );

    _isLoading = false;

    if (result['success'] == true) {
      _attendanceRecords = result['records'];
    } else {
      _errorMessage = result['message'];
    }
    notifyListeners();
  }

  // ---------------- FETCH STUDENT ATTENDANCE HISTORY ----------------
  Future<void> fetchStudentHistory(String studentId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _attendanceService.getStudentAttendanceHistory(
      studentId,
    );

    _isLoading = false;

    if (result['success'] == true) {
      _attendanceRecords = result['records'];
    } else {
      _errorMessage = result['message'];
    }
    notifyListeners();
  }

  // ---------------- FETCH ATTENDANCE STATS ----------------
  Future<void> fetchAttendanceStats({
    required String batchId,
    required DateTime date,
  }) async {
    _isLoading = true;
    notifyListeners();

    final result = await _attendanceService.getAttendanceStats(
      batchId: batchId,
      date: date,
    );

    _isLoading = false;

    if (result['success'] == true) {
      _stats = result['stats'];
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
