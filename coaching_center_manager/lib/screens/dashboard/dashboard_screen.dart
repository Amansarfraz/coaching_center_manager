import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_dynamic_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/student_provider.dart';
import '../../providers/teacher_provider.dart';
import '../../providers/batch_provider.dart';
import '../../providers/dashboard_provider.dart';
import '../../providers/notification_provider.dart';
import '../student/student_list_screen.dart';
import '../teacher/teacher_list_screen.dart';
import '../batch/batch_list_screen.dart';
import '../attendance/mark_attendance_screen.dart';
import '../attendance/attendance_history_screen.dart';
import '../fee/fee_records_screen.dart';

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
      Provider.of<DashboardProvider>(context, listen: false).fetchSummary();
      Provider.of<NotificationProvider>(
        context,
        listen: false,
      ).fetchNotifications(widget.role.toLowerCase());
    });
  }

  Future<void> _refreshAll(BuildContext context) async {
    await Provider.of<StudentProvider>(context, listen: false).fetchStudents();
    await Provider.of<TeacherProvider>(context, listen: false).fetchTeachers();
    await Provider.of<BatchProvider>(context, listen: false).fetchBatches();
    await Provider.of<DashboardProvider>(context, listen: false).fetchSummary();
    await Provider.of<NotificationProvider>(
      context,
      listen: false,
    ).fetchNotifications(widget.role.toLowerCase());
  }

  IconData _activityIcon(String type) {
    switch (type) {
      case 'student':
        return Icons.person_add_alt;
      case 'teacher':
        return Icons.badge_outlined;
      case 'batch':
        return Icons.groups_outlined;
      default:
        return Icons.notifications_none;
    }
  }

  void _showNotifications(
    BuildContext context,
    NotificationProvider notifProvider,
  ) {
    final cardColor = AppDynamicColors.cardBg(context);
    final textColor = AppDynamicColors.primaryText(context);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: cardColor,
        child: Container(
          constraints: const BoxConstraints(maxHeight: 420),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Notifications',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                      color: textColor,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, size: 20, color: textColor),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              Flexible(
                child: notifProvider.notifications.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 30),
                        child: Center(
                          child: Text(
                            'No notifications yet',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: notifProvider.notifications.length,
                        itemBuilder: (context, index) {
                          final n = notifProvider.notifications[index];
                          final isRead = n['is_read'] == true;
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isRead
                                  ? Colors.transparent
                                  : const Color(0xFFE3EEFB).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 18,
                                  backgroundColor: isRead
                                      ? Colors.grey.shade200
                                      : Colors.white,
                                  child: Icon(
                                    _activityIcon(n['related_type'] ?? ''),
                                    size: 16,
                                    color: const Color(0xFF16305C),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        n['title'] ?? '',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13,
                                          color: textColor,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        n['message'] ?? '',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: textColor.withOpacity(0.8),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
              if (notifProvider.notifications.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        notifProvider.markAllRead(widget.role.toLowerCase());
                        Navigator.pop(context);
                      },
                      child: const Text('Mark all as read'),
                    ),
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
    final authProvider = Provider.of<AuthProvider>(context);
    final studentProvider = Provider.of<StudentProvider>(context);
    final teacherProvider = Provider.of<TeacherProvider>(context);
    final batchProvider = Provider.of<BatchProvider>(context);
    final dashboardProvider = Provider.of<DashboardProvider>(context);
    final notifProvider = Provider.of<NotificationProvider>(context);

    final userName = authProvider.currentUser?.fullName ?? 'Admin';
    final totalStudents = studentProvider.students.length;
    final totalTeachers = teacherProvider.teachers.length;
    final totalBatches = batchProvider.batches.length;

    final bgColor = AppDynamicColors.scaffoldBg(context);
    final headerColor = AppDynamicColors.headerBg(context);
    final cardColor = AppDynamicColors.cardBg(context);
    final headerTextColor = AppDynamicColors.headerText(context);
    final primaryTextColor = AppDynamicColors.primaryText(context);
    final secondaryTextColor = AppDynamicColors.secondaryText(context);

    return Scaffold(
      backgroundColor: bgColor,
      body: RefreshIndicator(
        onRefresh: () => _refreshAll(context),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 24),
                decoration: BoxDecoration(
                  color: headerColor,
                  borderRadius: const BorderRadius.only(
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
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: headerTextColor,
                          ),
                        ),
                        Row(
                          children: [
                            Stack(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.notifications_none,
                                    color: headerTextColor,
                                  ),
                                  onPressed: () => _showNotifications(
                                    context,
                                    notifProvider,
                                  ),
                                ),
                                if (notifProvider.unreadCount > 0)
                                  Positioned(
                                    right: 6,
                                    top: 6,
                                    child: Container(
                                      padding: const EdgeInsets.all(3),
                                      constraints: const BoxConstraints(
                                        minWidth: 16,
                                        minHeight: 16,
                                      ),
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        '${notifProvider.unreadCount}',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 9,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.settings_outlined,
                                color: headerTextColor,
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
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: headerTextColor.withOpacity(0.85),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextField(
                        style: TextStyle(color: primaryTextColor),
                        decoration: InputDecoration(
                          hintText: 'Search',
                          hintStyle: TextStyle(color: secondaryTextColor),
                          prefixIcon: Icon(
                            Icons.search,
                            size: 20,
                            color: secondaryTextColor,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  if (widget.role.toLowerCase() == 'admin') ...[
                    _statCard(
                      context: context,
                      icon: Icons.people_alt_outlined,
                      title: 'Total Students',
                      value: totalStudents.toString(),
                      subtitle: 'Active: $totalStudents',
                      color: const Color(0xFF2F80ED),
                    ),
                    const SizedBox(height: 12),
                    _statCard(
                      context: context,
                      icon: Icons.school_outlined,
                      title: 'Total Teachers',
                      value: totalTeachers.toString(),
                      subtitle: 'Registered: $totalTeachers',
                      color: const Color(0xFFF2994A),
                    ),
                    const SizedBox(height: 12),
                    _statCard(
                      context: context,
                      icon: Icons.book_outlined,
                      title: 'Total Batches',
                      value: totalBatches.toString(),
                      subtitle: 'Running: $totalBatches',
                      color: const Color(0xFF27AE60),
                    ),
                    const SizedBox(height: 20),

                    if (dashboardProvider.isLoading)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else
                      Row(
                        children: [
                          Expanded(
                            child: _miniCard(
                              context: context,
                              title: "Today's Attendance",
                              value:
                                  '${dashboardProvider.attendancePercentage.toStringAsFixed(0)}%',
                              subtitle:
                                  'Present ${dashboardProvider.attendancePresent}   Absent ${dashboardProvider.attendanceAbsent}',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _miniCard(
                              context: context,
                              title: 'Monthly Fee Collection',
                              value:
                                  'Rs.${dashboardProvider.feePaid.toStringAsFixed(0)}',
                              subtitle:
                                  'Target Rs.${dashboardProvider.feeTarget.toStringAsFixed(0)}   Paid: ${dashboardProvider.feePercentage.toStringAsFixed(0)}%',
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 20),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardColor,
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
                          Text(
                            'Recent Activity',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              color: primaryTextColor,
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (dashboardProvider.recentActivity.isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Text(
                                'No recent activity yet',
                                style: TextStyle(
                                  color: secondaryTextColor,
                                  fontSize: 13,
                                ),
                              ),
                            )
                          else
                            ...dashboardProvider.recentActivity.map((activity) {
                              return _activityTile(
                                context,
                                _activityIcon(activity['type']),
                                activity['title'],
                                activity['subtitle'],
                              );
                            }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: primaryTextColor,
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
        _quickAction(Icons.person_add_outlined, 'Students', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const StudentListScreen()),
          );
        }),
        _quickAction(Icons.person_add_alt_1_outlined, 'Teachers', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TeacherListScreen()),
          );
        }),
        _quickAction(Icons.groups_2_outlined, 'Batches', () {
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
        _quickAction(Icons.history, 'Attendance History', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AttendanceHistoryScreen()),
          );
        }),
        _quickAction(Icons.receipt_long_outlined, 'Fee Records', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FeeRecordsScreen()),
          );
        }),
      ];
    } else if (role == 'teacher') {
      return [
        _quickAction(Icons.groups_2_outlined, 'My Batches', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const BatchListScreen()),
          );
        }),
        _quickAction(Icons.check_circle_outline, 'Record Attendance', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MarkAttendanceScreen()),
          );
        }),
        _quickAction(Icons.people_alt_outlined, 'My Students', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const StudentListScreen()),
          );
        }),
        _quickAction(Icons.history, 'Attendance History', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AttendanceHistoryScreen()),
          );
        }),
        _quickAction(Icons.settings_outlined, 'Setting', () {
          Navigator.pushNamed(context, '/settings_screen');
        }),
      ];
    } else {
      return [
        _quickAction(Icons.check_circle_outline, 'My Attendance', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AttendanceHistoryScreen()),
          );
        }),
        _quickAction(Icons.receipt_long_outlined, 'My Fees', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FeeRecordsScreen()),
          );
        }),
        _quickAction(Icons.groups_2_outlined, 'My Batch', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const BatchListScreen()),
          );
        }),
        _quickAction(Icons.settings_outlined, 'Setting', () {
          Navigator.pushNamed(context, '/settings_screen');
        }),
      ];
    }
  }

  Widget _statCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    final cardColor = AppDynamicColors.cardBg(context);
    final primaryTextColor = AppDynamicColors.primaryText(context);
    final secondaryTextColor = AppDynamicColors.secondaryText(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
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
                  style: TextStyle(fontSize: 13, color: secondaryTextColor),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: primaryTextColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 11, color: secondaryTextColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniCard({
    required BuildContext context,
    required String title,
    required String value,
    required String subtitle,
  }) {
    final cardColor = AppDynamicColors.cardBg(context);
    final primaryTextColor = AppDynamicColors.primaryText(context);
    final secondaryTextColor = AppDynamicColors.secondaryText(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
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
          Text(
            title,
            style: TextStyle(fontSize: 11, color: secondaryTextColor),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: primaryTextColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(fontSize: 10, color: secondaryTextColor),
          ),
        ],
      ),
    );
  }

  Widget _activityTile(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
  ) {
    final primaryTextColor = AppDynamicColors.primaryText(context);
    final secondaryTextColor = AppDynamicColors.secondaryText(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: const Color(0xFFE3EEFB),
            child: Icon(icon, size: 16, color: const Color(0xFF16305C)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: primaryTextColor,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 11, color: secondaryTextColor),
                  overflow: TextOverflow.ellipsis,
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
          ],
        ),
      ),
    );
  }
}
