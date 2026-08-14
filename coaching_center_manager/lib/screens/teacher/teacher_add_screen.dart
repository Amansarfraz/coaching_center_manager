import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../constants/app_dynamic_colors.dart';
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

  Uint8List? _pickedImageBytes;
  String? _existingImageBase64;

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
      _existingImageBase64 = t.profileImage;
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

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 60,
      maxWidth: 400,
    );
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() => _pickedImageBytes = bytes);
    }
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

    String? imageBase64 = _existingImageBase64;
    if (_pickedImageBytes != null) {
      imageBase64 = base64Encode(_pickedImageBytes!);
    }

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
      'profile_image': imageBase64,
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

  InputDecoration _fieldDecoration(BuildContext context, String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: AppDynamicColors.secondaryText(context),
        fontSize: 13,
      ),
      filled: true,
      fillColor: AppDynamicColors.inputFill(context),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    );
  }

  Widget _label(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, top: 14),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: AppDynamicColors.primaryText(context),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final teacherProvider = Provider.of<TeacherProvider>(context);
    final bgColor = AppDynamicColors.scaffoldBg(context);
    final headerColor = AppDynamicColors.headerBg(context);
    final headerTextColor = AppDynamicColors.headerText(context);
    final primaryTextColor = AppDynamicColors.primaryText(context);

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
                  _isEditMode ? 'Edit Teacher' : 'Add New Teacher',
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
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: const Color(0xFFE3EEFB),
                              backgroundImage: _pickedImageBytes != null
                                  ? MemoryImage(_pickedImageBytes!)
                                  : (_existingImageBase64 != null &&
                                            _existingImageBase64!.isNotEmpty
                                        ? MemoryImage(
                                                base64Decode(
                                                  _existingImageBase64!,
                                                ),
                                              )
                                              as ImageProvider
                                        : null),
                              child:
                                  _pickedImageBytes == null &&
                                      (_existingImageBase64 == null ||
                                          _existingImageBase64!.isEmpty)
                                  ? const Icon(
                                      Icons.person,
                                      size: 50,
                                      color: Color(0xFF16305C),
                                    )
                                  : null,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF2F80ED),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    _label(context, 'Full Name:'),
                    TextFormField(
                      controller: _fullNameController,
                      style: TextStyle(color: primaryTextColor),
                      decoration: _fieldDecoration(context, 'Enter full name'),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                    ),

                    _label(context, 'Subject Name:'),
                    TextFormField(
                      controller: _subjectController,
                      style: TextStyle(color: primaryTextColor),
                      decoration: _fieldDecoration(context, 'e.g. Mathematics'),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                    ),

                    _label(context, 'Phone Number:'),
                    TextFormField(
                      controller: _phoneController,
                      style: TextStyle(color: primaryTextColor),
                      keyboardType: TextInputType.phone,
                      decoration: _fieldDecoration(context, 'Enter number'),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                    ),

                    _label(context, 'Email:'),
                    TextFormField(
                      controller: _emailController,
                      style: TextStyle(color: primaryTextColor),
                      keyboardType: TextInputType.emailAddress,
                      decoration: _fieldDecoration(context, 'Enter email'),
                    ),

                    _label(context, 'Qualifications:'),
                    TextFormField(
                      controller: _qualificationController,
                      style: TextStyle(color: primaryTextColor),
                      decoration: _fieldDecoration(
                        context,
                        'e.g. MSc in Applied Mathematics',
                      ),
                    ),

                    _label(context, 'Gender:'),
                    DropdownButtonFormField<String>(
                      value: _selectedGender,
                      dropdownColor: AppDynamicColors.cardBg(context),
                      style: TextStyle(color: primaryTextColor),
                      decoration: _fieldDecoration(context, 'Select gender'),
                      items: const [
                        DropdownMenuItem(value: 'male', child: Text('Male')),
                        DropdownMenuItem(
                          value: 'female',
                          child: Text('Female'),
                        ),
                        DropdownMenuItem(value: 'other', child: Text('Other')),
                      ],
                      onChanged: (value) =>
                          setState(() => _selectedGender = value),
                    ),

                    _label(context, 'Assigned Subjects:'),
                    TextFormField(
                      controller: _assignedSubjectsController,
                      style: TextStyle(color: primaryTextColor),
                      decoration: _fieldDecoration(
                        context,
                        'e.g. Mathematics, Statistics (comma separated)',
                      ),
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _label(context, 'Joining Date:'),
                              InkWell(
                                onTap: _pickJoiningDate,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppDynamicColors.inputFill(context),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    _joiningDate == null
                                        ? 'DD/MM/YYYY'
                                        : _formatDate(_joiningDate),
                                    style: TextStyle(
                                      color: _joiningDate == null
                                          ? AppDynamicColors.secondaryText(
                                              context,
                                            )
                                          : primaryTextColor,
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
                              _label(context, 'Salary Info (Monthly):'),
                              TextFormField(
                                controller: _salaryController,
                                style: TextStyle(color: primaryTextColor),
                                keyboardType: TextInputType.number,
                                decoration: _fieldDecoration(context, 'Rs. 0'),
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
          ),
        ],
      ),
    );
  }
}
