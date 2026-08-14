import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_dynamic_colors.dart';
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
        return const Color(0xFFF2994A);
    }
  }

  @override
  Widget build(BuildContext context) {
    final batchProvider = Provider.of<BatchProvider>(context);
    final attendanceProvider = Provider.of<AttendanceProvider>(context);
    final records = attendanceProvider.attendanceRecords;

    final total = records.length;
    final present = records.where((r) => r.status == 'present').length;
    final absent = records.where((r) => r.status == 'absent').length;
    final leave = records.where((r) => r.status == 'leave').length;
    final presentPct = total == 0 ? 0.0 : (present / total) * 100;

    final bgColor = AppDynamicColors.scaffoldBg(context);
    final headerTextColor = Colors.white;
    final primaryTextColor = AppDynamicColors.primaryText(context);
    final secondaryTextColor = AppDynamicColors.secondaryText(context);
    final cardColor = AppDynamicColors.cardBg(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final headerColor = isDark
        ? const Color(0xFF0D1E33)
        : const Color(0xFF16305C);

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 24),
            decoration: BoxDecoration(
              color: headerColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.arrow_back,
                        color: headerTextColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Attendance History',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: headerTextColor,
                      ),
                    ),
                  ],
                ),
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: headerColor),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Date Picker',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: primaryTextColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            InkWell(
                              onTap: _pickDate,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: cardColor,
                                  borderRadius: BorderRadius.circular(12),
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
                                    const Icon(
                                      Icons.calendar_today_outlined,
                                      size: 16,
                                      color: Color(0xFF16305C),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: primaryTextColor,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Icon(
                                      Icons.chevron_right,
                                      size: 16,
                                      color: secondaryTextColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Batch Selector',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: primaryTextColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            InkWell(
                              onTap: () async {
                                final selected =
                                    await showModalBottomSheet<BatchModel>(
                                      context: context,
                                      backgroundColor: cardColor,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20),
                                        ),
                                      ),
                                      builder: (context) => SafeArea(
                                        child: ListView(
                                          shrinkWrap: true,
                                          padding: const EdgeInsets.all(16),
                                          children: batchProvider.batches
                                              .map(
                                                (b) => ListTile(
                                                  title: Text(
                                                    b.batchName,
                                                    style: TextStyle(
                                                      color: primaryTextColor,
                                                    ),
                                                  ),
                                                  subtitle: Text(
                                                    b.teacherName,
                                                    style: TextStyle(
                                                      color: secondaryTextColor,
                                                    ),
                                                  ),
                                                  onTap: () =>
                                                      Navigator.pop(context, b),
                                                ),
                                              )
                                              .toList(),
                                        ),
                                      ),
                                    );
                                if (selected != null) {
                                  setState(() => _selectedBatch = selected);
                                  _fetchHistory();
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: cardColor,
                                  borderRadius: BorderRadius.circular(12),
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
                                    Expanded(
                                      child: Text(
                                        _selectedBatch?.batchName ??
                                            'Select Batch',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: primaryTextColor,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_drop_down,
                                      size: 18,
                                      color: secondaryTextColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  if (_selectedBatch == null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Text(
                          'Select a batch to view attendance history',
                          style: TextStyle(color: secondaryTextColor),
                        ),
                      ),
                    )
                  else if (attendanceProvider.isLoading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE3EEFB),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.groups,
                                        size: 16,
                                        color: Color(0xFF2F80ED),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Total Students',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: secondaryTextColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  height: 90,
                                  width: 90,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      SizedBox(
                                        height: 90,
                                        width: 90,
                                        child: CircularProgressIndicator(
                                          value: total == 0
                                              ? 0
                                              : presentPct / 100,
                                          strokeWidth: 9,
                                          backgroundColor: const Color(
                                            0xFFEFEFEF,
                                          ),
                                          color: const Color(0xFF27AE60),
                                        ),
                                      ),
                                      Text(
                                        '$total',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800,
                                          color: primaryTextColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Present: $present (${presentPct.toStringAsFixed(0)}%)',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF27AE60),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            children: [
                              _statBar(
                                context,
                                icon: Icons.block,
                                iconColor: const Color(0xFFEB5757),
                                iconBg: const Color(0xFFFDE8EA),
                                title: 'Absent: $absent',
                                count: absent,
                                total: total,
                                barColor: const Color(0xFFEB5757),
                              ),
                              const SizedBox(height: 12),
                              _statBar(
                                context,
                                icon: Icons.beach_access,
                                iconColor: const Color(0xFFF2994A),
                                iconBg: const Color(0xFFFFF3E0),
                                title: 'On Leave: $leave',
                                count: leave,
                                total: total,
                                barColor: const Color(0xFFF2994A),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    if (records.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: Center(
                          child: Text(
                            'No attendance record found for this batch on this date.\nMark attendance first from "Record Attendance".',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: secondaryTextColor,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      )
                    else
                      ...records.map(
                        (record) => Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(16),
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
                              const CircleAvatar(
                                radius: 22,
                                backgroundColor: Color(0xFFE3EEFB),
                                child: Icon(
                                  Icons.person,
                                  color: Color(0xFF16305C),
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      record.studentName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                        color: primaryTextColor,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _statusColor(record.status),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        record.status[0].toUpperCase() +
                                            record.status.substring(1),
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              _editPill(
                                'P',
                                record.status == 'present',
                                const Color(0xFF27AE60),
                                () {
                                  Provider.of<AttendanceProvider>(
                                    context,
                                    listen: false,
                                  ).updateStatus(record.id, 'present');
                                },
                              ),
                              _editPill(
                                'A',
                                record.status == 'absent',
                                const Color(0xFFEB5757),
                                () {
                                  Provider.of<AttendanceProvider>(
                                    context,
                                    listen: false,
                                  ).updateStatus(record.id, 'absent');
                                },
                              ),
                              _editPill(
                                'L',
                                record.status == 'leave',
                                const Color(0xFFF2994A),
                                () {
                                  Provider.of<AttendanceProvider>(
                                    context,
                                    listen: false,
                                  ).updateStatus(record.id, 'leave');
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statBar(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required int count,
    required int total,
    required Color barColor,
  }) {
    final pct = total == 0 ? 0.0 : (count / total) * 100;
    final cardColor = AppDynamicColors.cardBg(context);
    final primaryTextColor = AppDynamicColors.primaryText(context);
    final secondaryTextColor = AppDynamicColors.secondaryText(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 14, color: iconColor),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: primaryTextColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: SizedBox(
                  height: 30,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _bar(4, barColor.withOpacity(0.3)),
                      const SizedBox(width: 3),
                      _bar(10, barColor.withOpacity(0.3)),
                      const SizedBox(width: 3),
                      _bar(24, barColor),
                      const SizedBox(width: 3),
                      _bar(14, barColor.withOpacity(0.3)),
                      const SizedBox(width: 3),
                      _bar(8, barColor.withOpacity(0.3)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$count\n(${pct.toStringAsFixed(0)}%)',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 10,
                  color: secondaryTextColor,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bar(double height, Color color) {
    return Container(
      width: 8,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  Widget _editPill(
    String label,
    bool isSelected,
    Color color,
    VoidCallback onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 26,
          height: 26,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? color : color.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: isSelected ? Colors.white : color,
            ),
          ),
        ),
      ),
    );
  }
}
