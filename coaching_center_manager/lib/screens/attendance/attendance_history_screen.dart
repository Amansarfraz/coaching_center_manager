import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/batch_provider.dart';
import '../../providers/attendance_provider.dart';
import '../../models/batch_model.dart';

class AttendanceHistoryScreen extends StatefulWidget {
  const AttendanceHistoryScreen({super.key});

  @override
  State<AttendanceHistoryScreen> createState() =>
      _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState extends State<AttendanceHistoryScreen> {
  BatchModel? _selectedBatch;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BatchProvider>(context, listen: false).fetchBatches();
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
      _fetchHistory();
    }
  }

  void _fetchHistory() {
    if (_selectedBatch != null) {
      Provider.of<AttendanceProvider>(
        context,
        listen: false,
      ).fetchAttendanceByDate(batchId: _selectedBatch!.id, date: _selectedDate);
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'present':
        return const Color(0xFF27AE60);
      case 'absent':
        return const Color(0xFFEB5757);
      default:
        return const Color(0xFFF2C94C);
    }
  }

  @override
  Widget build(BuildContext context) {
    final batchProvider = Provider.of<BatchProvider>(context);
    final attendanceProvider = Provider.of<AttendanceProvider>(context);
    final records = attendanceProvider.attendanceRecords;

    final presentCount = records.where((r) => r.status == 'present').length;
    final absentCount = records.where((r) => r.status == 'absent').length;
    final leaveCount = records.where((r) => r.status == 'leave').length;

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
                  'Attendance History',
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
                      onChanged: (value) {
                        setState(() => _selectedBatch = value);
                        _fetchHistory();
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 12),
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

          if (_selectedBatch != null && records.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: _summaryCard(
                      'Present',
                      presentCount,
                      const Color(0xFF27AE60),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _summaryCard(
                      'Absent',
                      absentCount,
                      const Color(0xFFEB5757),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _summaryCard(
                      'Leave',
                      leaveCount,
                      const Color(0xFFF2C94C),
                    ),
                  ),
                ],
              ),
            ),

          Expanded(
            child: _selectedBatch == null
                ? const Center(
                    child: Text(
                      'Select a batch to view history',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : attendanceProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : records.isEmpty
                ? const Center(
                    child: Text(
                      'No attendance records for this date',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: records.length,
                    itemBuilder: (context, index) {
                      final record = records[index];
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
                                record.studentName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: _statusColor(
                                  record.status,
                                ).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                record.status,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: _statusColor(record.status),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _summaryCard(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }
}
