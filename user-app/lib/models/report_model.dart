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
  final String? imageUrl;
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
    this.imageUrl,
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
    // Backend returns location as GeoJSON Point with coordinates [lng, lat]
    double latitude, longitude;
    if (json['location'] is Map && json['location']['coordinates'] is List) {
      final coords = json['location']['coordinates'] as List;
      longitude = (coords[0] as num).toDouble();
      latitude = (coords[1] as num).toDouble();
    } else if (json['latitude'] != null && json['longitude'] != null) {
      // Fallback for direct lat/lng fields
      latitude = (json['latitude'] as num).toDouble();
      longitude = (json['longitude'] as num).toDouble();
    } else {
      latitude = 0;
      longitude = 0;
    }

    // Handle both old and new field names for status
    final status = json['report_status'] ?? json['status'] ?? 'PENDING';
    final communityStatus = json['community_status'] ?? json['communityStatus'] ?? 'UNVERIFIED';

    return ReportModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      hazardType: json['hazard_type'] ?? json['hazardType'] ?? 'OTHER',
      severity: json['severity'] ?? 'LOW',
      longitude: longitude,
      latitude: latitude,
      imageUrl: json['image_url'] ?? json['imageUrl'] ?? '',
      status: status,
      communityStatus: communityStatus,
      voteScore: (json['vote_score'] ?? json['voteScore'] ?? 0) as int,
      upvoteCount: (json['upvote_count'] ?? json['upvoteCount'] ?? 0) as int,
      downvoteCount: (json['downvote_count'] ?? json['downvoteCount'] ?? 0) as int,
      verification: ReportVerification.fromJson(json['verification'] ?? {}),
      createdBy: json['createdBy'] is Map ? UserModel.fromJson(json['createdBy']) : null,
      createdAt: DateTime.tryParse(json['created_at'] ?? json['createdAt'] ?? '') ?? DateTime.now(),
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