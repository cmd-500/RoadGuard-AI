import 'user_model.dart';

class ReportVerification {
  final String status;
  final List<String> reasons;
  final bool? isBlurry;
  final bool? gpsMatch;

  ReportVerification({required this.status, required this.reasons, this.isBlurry, this.gpsMatch});

  factory ReportVerification.fromJson(Map<String, dynamic> json) {
    return ReportVerification(
      status: json['status'] ?? 'PASSED',
      reasons: (json['reasons'] as List?)?.map((e) => e.toString()).toList() ?? [],
      isBlurry: json['isBlurry'],
      gpsMatch: json['gpsMatch'],
    );
  }
}

class ReportModel {
  final String id;
  final String title;
  final String description;
  final String address;
  final String hazardType;
  final String severity;
  final double latitude;
  final double longitude;
  final String imageUrl;
  final String status;
  final String communityStatus;
  final int voteScore;
  final int upvoteCount;
  final int downvoteCount;
  final ReportVerification verification;
  final UserModel? createdBy;
  final DateTime createdAt;

  // present only on route-check results
  final double? distanceToRouteMeters;
  final double? distanceFromStartMeters;

  ReportModel({
    required this.id,
    required this.title,
    required this.description,
    required this.address,
    required this.hazardType,
    required this.severity,
    required this.latitude,
    required this.longitude,
    required this.imageUrl,
    required this.status,
    required this.communityStatus,
    required this.voteScore,
    required this.upvoteCount,
    required this.downvoteCount,
    required this.verification,
    required this.createdAt,
    this.createdBy,
    this.distanceToRouteMeters,
    this.distanceFromStartMeters,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    final coords = json['location']['coordinates'] as List;
    return ReportModel(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      address: json['address'],
      hazardType: json['hazardType'],
      severity: json['severity'],
      longitude: (coords[0] as num).toDouble(),
      latitude: (coords[1] as num).toDouble(),
      imageUrl: json['imageUrl'],
      status: json['status'],
      communityStatus: json['communityStatus'],
      voteScore: json['voteScore'] ?? 0,
      upvoteCount: json['upvoteCount'] ?? 0,
      downvoteCount: json['downvoteCount'] ?? 0,
      verification: ReportVerification.fromJson(json['verification'] ?? {}),
      createdBy: json['createdBy'] is Map ? UserModel.fromJson(json['createdBy']) : null,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  // route-check response wraps each report as { report, distanceToRouteMeters, distanceFromStartMeters }
  factory ReportModel.fromRouteCheckJson(Map<String, dynamic> json) {
    final base = ReportModel.fromJson(json['report']);
    return ReportModel(
      id: base.id,
      title: base.title,
      description: base.description,
      address: base.address,
      hazardType: base.hazardType,
      severity: base.severity,
      latitude: base.latitude,
      longitude: base.longitude,
      imageUrl: base.imageUrl,
      status: base.status,
      communityStatus: base.communityStatus,
      voteScore: base.voteScore,
      upvoteCount: base.upvoteCount,
      downvoteCount: base.downvoteCount,
      verification: base.verification,
      createdBy: base.createdBy,
      createdAt: base.createdAt,
      distanceToRouteMeters: (json['distanceToRouteMeters'] as num?)?.toDouble(),
      distanceFromStartMeters: (json['distanceFromStartMeters'] as num?)?.toDouble(),
    );
  }
}
