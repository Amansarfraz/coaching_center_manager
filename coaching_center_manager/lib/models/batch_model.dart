class BatchModel {
  final String id;
  final String batchName;
  final String courseName;
  final String teacherId;
  final String teacherName;
  final String classroom;
  final String timing; // e.g. "MWF 09:30 - 11:00"
  final int studentCapacity;
  final int totalStudents;
  final DateTime startDate;
  final DateTime? endDate;
  final String status; // 'active', 'completed', 'upcoming'
  final DateTime createdAt;

  BatchModel({
    required this.id,
    required this.batchName,
    required this.courseName,
    required this.teacherId,
    required this.teacherName,
    required this.classroom,
    required this.timing,
    required this.studentCapacity,
    this.totalStudents = 0,
    required this.startDate,
    this.endDate,
    this.status = 'active',
    required this.createdAt,
  });

  factory BatchModel.fromJson(Map<String, dynamic> json) {
    return BatchModel(
      id: json['_id'] ?? json['id'] ?? '',
      batchName: json['batch_name'] ?? '',
      courseName: json['course_name'] ?? '',
      teacherId: json['teacher_id'] ?? '',
      teacherName: json['teacher_name'] ?? '',
      classroom: json['classroom'] ?? '',
      timing: json['timing'] ?? '',
      studentCapacity: json['student_capacity'] ?? 0,
      totalStudents: json['total_students'] ?? 0,
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'])
          : DateTime.now(),
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'])
          : null,
      status: json['status'] ?? 'active',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'batch_name': batchName,
      'course_name': courseName,
      'teacher_id': teacherId,
      'teacher_name': teacherName,
      'classroom': classroom,
      'timing': timing,
      'student_capacity': studentCapacity,
      'total_students': totalStudents,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
