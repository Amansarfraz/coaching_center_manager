import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_dynamic_colors.dart';
import '../../providers/batch_provider.dart';
import '../../providers/student_provider.dart';
import '../../models/batch_model.dart';
import 'batch_add_screen.dart';
import 'batch_details_screen.dart';

class BatchListScreen extends StatefulWidget {
  const BatchListScreen({super.key});

  @override
  State<BatchListScreen> createState() => _BatchListScreenState();
}

class _BatchListScreenState extends State<BatchListScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BatchProvider>(context, listen: false).fetchBatches();
      Provider.of<StudentProvider>(context, listen: false).fetchStudents();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  int _studentCountForBatch(BatchModel batch, StudentProvider studentProvider) {
    return studentProvider.students.where((s) => s.batchId == batch.id).length;
  }

  @override
  Widget build(BuildContext context) {
    final batchProvider = Provider.of<BatchProvider>(context);
    final studentProvider = Provider.of<StudentProvider>(context);

    final bgColor = AppDynamicColors.scaffoldBg(context);
    final headerColor = AppDynamicColors.headerBg(context);
    final cardColor = AppDynamicColors.cardBg(context);
    final headerTextColor = AppDynamicColors.headerText(context);
    final primaryTextColor = AppDynamicColors.primaryText(context);
    final secondaryTextColor = AppDynamicColors.secondaryText(context);
    final inputFillColor = AppDynamicColors.inputFill(context);

    final batches = _searchQuery.isEmpty
        ? batchProvider.batches
        : batchProvider.batches.where((b) {
            final q = _searchQuery.toLowerCase();
            return b.batchName.toLowerCase().contains(q) ||
                b.teacherName.toLowerCase().contains(q);
          }).toList();

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
            decoration: BoxDecoration(color: headerColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
                        const SizedBox(width: 16),
                        Text(
                          'Batch',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 22,
                            color: headerTextColor,
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const BatchAddScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: cardColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Color(0xFF16305C),
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: Text(
                    '${batchProvider.batches.length} Total Batches',
                    style: TextStyle(
                      fontSize: 13,
                      color: headerTextColor.withOpacity(0.85),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: inputFillColor,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                style: TextStyle(color: primaryTextColor),
                onChanged: (value) => setState(() => _searchQuery = value),
                decoration: InputDecoration(
                  hintText: 'Search by Batch Name, Teacher',
                  hintStyle: TextStyle(fontSize: 13, color: secondaryTextColor),
                  prefixIcon: Icon(
                    Icons.search,
                    size: 20,
                    color: secondaryTextColor,
                  ),
                  suffixIcon: const Icon(
                    Icons.tune,
                    size: 20,
                    color: Color(0xFF16305C),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),

          Expanded(
            child: batchProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : batches.isEmpty
                ? Center(
                    child: Text(
                      'No batches found',
                      style: TextStyle(color: secondaryTextColor),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () => batchProvider.fetchBatches(),
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: batches.length,
                      itemBuilder: (context, index) {
                        final batch = batches[index];
                        final studentCount = _studentCountForBatch(
                          batch,
                          studentProvider,
                        );
                        return _batchCard(
                          context,
                          batch,
                          studentCount,
                          batchProvider,
                          cardColor,
                          primaryTextColor,
                          secondaryTextColor,
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _batchCard(
    BuildContext context,
    BatchModel batch,
    int studentCount,
    BatchProvider provider,
    Color cardColor,
    Color primaryTextColor,
    Color secondaryTextColor,
  ) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => BatchDetailsScreen(batch: batch)),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
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
                Expanded(
                  child: Text(
                    'Batch Name',
                    style: TextStyle(fontSize: 11, color: secondaryTextColor),
                  ),
                ),
                _cardIcon(Icons.edit, const Color(0xFF2F80ED), () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BatchAddScreen(batchToEdit: batch),
                    ),
                  );
                }),
                const SizedBox(width: 6),
                _cardIcon(Icons.notifications, const Color(0xFFF2994A), () {}),
                const SizedBox(width: 6),
                _cardIcon(
                  Icons.delete,
                  const Color(0xFFEB5757),
                  () => _confirmDelete(context, batch, provider),
                ),
              ],
            ),
            Text(
              batch.batchName,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 18,
                color: primaryTextColor,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Assigned Teacher',
                        style: TextStyle(
                          fontSize: 11,
                          color: secondaryTextColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        batch.teacherName,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: primaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Couse Name',
                        style: TextStyle(
                          fontSize: 11,
                          color: secondaryTextColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        batch.courseName,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: primaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Timing',
                        style: TextStyle(
                          fontSize: 11,
                          color: secondaryTextColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        batch.timing,
                        style: TextStyle(fontSize: 13, color: primaryTextColor),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'No. of Students',
                        style: TextStyle(
                          fontSize: 11,
                          color: secondaryTextColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$studentCount students',
                        style: TextStyle(fontSize: 13, color: primaryTextColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardIcon(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 14, color: Colors.white),
      ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    BatchModel batch,
    BatchProvider provider,
  ) {
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
              Navigator.pop(context);
              await provider.deleteBatch(batch.id);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
