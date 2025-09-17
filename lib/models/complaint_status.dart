class ComplaintStatus {
  final String id;
  final String issueId;
  final String status; // Submitted, In Progress, Resolved
  final String updatedBy; // admin/user
  final DateTime updatedAt;

  ComplaintStatus({
    required this.id,
    required this.issueId,
    required this.status,
    required this.updatedBy,
    required this.updatedAt,
  });

  factory ComplaintStatus.fromJson(Map<String, dynamic> json) {
    return ComplaintStatus(
      id: json['id'] ?? '',
      issueId: json['issue_id'] ?? '',
      status: json['status'] ?? 'Submitted',
      updatedBy: json['updated_by'] ?? '',
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'issue_id': issueId,
      'status': status,
      'updated_by': updatedBy,
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
