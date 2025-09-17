// lib/models/issue_model.dart

class IssueModel {
  final String id;
  final String title;
  final String description;
  final String category; // e.g. Roads, Water, Electricity
  final String status; // e.g. Pending, Assigned, Resolved, Verified
  final String userId;
  final double? latitude;
  final double? longitude;
  final String? imageUrl;
  final DateTime createdAt;

  IssueModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.status,
    required this.userId,
    this.latitude,
    this.longitude,
    this.imageUrl,
    required this.createdAt,
  });

  /// Convert JSON → IssueModel
  factory IssueModel.fromJson(Map<String, dynamic> json) {
    return IssueModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      // Default to "Pending" if nothing is provided
      status: json['status'] ?? 'Pending',
      userId: json['user_id'] ?? '',
      latitude: (json['latitude'] != null)
          ? (json['latitude'] as num).toDouble()
          : null,
      longitude: (json['longitude'] != null)
          ? (json['longitude'] as num).toDouble()
          : null,
      imageUrl: json['image_url'],
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  /// Convert IssueModel → JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'status': status,
      'user_id': userId,
      'latitude': latitude,
      'longitude': longitude,
      'image_url': imageUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
