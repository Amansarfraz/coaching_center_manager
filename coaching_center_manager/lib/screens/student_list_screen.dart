import 'package:flutter/material.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  //================ Controllers =================//

  final TextEditingController searchController = TextEditingController();

  //================ Student Data =================//

  List<Map<String, dynamic>> students = [
    {
      "name": "Ali Hassan",
      "batch": "Flutter Batch A",
      "phone": "03001234567",
      "status": "Paid",
      "image": "assets/images/student1.png",
    },

    {
      "name": "Ahmad Raza",
      "batch": "Flutter Batch B",
      "phone": "03111234567",
      "status": "Pending",
      "image": "assets/images/student2.png",
    },

    {
      "name": "Sara Khan",
      "batch": "Graphic Batch",
      "phone": "03221234567",
      "status": "Unpaid",
      "image": "assets/images/student3.png",
    },

    {
      "name": "Usman Ali",
      "batch": "Web Batch",
      "phone": "03331234567",
      "status": "Paid",
      "image": "assets/images/student4.png",
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
  //================ Change Profile Picture =================//

  void changeProfilePicture(int index) {
    List<String> images = [
      "assets/images/student1.png",
      "assets/images/student2.png",
      "assets/images/student3.png",
      "assets/images/student4.png",
      "assets/images/student5.png",
      "assets/images/student6.png",
    ];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Center(
            child: Text(
              "Select Profile Picture",
              style: TextStyle(
                color: Color(0xff03195D),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: SizedBox(
            width: 300,
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: images.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, i) {
                return InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: () {
                    setState(() {
                      filteredStudents[index]["image"] = images[i];
                    });

                    Navigator.pop(context);
                  },
                  child: CircleAvatar(
                    radius: 35,
                    backgroundImage: AssetImage(images[i]),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  //////////////////////////////////////////////////////////
  // Delete Student
  //////////////////////////////////////////////////////////

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
                  const SnackBar(content: Text("Student deleted successfully")),
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
    TextEditingController nameController = TextEditingController(
      text: filteredStudents[index]["name"],
    );

    TextEditingController batchController = TextEditingController(
      text: filteredStudents[index]["batch"],
    );

    TextEditingController phoneController = TextEditingController(
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

              title: const Center(
                child: Text(
                  "Edit Student",
                  style: TextStyle(
                    color: Color(0xff03195D),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: "Student Name",
                      ),
                    ),

                    const SizedBox(height: 15),

                    TextField(
                      controller: batchController,
                      decoration: const InputDecoration(labelText: "Batch"),
                    ),

                    const SizedBox(height: 15),

                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: "Phone Number",
                      ),
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
                      filteredStudents[index]["name"] = nameController.text;

                      filteredStudents[index]["batch"] = batchController.text;

                      filteredStudents[index]["phone"] = phoneController.text;

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

  //////////////////////////////////////////////////////////
  // Add Student
  //////////////////////////////////////////////////////////

  void addStudent() {
    TextEditingController nameController = TextEditingController();

    TextEditingController batchController = TextEditingController();

    TextEditingController phoneController = TextEditingController();

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

              title: const Center(
                child: Text(
                  "Add Student",
                  style: TextStyle(
                    color: Color(0xff03195D),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: "Student Name",
                      ),
                    ),

                    const SizedBox(height: 15),

                    TextField(
                      controller: batchController,
                      decoration: const InputDecoration(labelText: "Batch"),
                    ),

                    const SizedBox(height: 15),

                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: "Phone Number",
                      ),
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
                    if (nameController.text.isEmpty ||
                        batchController.text.isEmpty ||
                        phoneController.text.isEmpty) {
                      return;
                    }

                    setState(() {
                      students.add({
                        "name": nameController.text,
                        "batch": batchController.text,
                        "phone": phoneController.text,
                        "status": status,
                        "image": "assets/images/default.png",
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC3DFF0),

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
        child: Column(
          children: [
            ///================ HEADER ================
            Container(
              width: double.infinity,
              height: 77,
              color: const Color(0xff86BFE2),

              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Color(0xff03195D),
                    ),
                  ),

                  const Expanded(
                    child: Center(
                      child: Text(
                        "Student List",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff03195D),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 48),
                ],
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(18),

                child: Column(
                  children: [
                    Container(
                      height: 55,

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.08),
                            blurRadius: 10,
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

                    const SizedBox(height: 20),

                    Expanded(
                      child: filteredStudents.isEmpty
                          ? const Center(child: Text("No Student Found"))
                          : ListView.builder(
                              itemCount: filteredStudents.length,

                              itemBuilder: (context, index) {
                                final student = filteredStudents[index];
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 18),
                                  padding: const EdgeInsets.all(15),

                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(.15),
                                        blurRadius: 10,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),

                                  child: Column(
                                    children: [
                                      /// TOP ROW
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              changeProfilePicture(index);
                                            },
                                            child: CircleAvatar(
                                              radius: 32,
                                              backgroundImage: AssetImage(
                                                student["image"],
                                              ),
                                            ),
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
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xff03195D),
                                                  ),
                                                ),

                                                const SizedBox(height: 6),

                                                Text(student["batch"]),

                                                const SizedBox(height: 6),

                                                Text(student["phone"]),
                                              ],
                                            ),
                                          ),

                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 14,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: getStatusColor(
                                                student["status"],
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(20),
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

                                      const SizedBox(height: 15),

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
                                              ),
                                            ),
                                          ),

                                          const SizedBox(width: 10),

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
            ),
          ],
        ),
      ),
    );
  }
}
