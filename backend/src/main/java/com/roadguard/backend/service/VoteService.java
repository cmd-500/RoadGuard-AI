package com.roadguard.backend.service;

import com.roadguard.backend.dto.VoteDtos;
import com.roadguard.backend.entity.Report;
import com.roadguard.backend.entity.User;
import com.roadguard.backend.entity.Vote;
import com.roadguard.backend.exception.ApiException;
import com.roadguard.backend.repository.ReportRepository;
import com.roadguard.backend.repository.UserRepository;
import com.roadguard.backend.repository.VoteRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.UUID;

@Service
@RequiredArgsConstructor
public class VoteService {

    private final VoteRepository voteRepository;
    private final ReportRepository reportRepository;
    private final UserRepository userRepository;
    private final TrustService trustService;

    @Transactional
    public VoteDtos.VoteResponse castVote(String reportId, VoteDtos.VoteRequest request, String userId) {
        UUID reportUuid = UUID.fromString(reportId);
        UUID userUuid = UUID.fromString(userId);

        Report report = reportRepository.findById(reportUuid)
                .orElseThrow(() -> ApiException.notFound("REPORT_NOT_FOUND", "Report not found"));

        if (userUuid.equals(report.getCreatedBy())) {
            throw ApiException.badRequest("SELF_VOTE", "You cannot vote on your own report");
        }

        User voter = userRepository.findById(userUuid)
                .orElseThrow(() -> ApiException.notFound("USER_NOT_FOUND", "User not found"));

        int weight = trustService.getVoteWeight(voter);
        Vote existingVote = voteRepository.findByReportIdAndUserId(reportUuid, userUuid).orElse(null);

        if (existingVote != null) {
            if (existingVote.getVoteType() == request.getVoteType()) {
                throw ApiException.badRequest("ALREADY_VOTED", "You already cast this vote");
            }

            // Switching vote
            report.setVoteScore(report.getVoteScore() - existingVote.getSignedWeight());
            if (existingVote.getVoteType() == Vote.VoteType.UPVOTE) {
                report.setUpvoteCount(report.getUpvoteCount() - 1);
            } else {
                report.setDownvoteCount(report.getDownvoteCount() - 1);
            }

            existingVote.setVoteType(request.getVoteType());
            existingVote.setWeight(weight);
            voteRepository.save(existingVote);
        } else {
            Vote vote = Vote.builder()
                    .reportId(reportUuid)
                    .userId(userUuid)
                    .voteType(request.getVoteType())
                    .weight(weight)
                    .build();
            voteRepository.save(vote);
        }

        report.setVoteScore(report.getVoteScore() + (request.getVoteType() == Vote.VoteType.UPVOTE ? weight : -weight));
        if (request.getVoteType() == Vote.VoteType.UPVOTE) {
            report.setUpvoteCount(report.getUpvoteCount() + 1);
        } else {
            report.setDownvoteCount(report.getDownvoteCount() + 1);
        }

        trustService.applyCommunityOutcome(report);
        reportRepository.save(report);

        return VoteDtos.VoteResponse.builder()
                .id(existingVote != null ? existingVote.getId().toString() : "")
                .reportId(reportId)
                .userId(userId)
                .voteType(request.getVoteType())
                .weight(weight)
                .build();
    }

    public VoteDtos.VoteStatusResponse getVoteStatus(String reportId, String userId) {
        UUID reportUuid = UUID.fromString(reportId);
        UUID userUuid = UUID.fromString(userId);

        Report report = reportRepository.findById(reportUuid)
                .orElseThrow(() -> ApiException.notFound("REPORT_NOT_FOUND", "Report not found"));

        Vote.VoteType userVote = voteRepository.findByReportIdAndUserId(reportUuid, userUuid)
                .map(Vote::getVoteType)
                .orElse(null);

        return VoteDtos.VoteStatusResponse.builder()
                .reportId(reportId)
                .voteScore(report.getVoteScore())
                .upvoteCount(report.getUpvoteCount())
                .downvoteCount(report.getDownvoteCount())
                .communityStatus(report.getCommunityStatus())
                .userVote(userVote)
                .build();
    }
}