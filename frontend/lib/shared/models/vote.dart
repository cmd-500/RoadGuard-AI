import 'report.dart';

enum VoteType { upvote, downvote }

class Vote {
  final String id;
  final String reportId;
  final String userId;
  final VoteType voteType;
  final int weight;
  final DateTime createdAt;

  const Vote({
    required this.id,
    required this.reportId,
    required this.userId,
    required this.voteType,
    required this.weight,
    required this.createdAt,
  });

  int get signedWeight => voteType == VoteType.upvote ? weight : -weight;

  factory Vote.fromJson(Map<String, dynamic> json) {
    return Vote(
      id: json['id'] ?? '',
      reportId: json['reportId'] ?? '',
      userId: json['userId'] ?? '',
      voteType: json['voteType'] == 'UPVOTE' ? VoteType.upvote : VoteType.downvote,
      weight: json['weight'] ?? 1,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reportId': reportId,
      'userId': userId,
      'voteType': voteType.name.toUpperCase(),
      'weight': weight,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class VoteStatus {
  final String reportId;
  final int voteScore;
  final int upvoteCount;
  final int downvoteCount;
  final CommunityStatus communityStatus;
  final VoteType? userVote;

  const VoteStatus({
    required this.reportId,
    required this.voteScore,
    required this.upvoteCount,
    required this.downvoteCount,
    required this.communityStatus,
    this.userVote,
  });

  factory VoteStatus.fromJson(Map<String, dynamic> json) {
    return VoteStatus(
      reportId: json['reportId'] ?? '',
      voteScore: json['voteScore'] ?? 0,
      upvoteCount: json['upvoteCount'] ?? 0,
      downvoteCount: json['downvoteCount'] ?? 0,
      communityStatus: Report.parseCommunityStatus(json['communityStatus']),
      userVote: json['userVote'] != null
          ? (json['userVote'] == 'UPVOTE' ? VoteType.upvote : VoteType.downvote)
          : null,
    );
  }
}