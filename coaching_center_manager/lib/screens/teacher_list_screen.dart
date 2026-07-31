import 'package:flutter/material.dart';

class TeacherListScreen extends StatefulWidget {
  const TeacherListScreen({super.key});

  @override
  State<TeacherListScreen> createState() => _TeacherListScreenState();
}

class _TeacherListScreenState extends State<TeacherListScreen> {
  final TextEditingController searchController = TextEditingController();

  List<Map<String, dynamic>> teachers = [
    {
      "image": "assets/images/teacher1.png",
      "name": "Mr Ahmad",
      "subject": "Mathematics",
      "qualification": "M.Sc. Applied Mathematics",
      "phone": "+92 3016935390",
      "email": "ahmad@gmail.com",
      "dob": "12 May 1995",
      "joiningDate": "15 Jan 2024",
      "gender": "Male",
      "salary": "80,000",
    },

    {
      "image": "assets/images/teacher2.png",
      "name": "Mr Hammad",
      "subject": "History",
      "qualification": "M.Sc. History",
      "phone": "+92 3016935390",
      "email": "hammad@gmail.com",
      "dob": "18 Jun 1994",
      "joiningDate": "20 Feb 2024",
      "gender": "Male",
      "salary": "75,000",
    },

    {
      "image": "assets/images/teacher3.png",
      "name": "Mrs Ayesha",
      "subject": "Computer",
      "qualification": "M.Sc. Computer Science",
      "phone": "+92 3016935390",
      "email": "ayesha@gmail.com",
      "dob": "22 Jan 1996",
      "joiningDate": "10 Mar 2024",
      "gender": "Female",
      "salary": "90,000",
    },
  ];

  List<Map<String, dynamic>> filteredTeachers = [];

  @override
  void initState() {
    super.initState();

    filteredTeachers = List.from(teachers);
  }

  //////////////////////////////////////
  /// SEARCH
  //////////////////////////////////////

  void searchTeacher(String value) {
    setState(() {
      filteredTeachers = teachers.where((teacher) {
        return teacher["name"].toString().toLowerCase().contains(
              value.toLowerCase(),
            ) ||
            teacher["subject"].toString().toLowerCase().contains(
              value.toLowerCase(),
            ) ||
            teacher["phone"].toString().contains(value);
      }).toList();
    });
  }
  ////////////////////////////////////////////////////
  /// CHANGE PROFILE PICTURE
  ////////////////////////////////////////////////////

  void changeProfilePicture(int index) {
    List<String> images = [
      "assets/images/pic1.jpg",
      "assets/images/pic2.jpg",
      "assets/images/pic3.jpg",
      "assets/images/pic4.jpg",
      "assets/images/pic5.jpg",
      "assets/images/pic6.jpg",
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
            width: 320,

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
                  onTap: () {
                    setState(() {
                      filteredTeachers[index]["image"] = images[i];
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

  ////////////////////////////////////////////////////
  /// VIEW TEACHER DETAILS
  ////////////////////////////////////////////////////

  void viewTeacher(int index) {
    final teacher = filteredTeachers[index];

    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),

          title: const Center(
            child: Text(
              "Teacher Details",
              style: TextStyle(
                color: Color(0xff03195D),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          content: SingleChildScrollView(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundImage: AssetImage(teacher["image"]),
                ),

                const SizedBox(height: 20),

                infoTile("Name", teacher["name"]),

                infoTile("Subject", teacher["subject"]),

                infoTile("Qualification", teacher["qualification"]),

                infoTile("Phone", teacher["phone"]),

                infoTile("Email", teacher["email"]),

                infoTile("DOB", teacher["dob"]),

                infoTile("Joining Date", teacher["joiningDate"]),

                infoTile("Gender", teacher["gender"]),

                infoTile("Salary", teacher["salary"]),
              ],
            ),
          ),

          actions: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff03195D),
                ),

                onPressed: () {
                  Navigator.pop(context);
                },

                child: const Text(
                  "Close",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  ////////////////////////////////////////////////////
  /// DELETE TEACHER
  ////////////////////////////////////////////////////

  void deleteTeacher(int index) {
    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),

          title: const Text("Delete Teacher"),

          content: const Text("Are you sure you want to delete this teacher?"),

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
                  teachers.remove(filteredTeachers[index]);

                  filteredTeachers.removeAt(index);
                });

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Teacher deleted successfully")),
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

  ////////////////////////////////////////////////////
  /// INFO TILE
  ////////////////////////////////////////////////////

  Widget infoTile(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          SizedBox(
            width: 110,
            child: Text(
              "$title :",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          Expanded(child: Text(value)),
        ],
      ),
    );
  }
  ////////////////////////////////////////////////////////////
  /// EDIT TEACHER
  ////////////////////////////////////////////////////////////

  void editTeacher(int index) {
    final teacher = filteredTeachers[index];

    TextEditingController nameController = TextEditingController(
      text: teacher["name"],
    );

    TextEditingController subjectController = TextEditingController(
      text: teacher["subject"],
    );

    TextEditingController qualificationController = TextEditingController(
      text: teacher["qualification"],
    );

    TextEditingController phoneController = TextEditingController(
      text: teacher["phone"],
    );

    TextEditingController emailController = TextEditingController(
      text: teacher["email"],
    );

    TextEditingController dobController = TextEditingController(
      text: teacher["dob"],
    );

    TextEditingController joiningController = TextEditingController(
      text: teacher["joiningDate"],
    );

    TextEditingController salaryController = TextEditingController(
      text: teacher["salary"],
    );

    String gender = teacher["gender"];

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
                  "Edit Teacher",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xff03195D),
                  ),
                ),
              ),

              content: SizedBox(
                width: 350,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: "Teacher Name",
                        ),
                      ),

                      const SizedBox(height: 10),

                      TextField(
                        controller: subjectController,
                        decoration: const InputDecoration(labelText: "Subject"),
                      ),

                      const SizedBox(height: 10),

                      TextField(
                        controller: qualificationController,
                        decoration: const InputDecoration(
                          labelText: "Qualification",
                        ),
                      ),

                      const SizedBox(height: 10),

                      TextField(
                        controller: phoneController,
                        decoration: const InputDecoration(
                          labelText: "Phone Number",
                        ),
                      ),

                      const SizedBox(height: 10),

                      TextField(
                        controller: emailController,
                        decoration: const InputDecoration(labelText: "Email"),
                      ),

                      const SizedBox(height: 10),

                      TextField(
                        controller: dobController,
                        decoration: const InputDecoration(
                          labelText: "Date of Birth",
                        ),
                      ),

                      const SizedBox(height: 10),

                      TextField(
                        controller: joiningController,
                        decoration: const InputDecoration(
                          labelText: "Joining Date",
                        ),
                      ),

                      const SizedBox(height: 10),

                      DropdownButtonFormField<String>(
                        value: gender,

                        items: const [
                          DropdownMenuItem(value: "Male", child: Text("Male")),

                          DropdownMenuItem(
                            value: "Female",
                            child: Text("Female"),
                          ),
                        ],

                        onChanged: (value) {
                          setDialog(() {
                            gender = value!;
                          });
                        },
                      ),

                      const SizedBox(height: 10),

                      TextField(
                        controller: salaryController,
                        decoration: const InputDecoration(labelText: "Salary"),
                      ),
                    ],
                  ),
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
                      teacher["name"] = nameController.text;

                      teacher["subject"] = subjectController.text;

                      teacher["qualification"] = qualificationController.text;

                      teacher["phone"] = phoneController.text;

                      teacher["email"] = emailController.text;

                      teacher["dob"] = dobController.text;

                      teacher["joiningDate"] = joiningController.text;

                      teacher["gender"] = gender;

                      teacher["salary"] = salaryController.text;
                    });

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Teacher Updated Successfully"),
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
  ////////////////////////////////////////////////////////////
  /// ADD TEACHER
  ////////////////////////////////////////////////////////////

  void addTeacher() {
    TextEditingController nameController = TextEditingController();

    TextEditingController subjectController = TextEditingController();

    TextEditingController qualificationController = TextEditingController();

    TextEditingController phoneController = TextEditingController();

    TextEditingController emailController = TextEditingController();

    TextEditingController dobController = TextEditingController();

    TextEditingController joiningController = TextEditingController();

    TextEditingController salaryController = TextEditingController();

    String gender = "Male";

    String image = "assets/images/teacher1.png";

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
                  "Add Teacher",
                  style: TextStyle(
                    color: Color(0xff03195D),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              content: SizedBox(
                width: 350,

                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage(image),
                      ),

                      const SizedBox(height: 15),

                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: "Teacher Name",
                        ),
                      ),

                      const SizedBox(height: 10),

                      TextField(
                        controller: subjectController,
                        decoration: const InputDecoration(labelText: "Subject"),
                      ),

                      const SizedBox(height: 10),

                      TextField(
                        controller: qualificationController,
                        decoration: const InputDecoration(
                          labelText: "Qualification",
                        ),
                      ),

                      const SizedBox(height: 10),

                      TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: "Phone Number",
                        ),
                      ),

                      const SizedBox(height: 10),

                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(labelText: "Email"),
                      ),

                      const SizedBox(height: 10),

                      TextField(
                        controller: dobController,
                        decoration: const InputDecoration(
                          labelText: "Date of Birth",
                        ),
                      ),

                      const SizedBox(height: 10),

                      TextField(
                        controller: joiningController,
                        decoration: const InputDecoration(
                          labelText: "Joining Date",
                        ),
                      ),

                      const SizedBox(height: 10),

                      DropdownButtonFormField<String>(
                        value: gender,

                        decoration: const InputDecoration(labelText: "Gender"),

                        items: const [
                          DropdownMenuItem(value: "Male", child: Text("Male")),

                          DropdownMenuItem(
                            value: "Female",
                            child: Text("Female"),
                          ),
                        ],

                        onChanged: (value) {
                          setDialog(() {
                            gender = value!;
                          });
                        },
                      ),

                      const SizedBox(height: 10),

                      TextField(
                        controller: salaryController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: "Salary"),
                      ),
                    ],
                  ),
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
                        subjectController.text.isEmpty) {
                      return;
                    }

                    setState(() {
                      teachers.add({
                        "image": image,

                        "name": nameController.text,

                        "subject": subjectController.text,

                        "qualification": qualificationController.text,

                        "phone": phoneController.text,

                        "email": emailController.text,

                        "dob": dobController.text,

                        "joiningDate": joiningController.text,

                        "gender": gender,

                        "salary": salaryController.text,
                      });

                      filteredTeachers = List.from(teachers);
                    });

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Teacher Added Successfully"),
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
  ////////////////////////////////////////////////////////////
  /// BUILD METHOD
  ////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffC3DFF0),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xff03195D),

        onPressed: addTeacher,

        icon: const Icon(Icons.add, color: Colors.white),

        label: const Text(
          "Add Teacher",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            ////////////////////////////////////////////
            /// HEADER
            ////////////////////////////////////////////
            Container(
              width: double.infinity,

              height: 77,

              color: const Color(0xff86BFE2),

              padding: const EdgeInsets.symmetric(horizontal: 15),

              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },

                    borderRadius: BorderRadius.circular(30),

                    child: const CircleAvatar(
                      radius: 20,

                      backgroundColor: Colors.white,

                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: Color(0xff03195D),
                        size: 18,
                      ),
                    ),
                  ),

                  const Expanded(
                    child: Center(
                      child: Text(
                        "Teacher List",

                        style: TextStyle(
                          fontSize: 25,

                          fontWeight: FontWeight.bold,

                          color: Color(0xff03195D),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 40),
                ],
              ),
            ),

            ////////////////////////////////////////////
            /// BODY
            ////////////////////////////////////////////
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  children: [
                    ////////////////////////////////////////////
                    /// SEARCH BAR
                    ////////////////////////////////////////////
                    Container(
                      height: 55,

                      decoration: BoxDecoration(
                        color: Colors.white,

                        borderRadius: BorderRadius.circular(30),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.08),

                            blurRadius: 10,

                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),

                      child: TextField(
                        controller: searchController,

                        onChanged: searchTeacher,

                        decoration: const InputDecoration(
                          border: InputBorder.none,

                          hintText: "Search Teacher",

                          prefixIcon: Icon(
                            Icons.search,
                            color: Color(0xff03195D),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    ////////////////////////////////////////////
                    /// LIST
                    ////////////////////////////////////////////
                    Expanded(
                      child: filteredTeachers.isEmpty
                          ? const Center(
                              child: Text(
                                "No Teacher Found",

                                style: TextStyle(
                                  fontWeight: FontWeight.bold,

                                  fontSize: 18,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: filteredTeachers.length,

                              itemBuilder: (context, index) {
                                final teacher = filteredTeachers[index];

                                /// CARD NEXT PART

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
                                      ///////////////////////////////
                                      /// TOP ROW
                                      ///////////////////////////////
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          /// PROFILE
                                          InkWell(
                                            onTap: () {
                                              changeProfilePicture(index);
                                            },

                                            child: CircleAvatar(
                                              radius: 35,
                                              backgroundImage: AssetImage(
                                                teacher["image"],
                                              ),
                                            ),
                                          ),

                                          const SizedBox(width: 15),

                                          ///////////////////////////////
                                          /// DETAILS
                                          ///////////////////////////////
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  teacher["name"],
                                                  style: const TextStyle(
                                                    fontSize: 19,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xff03195D),
                                                  ),
                                                ),

                                                const SizedBox(height: 8),

                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.menu_book,
                                                      size: 18,
                                                      color: Colors.blue,
                                                    ),

                                                    const SizedBox(width: 6),

                                                    Expanded(
                                                      child: Text(
                                                        teacher["subject"],
                                                        style: const TextStyle(
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                                const SizedBox(height: 6),

                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.school,
                                                      size: 18,
                                                      color: Colors.deepPurple,
                                                    ),

                                                    const SizedBox(width: 6),

                                                    Expanded(
                                                      child: Text(
                                                        teacher["qualification"],
                                                        style: const TextStyle(
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                                const SizedBox(height: 6),

                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.phone,
                                                      size: 18,
                                                      color: Colors.green,
                                                    ),

                                                    const SizedBox(width: 6),

                                                    Text(
                                                      teacher["phone"],
                                                      style: const TextStyle(
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 15),

                                      Divider(color: Colors.grey.shade300),

                                      const SizedBox(height: 12),

                                      ///////////////////////////////
                                      /// ACTION BUTTONS
                                      ///////////////////////////////
                                      Row(
                                        children: [
                                          Expanded(
                                            child: ElevatedButton.icon(
                                              onPressed: () {
                                                viewTeacher(index);
                                              },
                                              icon: const Icon(
                                                Icons.visibility,
                                                size: 18,
                                              ),
                                              label: const Text("View"),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.green.shade50,
                                                foregroundColor: Colors.green,
                                                elevation: 0,
                                                minimumSize: const Size(
                                                  double.infinity,
                                                  46,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                              ),
                                            ),
                                          ),

                                          const SizedBox(width: 8),

                                          Expanded(
                                            child: ElevatedButton.icon(
                                              onPressed: () {
                                                editTeacher(index);
                                              },
                                              icon: const Icon(
                                                Icons.edit,
                                                size: 18,
                                              ),
                                              label: const Text("Edit"),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.blue.shade50,
                                                foregroundColor: Colors.blue,
                                                elevation: 0,
                                                minimumSize: const Size(
                                                  double.infinity,
                                                  46,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                              ),
                                            ),
                                          ),

                                          const SizedBox(width: 8),

                                          Expanded(
                                            child: ElevatedButton.icon(
                                              onPressed: () {
                                                deleteTeacher(index);
                                              },
                                              icon: const Icon(
                                                Icons.delete,
                                                size: 18,
                                              ),
                                              label: const Text("Delete"),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.red.shade50,
                                                foregroundColor: Colors.red,
                                                elevation: 0,
                                                minimumSize: const Size(
                                                  double.infinity,
                                                  46,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
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
            ),
          ],
        ),
      ),
    );
  }
}
