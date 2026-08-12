import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/batch_provider.dart';
import '../../models/batch_model.dart';
import 'batch_add_screen.dart';
import 'batch_details_screen.dart';

class BatchListScreen extends StatefulWidget {
  const BatchListScreen({super.key});

  @override
  State<BatchListScreen> createState() => _BatchListScreenState();
}

class _BatchListScreenState extends State<BatchListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BatchProvider>(context, listen: false).fetchBatches();
    });
  }

  @override
  Widget build(BuildContext context) {
    final batchProvider = Provider.of<BatchProvider>(context);
    final batches = batchProvider.batches;

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
                const Text(
                  'Batch List',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 22,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: batchProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : batches.isEmpty
                ? const Center(
                    child: Text(
                      'No batches found',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () => batchProvider.fetchBatches(),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: batches.length,
                      itemBuilder: (context, index) {
                        final batch = batches[index];
                        return _batchCard(context, batch, batchProvider);
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF16305C),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Add Batch',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const BatchAddScreen()),
          );
        },
      ),
    );
  }

  Widget _batchCard(
    BuildContext context,
    BatchModel batch,
    BatchProvider provider,
  ) {
    final progress = batch.studentCapacity == 0
        ? 0.0
        : batch.totalStudents / batch.studentCapacity;

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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
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
                    batch.batchName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 17,
                      color: Color(0xFF16305C),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: batch.status == 'active'
                        ? const Color(0xFFE7F8EE)
                        : const Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    batch.status,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: batch.status == 'active'
                          ? const Color(0xFF27AE60)
                          : const Color(0xFFF2994A),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Course: ${batch.courseName}',
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(
                  Icons.person_outline,
                  size: 16,
                  color: Color(0xFF2F80ED),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Teacher: ${batch.teacherName}',
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(
                  Icons.access_time,
                  size: 16,
                  color: Colors.deepPurple,
                ),
                const SizedBox(width: 6),
                Text(batch.timing, style: const TextStyle(fontSize: 13)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(
                  Icons.class_outlined,
                  size: 16,
                  color: Colors.orange,
                ),
                const SizedBox(width: 6),
                Text(
                  'Room: ${batch.classroom}',
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                minHeight: 8,
                backgroundColor: const Color(0xFFEFEFEF),
                color: const Color(0xFF2F80ED),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${batch.totalStudents}/${batch.studentCapacity} students',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
