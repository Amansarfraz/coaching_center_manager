import 'package:flutter/material.dart';
import '../models/student_model.dart';
import '../services/student_service.dart';

class StudentProvider extends ChangeNotifier {
  final StudentService _studentService = StudentService();

  List<StudentModel> _students = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<StudentModel> get students => _students;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // ---------------- FETCH ALL STUDENTS ----------------
  Future<void> fetchStudents() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _studentService.getAllStudents();

    _isLoading = false;

    if (result['success'] == true) {
      _students = result['students'];
    } else {
      _errorMessage = result['message'];
    }
    notifyListeners();
  }

  // ---------------- ADD STUDENT ----------------
  Future<bool> addStudent(Map<String, dynamic> studentData) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _studentService.addStudent(studentData);

    _isLoading = false;

    if (result['success'] == true) {
      _students.add(result['student']);
      notifyListeners();
      return true;
    } else {
      _errorMessage = result['message'];
      notifyListeners();
      return false;
    }
  }

  // ---------------- UPDATE STUDENT ----------------
  Future<bool> updateStudent(
    String id,
    Map<String, dynamic> studentData,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _studentService.updateStudent(id, studentData);

    _isLoading = false;

    if (result['success'] == true) {
      final index = _students.indexWhere((s) => s.id == id);
      if (index != -1) {
        _students[index] = result['student'];
      }
      notifyListeners();
      return true;
    } else {
      _errorMessage = result['message'];
      notifyListeners();
      return false;
    }
  }

  // ---------------- DELETE STUDENT ----------------
  Future<bool> deleteStudent(String id) async {
    _isLoading = true;
    notifyListeners();

    final result = await _studentService.deleteStudent(id);

    _isLoading = false;

    if (result['success'] == true) {
      _students.removeWhere((s) => s.id == id);
      notifyListeners();
      return true;
    } else {
      _errorMessage = result['message'];
      notifyListeners();
      return false;
    }
  }

  // ---------------- SEARCH STUDENTS ----------------
  Future<void> searchStudents(String query) async {
    if (query.isEmpty) {
      fetchStudents();
      return;
    }
    _isLoading = true;
    notifyListeners();

    final result = await _studentService.searchStudents(query);

    _isLoading = false;

    if (result['success'] == true) {
      _students = result['students'];
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
