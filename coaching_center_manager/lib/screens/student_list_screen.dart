import 'package:flutter/material.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  final TextEditingController searchController = TextEditingController();
  void deleteStudent(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Delete Student"),
        content: const Text("Are you sure you want to delete this student?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() {
                students.remove(filteredStudents[index]);
                filteredStudents.removeAt(index);
              });

              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> students = [
    {
      "name": "Ali Hassan",
      "batch": "Flutter Batch A",
      "phone": "03001234567",
      "status": "Paid",
    },
    {
      "name": "Ahmad Raza",
      "batch": "Flutter Batch B",
      "phone": "03111234567",
      "status": "Pending",
    },
    {
      "name": "Sara Khan",
      "batch": "Graphic Batch",
      "phone": "03221234567",
      "status": "Unpaid",
    },
    {
      "name": "Usman Ali",
      "batch": "Web Batch",
      "phone": "03331234567",
      "status": "Paid",
    },
  ];

  List<Map<String, dynamic>> filteredStudents = [];

  @override
  void initState() {
    super.initState();
    filteredStudents = List.from(students);
  }

  void searchStudent(String value) {
    setState(() {
      filteredStudents = students.where((student) {
        return student["name"].toString().toLowerCase().contains(
              value.toLowerCase(),
            ) ||
            student["batch"].toString().toLowerCase().contains(
              value.toLowerCase(),
            ) ||
            student["phone"].toString().contains(value);
      }).toList();
    });
  }

  Color getStatusColor(String status) {
    switch (status) {
      case "Paid":
        return Colors.green;

      case "Pending":
        return Colors.orange;

      default:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xff86BFE2),

      appBar: AppBar(
        backgroundColor: const Color(0xff86BFE2),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Student List",
          style: TextStyle(
            color: Color(0xff03195D),
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xff03195D)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            /// SEARCH BAR
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),

              child: TextField(
                controller: searchController,
                onChanged: searchStudent,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Search Student",
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: filteredStudents.isEmpty
                  ? const Center(
                      child: Text(
                        "No Student Found",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredStudents.length,
                      itemBuilder: (context, index) {
                        final student = filteredStudents[index];

                        return Card(
                          margin: const EdgeInsets.only(bottom: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(15),

                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.grey.shade300,
                                  child: const Icon(Icons.person, size: 35),
                                ),

                                const SizedBox(width: 15),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        student["name"],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),

                                      const SizedBox(height: 5),

                                      Text(student["batch"]),

                                      const SizedBox(height: 5),

                                      Text(student["phone"]),
                                    ],
                                  ),
                                ),

                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),

                                  decoration: BoxDecoration(
                                    color: getStatusColor(student["status"]),
                                    borderRadius: BorderRadius.circular(20),
                                  ),

                                  child: Text(
                                    student["status"],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
