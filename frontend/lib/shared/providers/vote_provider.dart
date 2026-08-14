import 'package:flutter/foundation.dart';
import '../../repositories/vote_repository.dart';
import '../../models/vote.dart';
import '../../models/report.dart';

class VoteProvider extends ChangeNotifier {
  final VoteRepository _repository;

  VoteProvider({required VoteRepository repository}) : _repository = repository;

  VoteStatus? _voteStatus;
  bool _isLoading = false;
  String? _error;

  VoteStatus? get voteStatus => _voteStatus;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<bool> castVote(String reportId, VoteType voteType) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.castVote(reportId, voteType);
      await fetchVoteStatus(reportId);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> fetchVoteStatus(String reportId) async {
    try {
      _voteStatus = await _repository.getVoteStatus(reportId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}