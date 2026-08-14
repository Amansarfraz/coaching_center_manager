import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_dynamic_colors.dart';
import '../../providers/student_provider.dart';
import '../../models/student_model.dart';
import 'student_add_screen.dart';

class StudentDetailsScreen extends StatelessWidget {
  final StudentModel student;
  const StudentDetailsScreen({super.key, required this.student});

  Widget _sectionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppDynamicColors.cardBg(context),
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
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: AppDynamicColors.primaryText(context),
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

  Widget _infoRow(BuildContext context, IconData icon, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppDynamicColors.secondaryText(context)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 15,
                color: AppDynamicColors.primaryText(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ImageProvider? _getStudentImage() {
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

  @override
  Widget build(BuildContext context) {
    final image = _getStudentImage();
    final bgColor = AppDynamicColors.scaffoldBg(context);
    final headerColor = AppDynamicColors.headerBg(context);
    final headerTextColor = AppDynamicColors.headerText(context);
    final primaryTextColor = AppDynamicColors.primaryText(context);
    final secondaryTextColor = AppDynamicColors.secondaryText(context);
    final cardColor = AppDynamicColors.cardBg(context);

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
            decoration: BoxDecoration(color: headerColor),
            child: Row(
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back,
                    color: headerTextColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'Student Details',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 22,
                    color: headerTextColor,
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
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF86BFE2),
                        width: 3,
                      ),
                    ),
                    child: ClipOval(
                      child: image != null
                          ? Image(image: image, fit: BoxFit.cover)
                          : Container(
                              color: const Color(0xFFE3EEFB),
                              child: const Icon(
                                Icons.person,
                                size: 70,
                                color: Color(0xFF16305C),
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    student.fullName,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 22,
                      color: primaryTextColor,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 20),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: _sectionCard(
                      context,
                      icon: Icons.person_outline,
                      title: 'Personal Info',
                      children: [
                        _infoRow(context, Icons.phone, student.phone),
                        _infoRow(
                          context,
                          Icons.email_outlined,
                          student.email.isEmpty ? '-' : student.email,
                        ),
                        _infoRow(
                          context,
                          Icons.escalator_warning_outlined,
                          "Father: ${student.fatherName}",
                        ),
                        _infoRow(context, Icons.wc_outlined, student.gender),
                      ],
                    ),
                  ),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: _sectionCard(
                      context,
                      icon: Icons.home_outlined,
                      title: 'Home Address',
                      children: [
                        Text(
                          student.homeAddress.isEmpty
                              ? '-'
                              : student.homeAddress,
                          style: TextStyle(
                            fontSize: 15,
                            color: primaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: _sectionCard(
                      context,
                      icon: Icons.school_outlined,
                      title: 'Academic Info',
                      children: [
                        Text(
                          'Batch: ${student.batchName}',
                          style: TextStyle(
                            fontSize: 15,
                            color: primaryTextColor,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Date of Birth: ${student.dob.day}/${student.dob.month}/${student.dob.year}',
                          style: TextStyle(
                            fontSize: 15,
                            color: primaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16, right: 8),
                          padding: const EdgeInsets.all(16),
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
                                  const Icon(
                                    Icons.attach_money,
                                    size: 20,
                                    color: Color(0xFF16305C),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Fee Info',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                      color: primaryTextColor,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Monthly: Rs.${student.monthlyFee.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: primaryTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16, left: 8),
                          padding: const EdgeInsets.all(16),
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
                                  const Icon(
                                    Icons.calendar_today_outlined,
                                    size: 18,
                                    color: Color(0xFF16305C),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Admission',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                      color: primaryTextColor,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                '${student.admissionDate.day}/${student.admissionDate.month}/${student.admissionDate.year}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: primaryTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
                                    StudentAddScreen(studentToEdit: student),
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
        title: const Text('Delete Student'),
        content: Text('Are you sure you want to delete ${student.fullName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final provider = Provider.of<StudentProvider>(
                context,
                listen: false,
              );
              Navigator.pop(context);
              final success = await provider.deleteStudent(student.id);
              if (success && context.mounted) {
                Navigator.pop(context);
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
