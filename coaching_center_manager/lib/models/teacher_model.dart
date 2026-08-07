class TeacherModel {
  final String id;
  final String fullName;
  final String subject;
  final String qualification;
  final String phone;
  final String email;
  final String gender; // 'male', 'female', 'other'
  final DateTime joiningDate;
  final double salary;
  final List<String> assignedSubjects;
  final List<String> assignedBatchIds;
  final String? profileImage;
  final String status; // 'active', 'inactive'
  final DateTime createdAt;

  TeacherModel({
    required this.id,
    required this.fullName,
    required this.subject,
    required this.qualification,
    required this.phone,
    required this.email,
    required this.gender,
    required this.joiningDate,
    required this.salary,
    this.assignedSubjects = const [],
    this.assignedBatchIds = const [],
    this.profileImage,
    this.status = 'active',
    required this.createdAt,
  });

  factory TeacherModel.fromJson(Map<String, dynamic> json) {
    return TeacherModel(
      id: json['_id'] ?? json['id'] ?? '',
      fullName: json['full_name'] ?? '',
      subject: json['subject'] ?? '',
      qualification: json['qualification'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      gender: json['gender'] ?? '',
      joiningDate: json['joining_date'] != null
          ? DateTime.parse(json['joining_date'])
          : DateTime.now(),
      salary: (json['salary'] ?? 0).toDouble(),
      assignedSubjects: json['assigned_subjects'] != null
          ? List<String>.from(json['assigned_subjects'])
          : [],
      assignedBatchIds: json['assigned_batch_ids'] != null
          ? List<String>.from(json['assigned_batch_ids'])
          : [],
      profileImage: json['profile_image'],
      status: json['status'] ?? 'active',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'full_name': fullName,
      'subject': subject,
      'qualification': qualification,
      'phone': phone,
      'email': email,
      'gender': gender,
      'joining_date': joiningDate.toIso8601String(),
      'salary': salary,
      'assigned_subjects': assignedSubjects,
      'assigned_batch_ids': assignedBatchIds,
      'profile_image': profileImage,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
