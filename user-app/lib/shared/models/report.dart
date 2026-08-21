import 'package:flutter/material.dart';

enum HazardType {
  pothole,
  accident,
  fog,
  speedBreaker,
  unmarkedBreaker,
  illegalBreaker,
  waterlogging,
  waterloggedHazard,
  roadDamage,
  construction,
  emergency,
  other,
}

enum Severity {
  low,
  medium,
  high,
  critical,
}

extension BackendEnumName on Enum {
  String toBackendName() {
    final buffer = StringBuffer();
    for (final rune in name.runes) {
      final char = String.fromCharCode(rune);
      if (char == char.toUpperCase() && char != char.toLowerCase()) {
        buffer.write('_');
      }
      buffer.write(char.toUpperCase());
    }
    return buffer.toString();
  }
}

enum ReportStatus {
  pending,
  inProgress,
  resolved,
  rejected,
}

enum CommunityStatus {
  unverified,
  confirmed,
  disputed,
}

enum VerificationStatus {
  passed,
  flagged,
}

class Report {
  final String id;
  final String title;
  final String description;
  final String address;
  final HazardType hazardType;
  final Severity severity;
  final double latitude;
  final longitude;
  final String imageUrl;
  final String imagePublicId;
  final Verification verification;
  final ReportStatus status;
  final CommunityStatus communityStatus;
  final int voteScore;
  final int upvoteCount;
  final int downvoteCount;
  final String createdBy;
  final UserSummary? creator;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Report({
    required this.id,
    required this.title,
    required this.description,
    required this.address,
    required this.hazardType,
    required this.severity,
    required this.latitude,
    required this.longitude,
    required this.imageUrl,
    required this.imagePublicId,
    required this.verification,
    required this.status,
    required this.communityStatus,
    required this.voteScore,
    required this.upvoteCount,
    required this.downvoteCount,
    required this.createdBy,
    this.creator,
    required this.createdAt,
    required this.updatedAt,
  });

  String get hazardTypeDisplay {
    switch (hazardType) {
      case HazardType.pothole:
        return 'Pothole';
      case HazardType.accident:
        return 'Accident';
      case HazardType.fog:
        return 'Fog';
      case HazardType.speedBreaker:
        return 'Speed Breaker';
      case HazardType.unmarkedBreaker:
        return 'Unmarked Breaker';
      case HazardType.illegalBreaker:
        return 'Illegal Breaker';
      case HazardType.waterlogging:
      case HazardType.waterloggedHazard:
        return 'Waterlogging';
      case HazardType.roadDamage:
        return 'Road Damage';
      case HazardType.construction:
        return 'Construction';
      case HazardType.emergency:
        return 'Emergency';
      case HazardType.other:
        return 'Other';
    }
  }

  String get severityDisplay {
    return severity.name.toUpperCase();
  }

  String get statusDisplay {
    switch (status) {
      case ReportStatus.pending:
        return 'PENDING';
      case ReportStatus.inProgress:
        return 'IN PROGRESS';
      case ReportStatus.resolved:
        return 'RESOLVED';
      case ReportStatus.rejected:
        return 'REJECTED';
    }
  }

  String get communityStatusDisplay {
    switch (communityStatus) {
      case CommunityStatus.unverified:
        return 'UNVERIFIED';
      case CommunityStatus.confirmed:
        return 'CONFIRMED';
      case CommunityStatus.disputed:
        return 'DISPUTED';
    }
  }

  Color get severityColor {
    switch (severity) {
      case Severity.critical:
        return const Color(0xFFC0392B);
      case Severity.high:
        return const Color(0xFFE07A2C);
      case Severity.medium:
        return const Color(0xFFD4A72C);
      case Severity.low:
        return const Color(0xFF4A8C6D);
    }
  }

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      hazardType: _parseHazardType(json['hazardType']),
      severity: _parseSeverity(json['severity']),
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      imageUrl: json['imageUrl'] ?? '',
      imagePublicId: json['imagePublicId'] ?? '',
      verification: Verification.fromJson(json['verification'] ?? {}),
      status: _parseReportStatus(json['status']),
      communityStatus: parseCommunityStatus(json['communityStatus']),
      voteScore: json['voteScore'] ?? 0,
      upvoteCount: json['upvoteCount'] ?? 0,
      downvoteCount: json['downvoteCount'] ?? 0,
      createdBy: json['createdBy'] is Map
          ? (json['createdBy']['id'] ?? '')
          : (json['createdBy'] ?? ''),
      creator: json['createdBy'] is Map ? UserSummary.fromJson(json['createdBy']) : null,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'address': address,
      'hazardType': hazardType.name.toUpperCase(),
      'severity': severity.name.toUpperCase(),
      'latitude': latitude,
      'longitude': longitude,
      'imageUrl': imageUrl,
      'imagePublicId': imagePublicId,
      'verification': verification.toJson(),
      'status': status.name.toUpperCase(),
      'communityStatus': communityStatus.name.toUpperCase(),
      'voteScore': voteScore,
      'upvoteCount': upvoteCount,
      'downvoteCount': downvoteCount,
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  static HazardType _parseHazardType(String? value) {
    switch (value?.toUpperCase()) {
      case 'POTHOLE':
        return HazardType.pothole;
      case 'ACCIDENT':
        return HazardType.accident;
      case 'FOG':
        return HazardType.fog;
      case 'SPEED_BREAKER':
        return HazardType.speedBreaker;
      case 'UNMARKED_BREAKER':
        return HazardType.unmarkedBreaker;
      case 'ILLEGAL_BREAKER':
        return HazardType.illegalBreaker;
      case 'WATERLOGGING':
      case 'WATERLOGGED_HAZARD':
        return HazardType.waterlogging;
      case 'ROAD_DAMAGE':
        return HazardType.roadDamage;
      case 'CONSTRUCTION':
        return HazardType.construction;
      case 'EMERGENCY':
        return HazardType.emergency;
      default:
        return HazardType.other;
    }
  }

  static Severity _parseSeverity(String? value) {
    switch (value?.toUpperCase()) {
      case 'LOW':
        return Severity.low;
      case 'MEDIUM':
        return Severity.medium;
      case 'HIGH':
        return Severity.high;
      case 'CRITICAL':
        return Severity.critical;
      default:
        return Severity.medium;
    }
  }

  static ReportStatus _parseReportStatus(String? value) {
    switch (value?.toUpperCase()) {
      case 'PENDING':
        return ReportStatus.pending;
      case 'IN_PROGRESS':
      case 'IN PROGRESS':
        return ReportStatus.inProgress;
      case 'RESOLVED':
        return ReportStatus.resolved;
      case 'REJECTED':
        return ReportStatus.rejected;
      default:
        return ReportStatus.pending;
    }
  }

  static CommunityStatus parseCommunityStatus(String? value) {
    switch (value?.toUpperCase()) {
      case 'UNVERIFIED':
        return CommunityStatus.unverified;
      case 'CONFIRMED':
        return CommunityStatus.confirmed;
      case 'DISPUTED':
        return CommunityStatus.disputed;
      default:
        return CommunityStatus.unverified;
    }
  }
}

class Verification {
  final VerificationStatus status;
  final List<String> reasons;
  final double? blurScore;
  final bool? isBlurry;
  final String? imageHash;
  final bool? gpsMatch;
  final double? gpsDistanceMeters;
  final String? duplicateOfReport;
  final bool trustEffectApplied;

  const Verification({
    required this.status,
    required this.reasons,
    this.blurScore,
    this.isBlurry,
    this.imageHash,
    this.gpsMatch,
    this.gpsDistanceMeters,
    this.duplicateOfReport,
    required this.trustEffectApplied,
  });

  factory Verification.fromJson(Map<String, dynamic> json) {
    return Verification(
      status: json['status'] == 'FLAGGED' ? VerificationStatus.flagged : VerificationStatus.passed,
      reasons: (json['reasons'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      blurScore: (json['blurScore'] as num?)?.toDouble(),
      isBlurry: json['isBlurry'],
      imageHash: json['imageHash'],
      gpsMatch: json['gpsMatch'],
      gpsDistanceMeters: (json['gpsDistanceMeters'] as num?)?.toDouble(),
      duplicateOfReport: json['duplicateOfReport'],
      trustEffectApplied: json['trustEffectApplied'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status.name.toUpperCase(),
      'reasons': reasons,
      'blurScore': blurScore,
      'isBlurry': isBlurry,
      'imageHash': imageHash,
      'gpsMatch': gpsMatch,
      'gpsDistanceMeters': gpsDistanceMeters,
      'duplicateOfReport': duplicateOfReport,
      'trustEffectApplied': trustEffectApplied,
    };
  }
}

class UserSummary {
  final String id;
  final String name;
  final int trustScore;
  final bool isTrusted;

  const UserSummary({
    required this.id,
    required this.name,
    required this.trustScore,
    required this.isTrusted,
  });

  factory UserSummary.fromJson(Map<String, dynamic> json) {
    return UserSummary(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      trustScore: json['trustScore'] ?? 50,
      isTrusted: json['isTrusted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'trustScore': trustScore,
      'isTrusted': isTrusted,
    };
  }
}

class NearbyReport {
  final String id;
  final String title;
  final HazardType hazardType;
  final Severity severity;
  final double latitude;
  final double longitude;
  final String imageUrl;
  final int distanceMeters;
  final CommunityStatus communityStatus;
  final int voteScore;
  final UserSummary? creator;

  const NearbyReport({
    required this.id,
    required this.title,
    required this.hazardType,
    required this.severity,
    required this.latitude,
    required this.longitude,
    required this.imageUrl,
    required this.distanceMeters,
    required this.communityStatus,
    required this.voteScore,
    this.creator,
  });

  factory NearbyReport.fromJson(Map<String, dynamic> json) {
    return NearbyReport(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      hazardType: Report._parseHazardType(json['hazardType']),
      severity: Report._parseSeverity(json['severity']),
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      imageUrl: json['imageUrl'] ?? '',
      distanceMeters: json['distanceMeters'] ?? 0,
      communityStatus: Report.parseCommunityStatus(json['communityStatus']),
      voteScore: json['voteScore'] ?? 0,
      creator: json['createdBy'] != null ? UserSummary.fromJson(json['createdBy']) : null,
    );
  }
}

class RouteHazard {
  final Report report;
  final double distanceToRouteMeters;
  final double distanceFromStartMeters;
  final int waypointIndex;

  const RouteHazard({
    required this.report,
    required this.distanceToRouteMeters,
    required this.distanceFromStartMeters,
    required this.waypointIndex,
  });

  factory RouteHazard.fromJson(Map<String, dynamic> json) {
    return RouteHazard(
      report: Report.fromJson(json['report']),
      distanceToRouteMeters: (json['distanceToRouteMeters'] ?? 0).toDouble(),
      distanceFromStartMeters: (json['distanceFromStartMeters'] ?? 0).toDouble(),
      waypointIndex: json['waypointIndex'] ?? 0,
    );
  }
}