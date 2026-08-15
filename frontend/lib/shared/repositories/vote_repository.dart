import 'package:dio/dio.dart';
import '../services/api_client.dart';
import '../models/vote.dart';
import '../models/report.dart';

abstract class VoteRepository {
  Future<Vote> castVote(String reportId, VoteType voteType);
  Future<VoteStatus> getVoteStatus(String reportId);
}

class VoteRepositoryImpl implements VoteRepository {
  final ApiClient _apiClient;

  VoteRepositoryImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<Vote> castVote(String reportId, VoteType voteType) async {
    try {
      final response = await _apiClient.castVote(reportId, voteType.name.toUpperCase());
      return Vote.fromJson(response['data']);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<VoteStatus> getVoteStatus(String reportId) async {
    try {
      final response = await _apiClient.getVoteStatus(reportId);
      return VoteStatus.fromJson(response['data']);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(dynamic error) {
    if (error is DioException) {
      final message = error.response?.data?['message'] ?? error.message ?? 'An error occurred';
      return Exception(message);
    }
    return Exception(error.toString());
  }
}