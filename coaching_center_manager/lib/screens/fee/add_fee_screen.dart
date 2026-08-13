import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/fee_provider.dart';
import '../../providers/student_provider.dart';
import '../../models/student_model.dart';

class AddFeeScreen extends StatefulWidget {
  const AddFeeScreen({super.key});

  @override
  State<AddFeeScreen> createState() => _AddFeeScreenState();
}

class _AddFeeScreenState extends State<AddFeeScreen> {
  StudentModel? _selectedStudent;
  String? _selectedMonth;
  final _paidAmountController = TextEditingController();
  String _paymentMethod = 'cash';
  DateTime _paymentDate = DateTime.now();
  final _remarksController = TextEditingController();

  final List<String> _months = [
    'January 2026',
    'February 2026',
    'March 2026',
    'April 2026',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StudentProvider>(context, listen: false).fetchStudents();
    });
  }

  Future<void> _pickStudent() async {
    final studentProvider = Provider.of<StudentProvider>(
      context,
      listen: false,
    );
    final selected = await showModalBottomSheet<StudentModel>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(16),
          children: studentProvider.students
              .map(
                (s) => ListTile(
                  title: Text(s.fullName),
                  subtitle: Text(s.batchName),
                  onTap: () => Navigator.pop(context, s),
                ),
              )
              .toList(),
        ),
      ),
    );
    if (selected != null) setState(() => _selectedStudent = selected);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _paymentDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _paymentDate = picked);
  }

  Future<void> _savePayment() async {
    if (_selectedStudent == null ||
        _selectedMonth == null ||
        _paidAmountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    final feeProvider = Provider.of<FeeProvider>(context, listen: false);

    final totalFee = _selectedStudent!.monthlyFee;
    final paid = double.tryParse(_paidAmountController.text.trim()) ?? 0;

    final data = {
      'student_id': _selectedStudent!.id,
      'student_name': _selectedStudent!.fullName,
      'batch_id': _selectedStudent!.batchId,
      'batch_name': _selectedStudent!.batchName,
      'fee_month': _selectedMonth,
      'total_fee': totalFee,
      'paid_amount': paid,
      'payment_method': _paymentMethod,
      'payment_date': _paymentDate.toIso8601String(),
      'remarks': _remarksController.text.trim(),
    };

    final success = await feeProvider.addFeePayment(data);

    if (!mounted) return;

    if (success) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(feeProvider.errorMessage ?? 'Failed to save payment'),
        ),
      );
    }
  }

  Widget _methodButton(String value, String label, IconData icon) {
    final isSelected = _paymentMethod == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _paymentMethod = value),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF16305C) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF16305C)
                  : Colors.grey.shade300,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? Colors.white : Colors.black54,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final feeProvider = Provider.of<FeeProvider>(context);
    final totalFee = _selectedStudent?.monthlyFee ?? 0;
    final paid = double.tryParse(_paidAmountController.text.trim()) ?? 0;
    final remaining = totalFee - paid;

    return Scaffold(
      backgroundColor: const Color(0xFFE8F3FB),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
            decoration: const BoxDecoration(color: Color(0xFF16305C)),
            child: Row(
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                const SizedBox(width: 14),
                const Text(
                  'Add Fee Payment',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: _pickStudent,
                    child: Container(
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
                          const Icon(Icons.search, color: Colors.grey),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _selectedStudent?.fullName ?? 'Select Student',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    'Fee Month',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: Color(0xFF16305C),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedMonth,
                        hint: const Text('Select month'),
                        isExpanded: true,
                        items: _months
                            .map(
                              (m) => DropdownMenuItem(value: m, child: Text(m)),
                            )
                            .toList(),
                        onChanged: (v) => setState(() => _selectedMonth = v),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2F80ED),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Total Fee',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.white70,
                                ),
                              ),
                              Text(
                                'Rs.${totalFee.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              const Text(
                                'Based on student profile',
                                style: TextStyle(
                                  fontSize: 9,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Enter Paid Amount',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: Color(0xFF16305C),
                              ),
                            ),
                            const SizedBox(height: 6),
                            TextField(
                              controller: _paidAmountController,
                              keyboardType: TextInputType.number,
                              onChanged: (_) => setState(() {}),
                              decoration: InputDecoration(
                                hintText: 'Rs.0',
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                  Text(
                    'Remaining Balance: Rs.${remaining.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: Color(0xFFEB5757),
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Text(
                    'Payment Method',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: Color(0xFF16305C),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _methodButton('cash', 'Cash', Icons.money),
                      _methodButton(
                        'bank',
                        'Online Transfer',
                        Icons.account_balance,
                      ),
                      _methodButton(
                        'jazzcash',
                        'JazzCash/EasyPaisa',
                        Icons.phone_android,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  const Text(
                    'Payment Date',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: Color(0xFF16305C),
                    ),
                  ),
                  const SizedBox(height: 6),
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
                            size: 16,
                            color: Color(0xFF16305C),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${_paymentDate.day}/${_paymentDate.month}/${_paymentDate.year}',
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Text(
                    'Remarks (Optional)',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: Color(0xFF16305C),
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _remarksController,
                    decoration: InputDecoration(
                      hintText: 'Any additional notes',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: feeProvider.isLoading ? null : _savePayment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF16305C),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: feeProvider.isLoading
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Save Payment'),
                    ),
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
}
