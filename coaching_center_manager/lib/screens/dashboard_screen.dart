import 'package:flutter/material.dart';
import 'student_list_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEAF5FC),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xff86BFE2),
        title: const Text(
          "Admin Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),

        child: Column(
          children: [
            //---------------------------------
            // Welcome Card
            //---------------------------------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  const Text(
                    "Welcome Back, Aman!",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 15),

                  Container(
                    height: 45,

                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(30),
                    ),

                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: "Search",
                        prefixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 24,
                        backgroundImage: AssetImage(
                          "assets/images/profile.png",
                        ),
                      ),

                      const SizedBox(width: 12),

                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text(
                              "Admin",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),

                            Text(
                              "Aman Sarfraz",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),

                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.notifications_none),
                      ),

                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.settings),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.08),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total Students",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 6),

                        Text(
                          "1250",
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 8),

                        Text("Active: 1120", style: TextStyle(fontSize: 15)),

                        Text(
                          "New: 60 this month",
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ),

                  CircleAvatar(
                    radius: 28,
                    backgroundColor: const Color(0xFF86BFE2),
                    child: const Icon(
                      Icons.person,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.08),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total Teachers",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 6),

                        Text(
                          "530",
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 8),

                        Text("Full-time: 50"),
                        Text("Part-time: 12"),
                      ],
                    ),
                  ),

                  CircleAvatar(
                    radius: 28,
                    backgroundColor: const Color(0xFF86BFE2),
                    child: Icon(Icons.school, color: Colors.black, size: 30),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.08),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total Batches",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 6),

                        Text(
                          "28",
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 8),

                        Text("Morning: 15"),
                        Text("Evening: 13"),
                      ],
                    ),
                  ),

                  CircleAvatar(
                    radius: 28,
                    backgroundColor: const Color(0xFF86BFE2),
                    child: Icon(Icons.menu_book, color: Colors.black, size: 28),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.08),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        const Text(
                          "Today's Attendance",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),

                        const SizedBox(height: 12),

                        Center(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                height: 65,
                                width: 65,
                                child: CircularProgressIndicator(
                                  value: .92,
                                  strokeWidth: 7,
                                  backgroundColor: Colors.grey.shade300,
                                  color: const Color(0xff122767),
                                ),
                              ),

                              const Text(
                                "92%",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        const Text(
                          "Present : 950",
                          style: TextStyle(fontSize: 12),
                        ),

                        const Text(
                          "Absent : 20",
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(14),

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.08),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),

                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          "Monthly Fee",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),

                        SizedBox(height: 12),

                        Text(
                          "\$120,500",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 26,
                          ),
                        ),

                        SizedBox(height: 10),

                        Text("Target : \$140,000"),

                        Text("Paid : 86%"),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.08),
                    blurRadius: 8,
                  ),
                ],
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: const [
                      Text(
                        "Recent Activity",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        "Detailed Chart",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  const ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: Color(0xff86BFE2),
                      child: Icon(Icons.person, color: Colors.black),
                    ),
                    title: Text("New Student"),
                    subtitle: Text("Ayesha Khan joined Class 9A"),
                  ),

                  const ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: Color(0xff86BFE2),
                      child: Icon(Icons.school, color: Colors.black),
                    ),
                    title: Text("Teacher Profile Update"),
                    subtitle: Text("MR. Ahmad"),
                  ),

                  const ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: Color(0xff86BFE2),
                      child: Icon(Icons.menu_book, color: Colors.black),
                    ),
                    title: Text("Batch 12"),
                    subtitle: Text("Timetable Modified"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              "Quick Actions",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xff122767),
              ),
            ),

            const SizedBox(height: 18),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: .90,

              children: [
                quickAction(
                  "Students",
                  Icons.people_alt_rounded,
                  const Color(0xff4A90E2),
                  () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const StudentListScreen(),
                      ),
                    );
                  },
                ),

                quickAction(
                  "Teachers",
                  Icons.school_rounded,
                  const Color(0xff56CC9D),
                  () {},
                ),

                quickAction(
                  "Create Batch",
                  Icons.menu_book_rounded,
                  const Color(0xffF2994A),
                  () {},
                ),

                quickAction(
                  "Attendance",
                  Icons.fact_check_rounded,
                  const Color(0xff9B51E0),
                  () {},
                ),

                quickAction(
                  "Fees",
                  Icons.payments_rounded,
                  const Color(0xffEB5757),
                  () {},
                ),

                quickAction(
                  "Settings",
                  Icons.settings_rounded,
                  const Color(0xff122767),
                  () {},
                ),
              ],
            ),

            const SizedBox(height: 25),
            // Next cards yahan add honge
          ],
        ),
      ),
    );
  }
}

Widget quickAction(
  String title,
  IconData icon,
  Color color,
  VoidCallback onTap,
) {
  return InkWell(
    borderRadius: BorderRadius.circular(18),
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: color.withOpacity(.15),
            child: Icon(icon, color: color, size: 28),
          ),

          const SizedBox(height: 12),

          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
        ],
      ),
    ),
  );
}
