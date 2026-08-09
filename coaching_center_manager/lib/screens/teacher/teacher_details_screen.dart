import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/teacher_provider.dart';
import '../../models/teacher_model.dart';
import 'teacher_add_screen.dart';

class TeacherDetailsScreen extends StatelessWidget {
  final TeacherModel teacher;
  const TeacherDetailsScreen({super.key, required this.teacher});

  Widget _infoTile(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF16305C)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 2),
                Text(
                  value.isEmpty ? '-' : value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({required String title, required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
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
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: Color(0xFF16305C),
            ),
          ),
          const Divider(height: 20),
          ...children,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8CC2E8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF16305C)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          teacher.fullName,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 17,
            color: Color(0xFF16305C),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile header
            Container(
              padding: const EdgeInsets.all(20),
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
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: const Color(0xFFE3EEFB),
                    backgroundImage:
                        teacher.profileImage != null &&
                            teacher.profileImage!.isNotEmpty
                        ? NetworkImage(teacher.profileImage!)
                        : null,
                    child:
                        teacher.profileImage == null ||
                            teacher.profileImage!.isEmpty
                        ? const Icon(
                            Icons.person,
                            size: 40,
                            color: Color(0xFF16305C),
                          )
                        : null,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    teacher.fullName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '(${teacher.qualification})',
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            _sectionCard(
              title: 'Personal Info',
              children: [
                _infoTile(Icons.phone_outlined, 'Phone', teacher.phone),
                _infoTile(Icons.email_outlined, 'Email', teacher.email),
                _infoTile(Icons.wc_outlined, 'Gender', teacher.gender),
              ],
            ),

            _sectionCard(
              title: 'Qualifications',
              children: [
                _infoTile(
                  Icons.school_outlined,
                  'Qualification',
                  teacher.qualification,
                ),
                _infoTile(
                  Icons.subject_outlined,
                  'Assigned Subjects',
                  teacher.assignedSubjects.isEmpty
                      ? '-'
                      : teacher.assignedSubjects.join(', '),
                ),
              ],
            ),

            _sectionCard(
              title: 'Salary Info',
              children: [
                _infoTile(
                  Icons.attach_money,
                  'Monthly Salary',
                  'Rs. ${teacher.salary.toStringAsFixed(0)}',
                ),
                _infoTile(
                  Icons.calendar_today_outlined,
                  'Joining Date',
                  '${teacher.joiningDate.day}/${teacher.joiningDate.month}/${teacher.joiningDate.year}',
                ),
              ],
            ),

            _sectionCard(
              title: 'Assigned Batches',
              children: [
                teacher.assignedBatchIds.isEmpty
                    ? const Text(
                        'No batches assigned',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      )
                    : Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: teacher.assignedBatchIds
                            .map(
                              (id) => Chip(
                                label: Text(
                                  id,
                                  style: const TextStyle(fontSize: 12),
                                ),
                                backgroundColor: const Color(0xFFE3EEFB),
                              ),
                            )
                            .toList(),
                      ),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              TeacherAddScreen(teacherToEdit: teacher),
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
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Teacher'),
        content: Text('Are you sure you want to delete ${teacher.fullName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final provider = Provider.of<TeacherProvider>(
                context,
                listen: false,
              );
              Navigator.pop(context); // close dialog
              final success = await provider.deleteTeacher(teacher.id);
              if (success && context.mounted) {
                Navigator.pop(context); // go back to list
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
