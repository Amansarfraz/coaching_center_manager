import 'package:flutter/material.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  //================ Controllers =================//

  final TextEditingController searchController = TextEditingController();

  //================ Student List =================//

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

  //================ Init =================//

  @override
  void initState() {
    super.initState();
    filteredStudents = List.from(students);
  }

  //================ Search =================//

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

  //================ Status Color =================//

  Color getStatusColor(String status) {
    switch (status) {
      case "Paid":
        return Colors.green;

      case "Pending":
        return Colors.orange;

      case "Unpaid":
        return Colors.red;

      default:
        return Colors.grey;
    }
  }
  //================ Delete Student =================//

  void deleteStudent(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text("Delete Student"),
          content: const Text("Are you sure you want to delete this student?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
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

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Student Deleted Successfully")),
                );
              },
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  //================ Edit Student =================//

  void editStudent(int index) {
    TextEditingController name = TextEditingController(
      text: filteredStudents[index]["name"],
    );

    TextEditingController batch = TextEditingController(
      text: filteredStudents[index]["batch"],
    );

    TextEditingController phone = TextEditingController(
      text: filteredStudents[index]["phone"],
    );

    String status = filteredStudents[index]["status"];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),

              title: const Text("Edit Student"),

              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: name,
                      decoration: const InputDecoration(
                        labelText: "Student Name",
                      ),
                    ),

                    const SizedBox(height: 15),

                    TextField(
                      controller: batch,
                      decoration: const InputDecoration(labelText: "Batch"),
                    ),

                    const SizedBox(height: 15),

                    TextField(
                      controller: phone,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(labelText: "Phone"),
                    ),

                    const SizedBox(height: 15),

                    DropdownButtonFormField<String>(
                      value: status,

                      items: const [
                        DropdownMenuItem(value: "Paid", child: Text("Paid")),

                        DropdownMenuItem(
                          value: "Pending",
                          child: Text("Pending"),
                        ),

                        DropdownMenuItem(
                          value: "Unpaid",
                          child: Text("Unpaid"),
                        ),
                      ],

                      onChanged: (value) {
                        setDialog(() {
                          status = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff03195D),
                  ),

                  onPressed: () {
                    setState(() {
                      filteredStudents[index]["name"] = name.text;
                      filteredStudents[index]["batch"] = batch.text;
                      filteredStudents[index]["phone"] = phone.text;
                      filteredStudents[index]["status"] = status;
                    });

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Student Updated Successfully"),
                      ),
                    );
                  },

                  child: const Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  //================ Add Student =================//

  void addStudent() {
    TextEditingController name = TextEditingController();
    TextEditingController batch = TextEditingController();
    TextEditingController phone = TextEditingController();

    String status = "Paid";

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),

              title: const Text("Add Student"),

              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    TextField(
                      controller: name,
                      decoration: const InputDecoration(
                        labelText: "Student Name",
                      ),
                    ),

                    const SizedBox(height: 15),

                    TextField(
                      controller: batch,
                      decoration: const InputDecoration(labelText: "Batch"),
                    ),

                    const SizedBox(height: 15),

                    TextField(
                      controller: phone,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(labelText: "Phone"),
                    ),

                    const SizedBox(height: 15),

                    DropdownButtonFormField<String>(
                      value: status,

                      items: const [
                        DropdownMenuItem(value: "Paid", child: Text("Paid")),

                        DropdownMenuItem(
                          value: "Pending",
                          child: Text("Pending"),
                        ),

                        DropdownMenuItem(
                          value: "Unpaid",
                          child: Text("Unpaid"),
                        ),
                      ],

                      onChanged: (value) {
                        setDialog(() {
                          status = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff03195D),
                  ),

                  onPressed: () {
                    setState(() {
                      students.add({
                        "name": name.text,
                        "batch": batch.text,
                        "phone": phone.text,
                        "status": status,
                      });

                      filteredStudents = List.from(students);
                    });

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Student Added Successfully"),
                      ),
                    );
                  },

                  child: const Text(
                    "Add",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
  //================ Build Method =================//

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff86BFE2),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xff03195D),
        onPressed: addStudent,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          "Add Student",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      body: SafeArea(
        child: Stack(
          children: [
            ///================ BLUE HEADER ================///
            Container(
              height: 180,
              width: double.infinity,
              color: const Color(0xff86BFE2),
            ),

            ///================ WHITE CONTAINER ================///
            Positioned(
              top: 120,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xffF8F9FD),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35),
                  ),
                ),
              ),
            ),

            ///================ CONTENT ================///
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),

              child: Column(
                children: [
                  const SizedBox(height: 18),

                  ///================ HEADER =================///
                  Row(
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 45,
                          width: 45,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Color(0xff03195D),
                            size: 18,
                          ),
                        ),
                      ),

                      const Spacer(),

                      const Text(
                        "Student List",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff03195D),
                        ),
                      ),

                      const Spacer(),

                      const SizedBox(width: 45),
                    ],
                  ),

                  const SizedBox(height: 35),

                  ///================ SEARCH =================///
                  Container(
                    height: 58,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),

                    child: TextField(
                      controller: searchController,
                      onChanged: searchStudent,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.search,
                          color: Color(0xff03195D),
                        ),
                        hintText: "Search Student",
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  ///================ LIST =================///
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
                            padding: const EdgeInsets.only(bottom: 90),
                            itemCount: filteredStudents.length,
                            itemBuilder: (context, index) {
                              final student = filteredStudents[index];

                              // 👇 YAHAN NEXT PART KA STUDENT CARD AYEGA

                              return Container(
                                margin: const EdgeInsets.only(bottom: 18),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(22),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(.08),
                                      blurRadius: 15,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),

                                child: Column(
                                  children: [
                                    ///================ TOP ROW =================///
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        /// Avatar
                                        CircleAvatar(
                                          radius: 32,
                                          backgroundColor: const Color(
                                            0xffD8ECFF,
                                          ),
                                          child: Text(
                                            student["name"][0],
                                            style: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff03195D),
                                            ),
                                          ),
                                        ),

                                        const SizedBox(width: 15),

                                        /// Details
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                student["name"],
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xff03195D),
                                                ),
                                              ),

                                              const SizedBox(height: 8),

                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 5,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: Colors.blue.shade50,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Text(
                                                  student["batch"],
                                                  style: const TextStyle(
                                                    color: Color(0xff1565C0),
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),

                                              const SizedBox(height: 10),

                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.phone_android,
                                                    color: Colors.grey,
                                                    size: 18,
                                                  ),

                                                  const SizedBox(width: 6),

                                                  Expanded(
                                                    child: Text(
                                                      student["phone"],
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),

                                        /// Status Badge
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: getStatusColor(
                                              student["status"],
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          child: Text(
                                            student["status"],
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 18),

                                    Divider(color: Colors.grey.shade300),

                                    const SizedBox(height: 12),

                                    ///================ BUTTONS =================///
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton.icon(
                                            onPressed: () {
                                              editStudent(index);
                                            },

                                            icon: const Icon(Icons.edit),

                                            label: const Text("Edit"),

                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.blue.shade50,
                                              foregroundColor: Colors.blue,
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                              ),
                                              minimumSize: const Size(
                                                double.infinity,
                                                48,
                                              ),
                                            ),
                                          ),
                                        ),

                                        const SizedBox(width: 12),

                                        Expanded(
                                          child: ElevatedButton.icon(
                                            onPressed: () {
                                              deleteStudent(index);
                                            },

                                            icon: const Icon(Icons.delete),

                                            label: const Text("Delete"),

                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.red.shade50,
                                              foregroundColor: Colors.red,
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                              ),
                                              minimumSize: const Size(
                                                double.infinity,
                                                48,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
