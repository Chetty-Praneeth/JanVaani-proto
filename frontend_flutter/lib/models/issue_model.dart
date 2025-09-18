class IssueModel {
  final int id;
  final String title;
  final String description;
  final String category;
  final String status;
  final String createdBy; 
  final String? assignedTo;
  final String? imageUrl;
  final String location;
  final String? additionalInformation;
  final DateTime createdAt;
  final DateTime? updatedAt;

  IssueModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.status,
    required this.createdBy,
    this.assignedTo,
    this.imageUrl,
    required this.location,
    this.additionalInformation,
    required this.createdAt,
    this.updatedAt,
  });

  factory IssueModel.fromJson(Map<String, dynamic> json) {
    return IssueModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      status: json['status'],
      createdBy: json['created_by'],
      assignedTo: json['assigned_to'],
      imageUrl: json['image_url'],
      location: json['location'] ?? '',
      additionalInformation: json['additional_information'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'status': status,
      'created_by': createdBy,
      'assigned_to': assignedTo,
      'image_url': imageUrl,
      'location': location,
      'additional_information': additionalInformation,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
