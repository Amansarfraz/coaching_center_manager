import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F8FC),

      appBar: AppBar(
        backgroundColor: const Color(0xFF86BFE2),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundImage: AssetImage("assets/images/profile.png"),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Good Morning 👋",
                  style: TextStyle(fontSize: 13, color: Colors.white70),
                ),
                Text(
                  "Admin",
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_rounded),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Dashboard",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xff122767),
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              "Welcome to Coaching Center Manager",
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),

            const SizedBox(height: 25),

            //---------------------------------------
            // Summary Cards
            //---------------------------------------
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 1.25,
              children: const [
                DashboardCard(
                  title: "Students",
                  value: "250",
                  icon: Icons.people,
                  color: Color(0xff4A90E2),
                ),

                DashboardCard(
                  title: "Teachers",
                  value: "18",
                  icon: Icons.school,
                  color: Color(0xff56CC9D),
                ),

                DashboardCard(
                  title: "Batches",
                  value: "12",
                  icon: Icons.class_,
                  color: Color(0xffF2994A),
                ),

                DashboardCard(
                  title: "Attendance",
                  value: "95%",
                  icon: Icons.fact_check,
                  color: Color(0xff9B51E0),
                ),
              ],
            ),

            const SizedBox(height: 30),

            //---------------------------------------
            // Monthly Fee Card
            //---------------------------------------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xff122767),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Monthly Fee Collection",
                    style: TextStyle(color: Colors.white70),
                  ),

                  SizedBox(height: 10),

                  Text(
                    "PKR 350,000",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            //---------------------------------------
            // Quick Actions
            //---------------------------------------
            const Text(
              "Quick Actions",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xff122767),
              ),
            ),

            const SizedBox(height: 15),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: .95,
              children: const [
                QuickActionCard(title: "Students", icon: Icons.people),

                QuickActionCard(title: "Teachers", icon: Icons.school),

                QuickActionCard(title: "Batches", icon: Icons.class_),

                QuickActionCard(title: "Attendance", icon: Icons.fact_check),

                QuickActionCard(title: "Fees", icon: Icons.payments),
              ],
            ),

            const SizedBox(height: 30),

            //---------------------------------------
            // Recent Activity
            //---------------------------------------
            const Text(
              "Recent Activity",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xff122767),
              ),
            ),

            const SizedBox(height: 15),

            const ActivityTile(
              title: "Ahmed joined Flutter Batch",
              subtitle: "2 minutes ago",
            ),

            ActivityTile(
              title: "Attendance marked successfully",
              subtitle: "15 minutes ago",
            ),

            ActivityTile(title: "Fee received from Ali", subtitle: "Today"),

            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const DashboardCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),

        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: color.withOpacity(.15),
            child: Icon(icon, color: color, size: 28),
          ),

          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          Text(title, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

class QuickActionCard extends StatelessWidget {
  final String title;
  final IconData icon;

  const QuickActionCard({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},

      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),

          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(.15), blurRadius: 8),
          ],
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: const Color(0xff86BFE2),

              child: Icon(icon, color: Colors.white),
            ),

            const SizedBox(height: 10),

            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class ActivityTile extends StatelessWidget {
  final String title;
  final String subtitle;

  const ActivityTile({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),

      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Color(0xff86BFE2),
          child: Icon(Icons.notifications, color: Colors.white),
        ),

        title: Text(title),

        subtitle: Text(subtitle),
      ),
    );
  }
}
