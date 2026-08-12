import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/batch_provider.dart';
import '../../providers/student_provider.dart';
import '../../providers/attendance_provider.dart';
import '../../models/batch_model.dart';

class MarkAttendanceScreen extends StatefulWidget {
  const MarkAttendanceScreen({super.key});

  @override
  State<MarkAttendanceScreen> createState() => _MarkAttendanceScreenState();
}

class _MarkAttendanceScreenState extends State<MarkAttendanceScreen> {
  BatchModel? _selectedBatch;
  DateTime _selectedDate = DateTime.now();
  final Map<String, String> _statusMap =
      {}; // studentId -> present/absent/leave

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
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
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
        .where((s) => s.batchName == _selectedBatch!.batchName)
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
        const SnackBar(content: Text('Attendance marked successfully')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            attendanceProvider.errorMessage ?? 'Failed to mark attendance',
          ),
        ),
      );
    }
  }

  Widget _statusChip(
    String studentId,
    String status,
    String label,
    Color color,
  ) {
    final isSelected = (_statusMap[studentId] ?? 'present') == status;
    return GestureDetector(
      onTap: () => setState(() => _statusMap[studentId] = status),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        margin: const EdgeInsets.only(left: 6),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : color,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final batchProvider = Provider.of<BatchProvider>(context);
    final studentProvider = Provider.of<StudentProvider>(context);
    final attendanceProvider = Provider.of<AttendanceProvider>(context);

    final batchStudents = _selectedBatch == null
        ? []
        : studentProvider.students
              .where((s) => s.batchName == _selectedBatch!.batchName)
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
                    fontSize: 22,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Batch dropdown
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<BatchModel>(
                      value: _selectedBatch,
                      hint: const Text('Select Batch'),
                      isExpanded: true,
                      items: batchProvider.batches
                          .map(
                            (b) => DropdownMenuItem(
                              value: b,
                              child: Text(b.batchName),
                            ),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setState(() => _selectedBatch = value),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Date picker
                InkWell(
                  onTap: _pickDate,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 18,
                          color: Color(0xFF16305C),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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
                            const CircleAvatar(
                              radius: 20,
                              backgroundColor: Color(0xFFE3EEFB),
                              child: Icon(
                                Icons.person,
                                color: Color(0xFF16305C),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                student.fullName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            _statusChip(
                              student.id,
                              'present',
                              'P',
                              const Color(0xFF27AE60),
                            ),
                            _statusChip(
                              student.id,
                              'absent',
                              'A',
                              const Color(0xFFEB5757),
                            ),
                            _statusChip(
                              student.id,
                              'leave',
                              'L',
                              const Color(0xFFF2C94C),
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
                child: ElevatedButton.icon(
                  onPressed: attendanceProvider.isLoading
                      ? null
                      : _submitAttendance,
                  icon: attendanceProvider.isLoading
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(
                          Icons.check_circle_outline,
                          color: Colors.white,
                        ),
                  label: const Text('Save Attendance'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF16305C),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
