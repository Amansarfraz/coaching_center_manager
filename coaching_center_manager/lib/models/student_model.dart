class StudentModel {
  final String id;
  final String fullName;
  final String fatherName;
  final String phone;
  final String email;
  final String homeAddress;
  final String gender; // 'male', 'female', 'other'
  final DateTime dob;
  final DateTime admissionDate;
  final String batchId;
  final String batchName;
  final double monthlyFee;
  final String? profileImage;
  final String status; // 'active', 'inactive', 'pending'
  final DateTime createdAt;

  StudentModel({
    required this.id,
    required this.fullName,
    required this.fatherName,
    required this.phone,
    required this.email,
    required this.homeAddress,
    required this.gender,
    required this.dob,
    required this.admissionDate,
    required this.batchId,
    required this.batchName,
    required this.monthlyFee,
    this.profileImage,
    this.status = 'active',
    required this.createdAt,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['_id'] ?? json['id'] ?? '',
      fullName: json['full_name'] ?? '',
      fatherName: json['father_name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      homeAddress: json['home_address'] ?? '',
      gender: json['gender'] ?? '',
      dob: json['dob'] != null ? DateTime.parse(json['dob']) : DateTime.now(),
      admissionDate: json['admission_date'] != null
          ? DateTime.parse(json['admission_date'])
          : DateTime.now(),
      batchId: json['batch_id'] ?? '',
      batchName: json['batch_name'] ?? '',
      monthlyFee: (json['monthly_fee'] ?? 0).toDouble(),
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
      'father_name': fatherName,
      'phone': phone,
      'email': email,
      'home_address': homeAddress,
      'gender': gender,
      'dob': dob.toIso8601String(),
      'admission_date': admissionDate.toIso8601String(),
      'batch_id': batchId,
      'batch_name': batchName,
      'monthly_fee': monthlyFee,
      'profile_image': profileImage,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
