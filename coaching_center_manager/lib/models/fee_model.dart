class FeeModel {
  final String id;
  final String studentId;
  final String studentName;
  final String batchId;
  final String batchName;
  final String feeMonth; // e.g. "October 2025"
  final double totalFee;
  final double paidAmount;
  final double remainingBalance;
  final String paymentMethod; // 'cash', 'jazzcash', 'easypaisa', 'bank'
  final DateTime paymentDate;
  final String status; // 'paid', 'unpaid', 'partial'
  final DateTime createdAt;

  FeeModel({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.batchId,
    required this.batchName,
    required this.feeMonth,
    required this.totalFee,
    required this.paidAmount,
    required this.remainingBalance,
    required this.paymentMethod,
    required this.paymentDate,
    required this.status,
    required this.createdAt,
  });

  factory FeeModel.fromJson(Map<String, dynamic> json) {
    return FeeModel(
      id: json['_id'] ?? json['id'] ?? '',
      studentId: json['student_id'] ?? '',
      studentName: json['student_name'] ?? '',
      batchId: json['batch_id'] ?? '',
      batchName: json['batch_name'] ?? '',
      feeMonth: json['fee_month'] ?? '',
      totalFee: (json['total_fee'] ?? 0).toDouble(),
      paidAmount: (json['paid_amount'] ?? 0).toDouble(),
      remainingBalance: (json['remaining_balance'] ?? 0).toDouble(),
      paymentMethod: json['payment_method'] ?? '',
      paymentDate: json['payment_date'] != null
          ? DateTime.parse(json['payment_date'])
          : DateTime.now(),
      status: json['status'] ?? 'unpaid',
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
      'fee_month': feeMonth,
      'total_fee': totalFee,
      'paid_amount': paidAmount,
      'remaining_balance': remainingBalance,
      'payment_method': paymentMethod,
      'payment_date': paymentDate.toIso8601String(),
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
