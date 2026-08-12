import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/batch_provider.dart';
import '../../models/batch_model.dart';
import 'batch_add_screen.dart';

class BatchDetailsScreen extends StatelessWidget {
  final BatchModel batch;
  const BatchDetailsScreen({super.key, required this.batch});

  Widget _sectionCard({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
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
              Icon(icon, size: 20, color: const Color(0xFF16305C)),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Color(0xFF16305C),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade600),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = batch.studentCapacity == 0
        ? 0.0
        : batch.totalStudents / batch.studentCapacity;

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
                Expanded(
                  child: Text(
                    'Batch Details',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 22,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFE3EEFB),
                      border: Border.all(
                        color: const Color(0xFF86BFE2),
                        width: 3,
                      ),
                    ),
                    child: const Icon(
                      Icons.groups,
                      size: 60,
                      color: Color(0xFF16305C),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    batch.batchName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 22,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    batch.courseName,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: _sectionCard(
                      icon: Icons.info_outline,
                      title: 'Batch Info',
                      children: [
                        _infoRow(
                          Icons.person_outline,
                          'Teacher: ${batch.teacherName}',
                        ),
                        _infoRow(
                          Icons.class_outlined,
                          'Classroom: ${batch.classroom}',
                        ),
                        _infoRow(Icons.access_time, 'Timing: ${batch.timing}'),
                        _infoRow(
                          Icons.flag_outlined,
                          'Status: ${batch.status}',
                        ),
                      ],
                    ),
                  ),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: _sectionCard(
                      icon: Icons.groups_outlined,
                      title: 'Enrollment',
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: progress.clamp(0.0, 1.0),
                            minHeight: 10,
                            backgroundColor: const Color(0xFFEFEFEF),
                            color: const Color(0xFF2F80ED),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${batch.totalStudents} / ${batch.studentCapacity} students enrolled',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: _sectionCard(
                      icon: Icons.calendar_today_outlined,
                      title: 'Schedule',
                      children: [
                        _infoRow(
                          Icons.play_arrow,
                          'Start: ${batch.startDate.day}/${batch.startDate.month}/${batch.startDate.year}',
                        ),
                        _infoRow(
                          Icons.stop_circle_outlined,
                          batch.endDate == null
                              ? 'End: -'
                              : 'End: ${batch.endDate!.day}/${batch.endDate!.month}/${batch.endDate!.year}',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    BatchAddScreen(batchToEdit: batch),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.edit_outlined,
                            size: 18,
                            color: Colors.white,
                          ),
                          label: const Text('EDIT'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2F80ED),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _confirmDelete(context),
                          icon: const Icon(
                            Icons.delete_outline,
                            size: 18,
                            color: Colors.white,
                          ),
                          label: const Text('DELETE'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFEB5757),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Batch'),
        content: Text('Are you sure you want to delete ${batch.batchName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final provider = Provider.of<BatchProvider>(
                context,
                listen: false,
              );
              Navigator.pop(context);
              final success = await provider.deleteBatch(batch.id);
              if (success && context.mounted) Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
