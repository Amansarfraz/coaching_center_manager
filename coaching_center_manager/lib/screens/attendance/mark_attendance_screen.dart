import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/batch_provider.dart';
import '../../providers/student_provider.dart';
import '../../providers/attendance_provider.dart';
import '../../models/batch_model.dart';
import '../../models/student_model.dart';

class MarkAttendanceScreen extends StatefulWidget {
  const MarkAttendanceScreen({super.key});

  @override
  State<MarkAttendanceScreen> createState() => _MarkAttendanceScreenState();
}

class _MarkAttendanceScreenState extends State<MarkAttendanceScreen> {
  BatchModel? _selectedBatch;
  DateTime _selectedDate = DateTime.now();
  final Map<String, String> _statusMap = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BatchProvider>(context, listen: false).fetchBatches();
      Provider.of<StudentProvider>(context, listen: false).fetchStudents();
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickBatch() async {
    final batchProvider = Provider.of<BatchProvider>(context, listen: false);
    final selected = await showModalBottomSheet<BatchModel>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(16),
          children: batchProvider.batches
              .map(
                (b) => ListTile(
                  title: Text(b.batchName),
                  subtitle: Text(b.teacherName),
                  onTap: () => Navigator.pop(context, b),
                ),
              )
              .toList(),
        );
      },
    );
    if (selected != null) setState(() => _selectedBatch = selected);
  }

  Future<void> _submitAttendance() async {
    if (_selectedBatch == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a batch')));
      return;
    }

    final studentProvider = Provider.of<StudentProvider>(
      context,
      listen: false,
    );
    final attendanceProvider = Provider.of<AttendanceProvider>(
      context,
      listen: false,
    );

    final batchStudents = studentProvider.students
        .where((s) => s.batchId == _selectedBatch!.id)
        .toList();

    if (batchStudents.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No students in this batch')),
      );
      return;
    }

    final attendanceList = batchStudents.map((s) {
      return {
        'student_id': s.id,
        'student_name': s.fullName,
        'status': _statusMap[s.id] ?? 'present',
      };
    }).toList();

    final success = await attendanceProvider.markAttendance(
      batchId: _selectedBatch!.id,
      date: _selectedDate,
      attendanceList: attendanceList,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Attendance saved successfully')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            attendanceProvider.errorMessage ?? 'Failed to save attendance',
          ),
        ),
      );
    }
  }

  ImageProvider? _getStudentImage(StudentModel student) {
    final img = student.profileImage;
    if (img != null && img.isNotEmpty) {
      try {
        return MemoryImage(base64Decode(img));
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  Widget _pillButton(
    String studentId,
    String status,
    String label,
    IconData icon,
    Color color,
  ) {
    final isSelected = (_statusMap[studentId] ?? 'present') == status;
    return GestureDetector(
      onTap: () => setState(() => _statusMap[studentId] = status),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        margin: const EdgeInsets.only(left: 4),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: isSelected ? Colors.white : color),
            const SizedBox(width: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final studentProvider = Provider.of<StudentProvider>(context);
    final attendanceProvider = Provider.of<AttendanceProvider>(context);

    final batchStudents = _selectedBatch == null
        ? <StudentModel>[]
        : studentProvider.students
              .where((s) => s.batchId == _selectedBatch!.id)
              .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFE8F3FB),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
            decoration: const BoxDecoration(color: Color(0xFF86BFE2)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Mark Attendance',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.search, size: 18, color: Color(0xFF16305C)),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: InkWell(
              onTap: _pickBatch,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Batch: ${_selectedBatch?.batchName ?? "Tap to select"}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: Color(0xFF16305C),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: _pickDate,
                      child: const Icon(
                        Icons.calendar_today_outlined,
                        size: 20,
                        color: Color(0xFF16305C),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: _selectedBatch == null
                ? const Center(
                    child: Text(
                      'Select a batch to mark attendance',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : batchStudents.isEmpty
                ? const Center(
                    child: Text(
                      'No students in this batch',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: batchStudents.length,
                    itemBuilder: (context, index) {
                      final student = batchStudents[index];
                      final image = _getStudentImage(student);
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: const Color(0xFFE3EEFB),
                              backgroundImage: image,
                              child: image == null
                                  ? const Icon(
                                      Icons.person,
                                      color: Color(0xFF16305C),
                                      size: 20,
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                student.fullName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            _pillButton(
                              student.id,
                              'present',
                              'Present',
                              Icons.check,
                              const Color(0xFF27AE60),
                            ),
                            _pillButton(
                              student.id,
                              'absent',
                              'Absent',
                              Icons.close,
                              const Color(0xFFEB5757),
                            ),
                            _pillButton(
                              student.id,
                              'leave',
                              'Leave',
                              Icons.calendar_today,
                              const Color(0xFFF2994A),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          if (_selectedBatch != null && batchStudents.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: attendanceProvider.isLoading
                      ? null
                      : _submitAttendance,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF16305C),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: attendanceProvider.isLoading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Save Attendance'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
