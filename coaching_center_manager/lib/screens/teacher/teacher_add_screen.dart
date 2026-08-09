import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/teacher_provider.dart';
import '../../models/teacher_model.dart';

class TeacherAddScreen extends StatefulWidget {
  final TeacherModel? teacherToEdit;
  const TeacherAddScreen({super.key, this.teacherToEdit});

  @override
  State<TeacherAddScreen> createState() => _TeacherAddScreenState();
}

class _TeacherAddScreenState extends State<TeacherAddScreen> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _subjectController = TextEditingController();
  final _qualificationController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _salaryController = TextEditingController();
  final _assignedSubjectsController = TextEditingController();

  String? _selectedGender;
  DateTime? _joiningDate;

  bool get _isEditMode => widget.teacherToEdit != null;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      final t = widget.teacherToEdit!;
      _fullNameController.text = t.fullName;
      _subjectController.text = t.subject;
      _qualificationController.text = t.qualification;
      _phoneController.text = t.phone;
      _emailController.text = t.email;
      _salaryController.text = t.salary.toString();
      _assignedSubjectsController.text = t.assignedSubjects.join(', ');
      _selectedGender = t.gender;
      _joiningDate = t.joiningDate;
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _subjectController.dispose();
    _qualificationController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _salaryController.dispose();
    _assignedSubjectsController.dispose();
    super.dispose();
  }

  Future<void> _pickJoiningDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _joiningDate = picked);
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Future<void> _saveTeacher() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedGender == null || _joiningDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    final teacherProvider = Provider.of<TeacherProvider>(
      context,
      listen: false,
    );

    final subjectsList = _assignedSubjectsController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final data = {
      'full_name': _fullNameController.text.trim(),
      'subject': _subjectController.text.trim(),
      'qualification': _qualificationController.text.trim(),
      'phone': _phoneController.text.trim(),
      'email': _emailController.text.trim(),
      'gender': _selectedGender,
      'joining_date': _joiningDate!.toIso8601String(),
      'salary': double.tryParse(_salaryController.text.trim()) ?? 0,
      'assigned_subjects': subjectsList,
      'assigned_batch_ids': _isEditMode
          ? widget.teacherToEdit!.assignedBatchIds
          : [],
    };

    bool success;
    if (_isEditMode) {
      success = await teacherProvider.updateTeacher(
        widget.teacherToEdit!.id,
        data,
      );
    } else {
      success = await teacherProvider.addTeacher(data);
    }

    if (!mounted) return;

    if (success) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(teacherProvider.errorMessage ?? 'Something went wrong'),
        ),
      );
    }
  }

  InputDecoration _fieldDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
      filled: true,
      fillColor: const Color(0xFFEFEFEF),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, top: 14),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: Color(0xFF16305C),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final teacherProvider = Provider.of<TeacherProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF8CC2E8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF16305C)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _isEditMode ? 'Edit Teacher' : 'Add New Teacher',
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Color(0xFF16305C),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _label('Full Name:'),
              TextFormField(
                controller: _fullNameController,
                decoration: _fieldDecoration('Enter full name'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),

              _label('Subject Name:'),
              TextFormField(
                controller: _subjectController,
                decoration: _fieldDecoration('e.g. Mathematics'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),

              _label('Phone Number:'),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: _fieldDecoration('Enter number'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),

              _label('Email:'),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: _fieldDecoration('Enter email'),
              ),

              _label('Qualifications:'),
              TextFormField(
                controller: _qualificationController,
                decoration: _fieldDecoration('e.g. MSc in Applied Mathematics'),
              ),

              _label('Gender:'),
              DropdownButtonFormField<String>(
                initialValue: _selectedGender,
                decoration: _fieldDecoration('Select gender'),
                items: const [
                  DropdownMenuItem(value: 'male', child: Text('Male')),
                  DropdownMenuItem(value: 'female', child: Text('Female')),
                  DropdownMenuItem(value: 'other', child: Text('Other')),
                ],
                onChanged: (value) => setState(() => _selectedGender = value),
              ),

              _label('Assigned Subjects:'),
              TextFormField(
                controller: _assignedSubjectsController,
                decoration: _fieldDecoration(
                  'e.g. Mathematics, Statistics (comma separated)',
                ),
              ),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label('Joining Date:'),
                        InkWell(
                          onTap: _pickJoiningDate,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFEFEF),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              _joiningDate == null
                                  ? 'DD/MM/YYYY'
                                  : _formatDate(_joiningDate),
                              style: TextStyle(
                                color: _joiningDate == null
                                    ? Colors.grey
                                    : Colors.black,
                                fontSize: 13,
                              ),
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
                        _label('Salary Info (Monthly):'),
                        TextFormField(
                          controller: _salaryController,
                          keyboardType: TextInputType.number,
                          decoration: _fieldDecoration('Rs. 0'),
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Required' : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: teacherProvider.isLoading
                          ? null
                          : _saveTeacher,
                      icon: teacherProvider.isLoading
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
                              size: 18,
                            ),
                      label: Text(
                        _isEditMode ? 'Update Teacher' : 'Save Teacher',
                      ),
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
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: Colors.grey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.grey),
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
    );
  }
}
