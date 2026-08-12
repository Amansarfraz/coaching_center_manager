import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/student_provider.dart';
import '../../providers/teacher_provider.dart';
import '../../providers/batch_provider.dart';
import '../student/student_list_screen.dart';
import '../teacher/teacher_list_screen.dart';
import '../batch/batch_list_screen.dart';
import '../attendance/mark_attendance_screen.dart';
import '../attendance/attendance_history_screen.dart';

class DashboardScreen extends StatefulWidget {
  final String role;
  const DashboardScreen({super.key, required this.role});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StudentProvider>(context, listen: false).fetchStudents();
      Provider.of<TeacherProvider>(context, listen: false).fetchTeachers();
      Provider.of<BatchProvider>(context, listen: false).fetchBatches();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final studentProvider = Provider.of<StudentProvider>(context);
    final teacherProvider = Provider.of<TeacherProvider>(context);
    final batchProvider = Provider.of<BatchProvider>(context);

    final userName = authProvider.currentUser?.fullName ?? 'Admin';
    final totalStudents = studentProvider.students.length;
    final totalTeachers = teacherProvider.teachers.length;
    final totalBatches = batchProvider.batches.length;

    return Scaffold(
      backgroundColor: const Color(
        0xFFE8F3FB,
      ), // halka background (86BFE2 se lighter)
      body: RefreshIndicator(
        onRefresh: () async {
          await studentProvider.fetchStudents();
          await teacherProvider.fetchTeachers();
          await batchProvider.fetchBatches();
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // Header (86BFE2 background, black text)
            SliverToBoxAdapter(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 24),
                decoration: const BoxDecoration(
                  color: Color(0xFF86BFE2),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${widget.role} Dashboard',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.notifications_none,
                                color: Colors.black,
                              ),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.settings_outlined,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  '/settings_screen',
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Welcome Back, $userName!',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          hintText: 'Search',
                          prefixIcon: Icon(
                            Icons.search,
                            size: 20,
                            color: Colors.black54,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Body content
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Stats Cards — sirf Admin ko
                  if (widget.role.toLowerCase() == 'admin') ...[
                    _statCard(
                      icon: Icons.people_alt_outlined,
                      title: 'Total Students',
                      value: totalStudents.toString(),
                      subtitle: 'Active: $totalStudents   New: 0 this month',
                      color: const Color(0xFF2F80ED),
                    ),
                    const SizedBox(height: 12),
                    _statCard(
                      icon: Icons.school_outlined,
                      title: 'Total Teachers',
                      value: totalTeachers.toString(),
                      subtitle: 'Full-time: $totalTeachers   part-time: 0',
                      color: const Color(0xFFF2994A),
                    ),
                    const SizedBox(height: 12),
                    _statCard(
                      icon: Icons.book_outlined,
                      title: 'Total Batches',
                      value: totalBatches.toString(),
                      subtitle: 'Morning & Evening batches',
                      color: const Color(0xFF27AE60),
                    ),
                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(
                          child: _miniCard(
                            title: "Today's Attendance",
                            value: totalStudents == 0 ? '0%' : '92%',
                            subtitle: 'Present 550   Absent 200',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _miniCard(
                            title: 'Monthly Fee collection',
                            value: '\$120,500',
                            subtitle: 'Target \$140,000   Paid: 86%',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Recent Activity',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                'Detailed Chart',
                                style: TextStyle(
                                  color: Colors.blue.shade700,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _activityTile(
                            Icons.person_add_alt,
                            'New Student',
                            'Ayesha Khan joined class 9A',
                          ),
                          _activityTile(
                            Icons.badge_outlined,
                            'Teacher Profile Update',
                            'Mr. Ahmed',
                          ),
                          _activityTile(
                            Icons.groups_outlined,
                            'Batch 12',
                            'Timetable Modified',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Quick Actions
                  const Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 2.4,
                    children: _buildQuickActions(context),
                  ),

                  const SizedBox(height: 20),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- ROLE-BASED QUICK ACTIONS ----------------
  List<Widget> _buildQuickActions(BuildContext context) {
    final role = widget.role.toLowerCase();

    if (role == 'admin') {
      return [
        _quickAction(Icons.person_add_outlined, 'Add Student', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const StudentListScreen()),
          );
        }),
        _quickAction(Icons.person_add_alt_1_outlined, 'Add Teacher', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TeacherListScreen()),
          );
        }),
        _quickAction(Icons.groups_2_outlined, 'Create Batch', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const BatchListScreen()),
          );
        }),
        _quickAction(Icons.settings_outlined, 'Setting', () {
          Navigator.pushNamed(context, '/settings_screen');
        }),
        _quickAction(Icons.check_circle_outline, 'Record Attendance', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MarkAttendanceScreen()),
          );
        }),
        _quickAction(Icons.receipt_long_outlined, 'View Fees', () {}),
      ];
    } else if (role == 'teacher') {
      return [
        _quickAction(Icons.groups_2_outlined, 'My Batches', () {}),
        _quickAction(Icons.check_circle_outline, 'Record Attendance', () {}),
        _quickAction(Icons.people_alt_outlined, 'My Students', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const StudentListScreen()),
          );
        }),
        _quickAction(Icons.settings_outlined, 'Setting', () {
          Navigator.pushNamed(context, '/settings_screen');
        }),
      ];
    } else {
      return [
        _quickAction(Icons.check_circle_outline, 'My Attendance', () {}),
        _quickAction(Icons.receipt_long_outlined, 'My Fees', () {}),
        _quickAction(Icons.groups_2_outlined, 'My Batch', () {}),
        _quickAction(Icons.settings_outlined, 'Setting', () {
          Navigator.pushNamed(context, '/settings_screen');
        }),
      ];
    }
  }

  Widget _statCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
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
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF16305C),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniCard({
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
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
          Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF16305C),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _activityTile(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: const Color.fromARGB(255, 171, 208, 231),
            child: Icon(icon, size: 16, color: const Color(0xFF16305C)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickAction(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2F80ED), Color(0xFF16305C)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            _quickAction(Icons.history, 'Attendance History', () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AttendanceHistoryScreen(),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
