import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_dynamic_colors.dart';
import '../../providers/batch_provider.dart';
import '../../providers/teacher_provider.dart';
import '../../models/batch_model.dart';

class BatchAddScreen extends StatefulWidget {
  final BatchModel? batchToEdit;
  const BatchAddScreen({super.key, this.batchToEdit});

  @override
  State<BatchAddScreen> createState() => _BatchAddScreenState();
}

class _BatchAddScreenState extends State<BatchAddScreen> {
  final _formKey = GlobalKey<FormState>();

  final _batchNameController = TextEditingController();
  final _courseNameController = TextEditingController();
  final _classroomController = TextEditingController();
  final _timingController = TextEditingController();
  final _capacityController = TextEditingController();

  String? _selectedTeacherId;
  DateTime? _startDate;
  DateTime? _endDate;

  bool get _isEditMode => widget.batchToEdit != null;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TeacherProvider>(context, listen: false).fetchTeachers();
    });

    if (_isEditMode) {
      final b = widget.batchToEdit!;
      _batchNameController.text = b.batchName;
      _courseNameController.text = b.courseName;
      _classroomController.text = b.classroom;
      _timingController.text = b.timing;
      _capacityController.text = b.studentCapacity.toString();
      _selectedTeacherId = b.teacherId;
      _startDate = b.startDate;
      _endDate = b.endDate;
    }
  }

  @override
  void dispose() {
    _batchNameController.dispose();
    _courseNameController.dispose();
    _classroomController.dispose();
    _timingController.dispose();
    _capacityController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isStart}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Future<void> _saveBatch() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedTeacherId == null || _startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select teacher and start date')),
      );
      return;
    }

    final batchProvider = Provider.of<BatchProvider>(context, listen: false);
    final teacherProvider = Provider.of<TeacherProvider>(
      context,
      listen: false,
    );
    final selectedTeacher = teacherProvider.teachers.firstWhere(
      (t) => t.id == _selectedTeacherId,
    );

    final data = {
      'batch_name': _batchNameController.text.trim(),
      'course_name': _courseNameController.text.trim(),
      'teacher_id': _selectedTeacherId,
      'teacher_name': selectedTeacher.fullName,
      'classroom': _classroomController.text.trim(),
      'timing': _timingController.text.trim(),
      'student_capacity': int.tryParse(_capacityController.text.trim()) ?? 0,
      'start_date': _startDate!.toIso8601String(),
      'end_date': _endDate?.toIso8601String(),
    };

    bool success;
    if (_isEditMode) {
      success = await batchProvider.updateBatch(widget.batchToEdit!.id, data);
    } else {
      success = await batchProvider.addBatch(data);
    }

    if (!mounted) return;

    if (success) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(batchProvider.errorMessage ?? 'Something went wrong'),
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
    final batchProvider = Provider.of<BatchProvider>(context);
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
                  _isEditMode ? 'Edit Batch' : 'Add New Batch',
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
                    _label(context, 'Batch Name:'),
                    TextFormField(
                      controller: _batchNameController,
                      style: TextStyle(color: primaryTextColor),
                      decoration: _fieldDecoration(context, 'Enter Batch Name'),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                    ),

                    _label(context, 'Course Name:'),
                    TextFormField(
                      controller: _courseNameController,
                      style: TextStyle(color: primaryTextColor),
                      decoration: _fieldDecoration(
                        context,
                        'Enter Course Name',
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                    ),

                    _label(context, 'Teacher:'),
                    teacherProvider.isLoading
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: LinearProgressIndicator(),
                          )
                        : teacherProvider.teachers.isEmpty
                        ? Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppDynamicColors.inputFill(context),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'No teachers available. Please add a teacher first.',
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          )
                        : DropdownButtonFormField<String>(
                            value: _selectedTeacherId,
                            dropdownColor: AppDynamicColors.cardBg(context),
                            style: TextStyle(color: primaryTextColor),
                            decoration: _fieldDecoration(
                              context,
                              'Select Teacher',
                            ),
                            isExpanded: true,
                            items: teacherProvider.teachers
                                .map(
                                  (t) => DropdownMenuItem(
                                    value: t.id,
                                    child: Text(t.fullName),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) =>
                                setState(() => _selectedTeacherId = value),
                          ),

                    _label(context, 'Class Room:'),
                    TextFormField(
                      controller: _classroomController,
                      style: TextStyle(color: primaryTextColor),
                      decoration: _fieldDecoration(
                        context,
                        'Enter Class Room e.g. A1',
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                    ),

                    _label(context, 'Batch Timing:'),
                    TextFormField(
                      controller: _timingController,
                      style: TextStyle(color: primaryTextColor),
                      decoration: _fieldDecoration(
                        context,
                        'Select Timing (e.g. M-W-F 10-12)',
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                    ),

                    _label(context, 'Student Capacity:'),
                    TextFormField(
                      controller: _capacityController,
                      style: TextStyle(color: primaryTextColor),
                      keyboardType: TextInputType.number,
                      decoration: _fieldDecoration(
                        context,
                        'Enter Capacity (e.g. 50)',
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                    ),

                    _label(context, 'Start Date:'),
                    InkWell(
                      onTap: () => _pickDate(isStart: true),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: AppDynamicColors.inputFill(context),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          _startDate == null
                              ? 'Select Start Date'
                              : _formatDate(_startDate),
                          style: TextStyle(
                            color: _startDate == null
                                ? AppDynamicColors.secondaryText(context)
                                : primaryTextColor,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),

                    _label(context, 'End Date:'),
                    InkWell(
                      onTap: () => _pickDate(isStart: false),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: AppDynamicColors.inputFill(context),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          _endDate == null
                              ? 'Select End Date'
                              : _formatDate(_endDate),
                          style: TextStyle(
                            color: _endDate == null
                                ? AppDynamicColors.secondaryText(context)
                                : primaryTextColor,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: batchProvider.isLoading
                                ? null
                                : _saveBatch,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2F80ED),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: batchProvider.isLoading
                                ? const SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    _isEditMode ? 'Update Batch' : 'Save Batch',
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
