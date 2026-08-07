class AttendanceModel {
  final String id;
  final String studentId;
  final String studentName;
  final String batchId;
  final String batchName;
  final DateTime date;
  final String status; // 'present', 'absent', 'leave'
  final String markedBy; // teacher/admin id
  final DateTime createdAt;

  AttendanceModel({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.batchId,
    required this.batchName,
    required this.date,
    required this.status,
    required this.markedBy,
    required this.createdAt,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['_id'] ?? json['id'] ?? '',
      studentId: json['student_id'] ?? '',
      studentName: json['student_name'] ?? '',
      batchId: json['batch_id'] ?? '',
      batchName: json['batch_name'] ?? '',
      date: json['date'] != null
          ? DateTime.parse(json['date'])
          : DateTime.now(),
      status: json['status'] ?? 'present',
      markedBy: json['marked_by'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'student_id': studentId,
      'student_name': studentName,
      'batch_id': batchId,
      'batch_name': batchName,
      'date': date.toIso8601String(),
      'status': status,
      'marked_by': markedBy,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
