import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../providers/student_provider.dart';
import '../../models/student_model.dart';

class StudentAddScreen extends StatefulWidget {
  final StudentModel? studentToEdit;
  const StudentAddScreen({super.key, this.studentToEdit});

  @override
  State<StudentAddScreen> createState() => _StudentAddScreenState();
}

class _StudentAddScreenState extends State<StudentAddScreen> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _monthlyFeeController = TextEditingController();
  final _batchNameController =
      TextEditingController(); // TEMPORARY - Batch module ban jaye to hata dena

  String? _selectedGender;
  DateTime? _dob;
  DateTime? _admissionDate;

  Uint8List? _pickedImageBytes;
  String? _existingImageBase64;

  bool get _isEditMode => widget.studentToEdit != null;

  @override
  void initState() {
    super.initState();

    if (_isEditMode) {
      final s = widget.studentToEdit!;
      _fullNameController.text = s.fullName;
      _fatherNameController.text = s.fatherName;
      _phoneController.text = s.phone;
      _emailController.text = s.email;
      _addressController.text = s.homeAddress;
      _monthlyFeeController.text = s.monthlyFee.toString();
      _batchNameController.text = s.batchName;
      _selectedGender = s.gender;
      _dob = s.dob;
      _admissionDate = s.admissionDate;
      _existingImageBase64 = s.profileImage;
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _fatherNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _monthlyFeeController.dispose();
    _batchNameController.dispose();
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
      setState(() {
        _pickedImageBytes = bytes;
      });
    }
  }

  Future<void> _pickDate({required bool isDob}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isDob) {
          _dob = picked;
        } else {
          _admissionDate = picked;
        }
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year.toString().substring(2)}';
  }

  Future<void> _saveStudent() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedGender == null || _dob == null || _admissionDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    final studentProvider = Provider.of<StudentProvider>(
      context,
      listen: false,
    );
    final batchNameValue = _batchNameController.text.trim();

    String? imageBase64 = _existingImageBase64;
    if (_pickedImageBytes != null) {
      imageBase64 = base64Encode(_pickedImageBytes!);
    }

    final data = {
      'full_name': _fullNameController.text.trim(),
      'father_name': _fatherNameController.text.trim(),
      'phone': _phoneController.text.trim(),
      'email': _emailController.text.trim(),
      'home_address': _addressController.text.trim(),
      'gender': _selectedGender,
      'dob': _dob!.toIso8601String(),
      'admission_date': _admissionDate!.toIso8601String(),
      'batch_id': batchNameValue,
      'batch_name': batchNameValue,
      'monthly_fee': double.tryParse(_monthlyFeeController.text.trim()) ?? 0,
      'profile_image': imageBase64,
    };

    bool success;
    if (_isEditMode) {
      success = await studentProvider.updateStudent(
        widget.studentToEdit!.id,
        data,
      );
    } else {
      success = await studentProvider.addStudent(data);
    }

    if (!mounted) return;

    if (success) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(studentProvider.errorMessage ?? 'Something went wrong'),
        ),
      );
    }
  }

  InputDecoration _fieldDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
      filled: true,
      fillColor: Colors.white,
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
    final studentProvider = Provider.of<StudentProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFE8F3FB),
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
            decoration: const BoxDecoration(
              color: Color(0xFF86BFE2),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: Row(
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(30),
                  child: const CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Text(
                  _isEditMode ? 'Edit Student' : 'Add New Student',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                    color: Colors.black,
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
                    // Profile Photo Picker
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

                    _label('Full Name:'),
                    TextFormField(
                      controller: _fullNameController,
                      decoration: _fieldDecoration('Enter full name'),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                    ),

                    _label("Father's Name:"),
                    TextFormField(
                      controller: _fatherNameController,
                      decoration: _fieldDecoration('Enter father name'),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                    ),

                    _label('Phone Number:'),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: _fieldDecoration('Enter number'),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                    ),

                    _label('Email:'),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: _fieldDecoration('Enter email'),
                    ),

                    _label('Home Address:'),
                    TextFormField(
                      controller: _addressController,
                      decoration: _fieldDecoration('Enter address'),
                    ),

                    _label('Gender:'),
                    DropdownButtonFormField<String>(
                      value: _selectedGender,
                      decoration: _fieldDecoration('Select gender'),
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

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _label('DOB:'),
                              InkWell(
                                onTap: () => _pickDate(isDob: true),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    _dob == null
                                        ? 'DD/MM/YY'
                                        : _formatDate(_dob),
                                    style: TextStyle(
                                      color: _dob == null
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
                              _label('Admission Date:'),
                              InkWell(
                                onTap: () => _pickDate(isDob: false),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    _admissionDate == null
                                        ? 'DD/MM/YY'
                                        : _formatDate(_admissionDate),
                                    style: TextStyle(
                                      color: _admissionDate == null
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
                      ],
                    ),

                    _label(
                      'Batch Name: (temporary text field — Batch module baad mein aayega)',
                    ),
                    TextFormField(
                      controller: _batchNameController,
                      decoration: _fieldDecoration('e.g. Batch-A Morning'),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                    ),

                    _label('Monthly Fee:'),
                    TextFormField(
                      controller: _monthlyFeeController,
                      keyboardType: TextInputType.number,
                      decoration: _fieldDecoration('Monthly fee'),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                    ),

                    const SizedBox(height: 30),

                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: studentProvider.isLoading
                                ? null
                                : _saveStudent,
                            icon: studentProvider.isLoading
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
                              _isEditMode ? 'Update Student' : 'Save Student',
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
