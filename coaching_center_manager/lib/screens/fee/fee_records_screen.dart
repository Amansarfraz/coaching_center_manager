import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_dynamic_colors.dart';
import '../../providers/fee_provider.dart';
import '../../models/fee_model.dart';
import 'add_fee_screen.dart';

class FeeRecordsScreen extends StatefulWidget {
  const FeeRecordsScreen({super.key});

  @override
  State<FeeRecordsScreen> createState() => _FeeRecordsScreenState();
}

class _FeeRecordsScreenState extends State<FeeRecordsScreen> {
  final _searchController = TextEditingController();
  String? _selectedMonth;

  final List<String> _months = ['All', 'Jan 2026', 'Feb 2026', 'Mar 2026'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FeeProvider>(context, listen: false).fetchFeeRecords();
    });
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'paid':
        return const Color(0xFF27AE60);
      case 'partial':
        return const Color(0xFFF2994A);
      default:
        return const Color(0xFFEB5757);
    }
  }

  @override
  Widget build(BuildContext context) {
    final feeProvider = Provider.of<FeeProvider>(context);

    final bgColor = AppDynamicColors.scaffoldBg(context);
    final primaryTextColor = AppDynamicColors.primaryText(context);
    final secondaryTextColor = AppDynamicColors.secondaryText(context);
    final cardColor = AppDynamicColors.cardBg(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final headerColor = isDark
        ? const Color(0xFF0D1E33)
        : const Color(0xFF16305C);

    final records = feeProvider.feeRecords.where((f) {
      final q = _searchController.text.toLowerCase();
      if (q.isEmpty) return true;
      return f.studentName.toLowerCase().contains(q) ||
          f.batchName.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
            decoration: BoxDecoration(color: headerColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const SizedBox(width: 14),
                    const Text(
                      'Fee Records',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                CircleAvatar(
                  radius: 16,
                  backgroundColor: cardColor,
                  child: Icon(Icons.person, size: 18, color: headerColor),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                controller: _searchController,
                style: TextStyle(color: primaryTextColor),
                onChanged: (v) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Search Student or Batch',
                  hintStyle: TextStyle(color: secondaryTextColor),
                  prefixIcon: Icon(Icons.search, color: secondaryTextColor),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _months.length,
              itemBuilder: (context, i) {
                final month = _months[i];
                final isSelected = (_selectedMonth ?? 'All') == month;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(month, style: const TextStyle(fontSize: 12)),
                    selected: isSelected,
                    selectedColor: const Color(0xFF2F80ED),
                    backgroundColor: cardColor,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : primaryTextColor,
                    ),
                    onSelected: (_) {
                      setState(
                        () => _selectedMonth = month == 'All' ? null : month,
                      );
                      feeProvider.fetchFeeRecords(month: _selectedMonth);
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: feeProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : records.isEmpty
                ? Center(
                    child: Text(
                      'No fee records found',
                      style: TextStyle(color: secondaryTextColor),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: records.length,
                    itemBuilder: (context, index) => _feeCard(
                      context,
                      records[index],
                      cardColor,
                      primaryTextColor,
                      secondaryTextColor,
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddFeeScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: headerColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text('Add Payment'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _feeCard(
    BuildContext context,
    FeeModel fee,
    Color cardColor,
    Color primaryTextColor,
    Color secondaryTextColor,
  ) {
    final progress = fee.totalFee == 0 ? 0.0 : fee.paidAmount / fee.totalFee;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Row(
        children: [
          SizedBox(
            height: 50,
            width: 50,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: progress.clamp(0, 1),
                  strokeWidth: 5,
                  color: _statusColor(fee.status),
                  backgroundColor: const Color(0xFFEFEFEF),
                ),
                Text(
                  '${(progress * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: primaryTextColor,
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
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        fee.studentName,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: primaryTextColor,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: _statusColor(fee.status),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        fee.status[0].toUpperCase() + fee.status.substring(1),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  'Batch: ${fee.batchName}',
                  style: TextStyle(fontSize: 12, color: secondaryTextColor),
                ),
                const SizedBox(height: 4),
                Text(
                  'Total Fee: Rs.${fee.totalFee.toStringAsFixed(0)}',
                  style: TextStyle(fontSize: 12, color: primaryTextColor),
                ),
                Text(
                  'Remaining: Rs.${fee.remainingBalance.toStringAsFixed(0)}',
                  style: TextStyle(fontSize: 12, color: primaryTextColor),
                ),
                Text(
                  'Payment Date: ${fee.paymentDate.day}/${fee.paymentDate.month}/${fee.paymentDate.year}',
                  style: TextStyle(fontSize: 11, color: secondaryTextColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
