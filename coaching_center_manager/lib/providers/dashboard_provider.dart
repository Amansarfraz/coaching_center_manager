import 'package:flutter/material.dart';
import '../services/dashboard_service.dart';

class DashboardProvider extends ChangeNotifier {
  final DashboardService _dashboardService = DashboardService();

  Map<String, dynamic>? _summary;
  bool _isLoading = false;
  String? _errorMessage;

  Map<String, dynamic>? get summary => _summary;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Convenience getters
  int get attendancePresent => _summary?['attendance']?['present'] ?? 0;
  int get attendanceAbsent => _summary?['attendance']?['absent'] ?? 0;
  double get attendancePercentage =>
      (_summary?['attendance']?['percentage'] ?? 0).toDouble();

  double get feeTarget =>
      (_summary?['fee_collection']?['target'] ?? 0).toDouble();
  double get feePaid => (_summary?['fee_collection']?['paid'] ?? 0).toDouble();
  double get feePercentage =>
      (_summary?['fee_collection']?['percentage'] ?? 0).toDouble();

  List<dynamic> get recentActivity => _summary?['recent_activity'] ?? [];

  Future<void> fetchSummary() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _dashboardService.getDashboardSummary();

    _isLoading = false;

    if (result['success'] == true) {
      _summary = result['data'];
    } else {
      _errorMessage = result['message'];
    }
    notifyListeners();
  }
}
