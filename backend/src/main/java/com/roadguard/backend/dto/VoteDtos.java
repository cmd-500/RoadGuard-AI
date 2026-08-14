package com.roadguard.backend.dto;

import com.roadguard.backend.entity.Vote;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

public class VoteDtos {

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class VoteRequest {
        @NotNull
        private Vote.VoteType voteType;
    }

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class VoteResponse {
        private String id;
        private String reportId;
        private String userId;
        private Vote.VoteType voteType;
        private Integer weight;
        private java.time.LocalDateTime createdAt;
    }

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class VoteStatusResponse {
        private String reportId;
        private Integer voteScore;
        private Integer upvoteCount;
        private Integer downvoteCount;
        private com.roadguard.backend.entity.Report.CommunityStatus communityStatus;
        private Vote.VoteType userVote;
    }
}