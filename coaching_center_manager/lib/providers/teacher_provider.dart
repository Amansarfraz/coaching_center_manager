import 'package:flutter/material.dart';
import '../models/teacher_model.dart';
import '../services/teacher_service.dart';

class TeacherProvider extends ChangeNotifier {
  final TeacherService _teacherService = TeacherService();

  List<TeacherModel> _teachers = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<TeacherModel> get teachers => _teachers;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // ---------------- FETCH ALL TEACHERS ----------------
  Future<void> fetchTeachers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _teacherService.getAllTeachers();

    _isLoading = false;

    if (result['success'] == true) {
      _teachers = result['teachers'];
    } else {
      _errorMessage = result['message'];
    }
    notifyListeners();
  }

  // ---------------- ADD TEACHER ----------------
  Future<bool> addTeacher(Map<String, dynamic> teacherData) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _teacherService.addTeacher(teacherData);

    _isLoading = false;

    if (result['success'] == true) {
      _teachers.add(result['teacher']);
      notifyListeners();
      return true;
    } else {
      _errorMessage = result['message'];
      notifyListeners();
      return false;
    }
  }

  // ---------------- UPDATE TEACHER ----------------
  Future<bool> updateTeacher(
    String id,
    Map<String, dynamic> teacherData,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _teacherService.updateTeacher(id, teacherData);

    _isLoading = false;

    if (result['success'] == true) {
      final index = _teachers.indexWhere((t) => t.id == id);
      if (index != -1) {
        _teachers[index] = result['teacher'];
      }
      notifyListeners();
      return true;
    } else {
      _errorMessage = result['message'];
      notifyListeners();
      return false;
    }
  }

  // ---------------- DELETE TEACHER ----------------
  Future<bool> deleteTeacher(String id) async {
    _isLoading = true;
    notifyListeners();

    final result = await _teacherService.deleteTeacher(id);

    _isLoading = false;

    if (result['success'] == true) {
      _teachers.removeWhere((t) => t.id == id);
      notifyListeners();
      return true;
    } else {
      _errorMessage = result['message'];
      notifyListeners();
      return false;
    }
  }

  // ---------------- SEARCH TEACHERS ----------------
  Future<void> searchTeachers(String query) async {
    if (query.isEmpty) {
      fetchTeachers();
      return;
    }
    _isLoading = true;
    notifyListeners();

    final result = await _teacherService.searchTeachers(query);

    _isLoading = false;

    if (result['success'] == true) {
      _teachers = result['teachers'];
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
