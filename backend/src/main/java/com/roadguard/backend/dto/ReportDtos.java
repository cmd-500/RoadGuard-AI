package com.roadguard.backend.dto;

import com.roadguard.backend.entity.Report;
import jakarta.validation.constraints.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.locationtech.jts.geom.Point;

import java.time.LocalDateTime;
import java.util.List;

public class ReportDtos {

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class CreateRequest {
        @NotBlank
        @Size(min = 3, max = 200)
        private String title;

        @NotBlank
        @Size(min = 5, max = 2000)
        private String description;

        @NotBlank
        @Size(min = 3, max = 500)
        private String address;

        @NotNull
        private Report.HazardType hazardType;

        @NotNull
        private Report.Severity severity;

        @NotNull
        private Double latitude;

        @NotNull
        private Double longitude;
    }

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class Response {
        private String id;
        private String title;
        private String description;
        private String address;
        private Report.HazardType hazardType;
        private Report.Severity severity;
        private Double latitude;
        private Double longitude;
        private String imageUrl;
        private VerificationResponse verification;
        private Report.Status status;
        private Report.CommunityStatus communityStatus;
        private Integer voteScore;
        private Integer upvoteCount;
        private Integer downvoteCount;
        private UserInfo createdBy;
        private LocalDateTime createdAt;
        private LocalDateTime updatedAt;

        @Data
        @Builder
        @NoArgsConstructor
        @AllArgsConstructor
        public static class VerificationResponse {
            private Report.Verification.VerificationStatus status;
            private List<String> reasons;
            private Double blurScore;
            private Boolean isBlurry;
            private String imageHash;
            private Boolean gpsMatch;
            private Double gpsDistanceMeters;
            private String duplicateOfReport;
            private Boolean trustEffectApplied;
        }

        @Data
        @Builder
        @NoArgsConstructor
        @AllArgsConstructor
        public static class UserInfo {
            private String id;
            private String name;
            private Integer trustScore;
            private boolean isTrusted;
        }
    }

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class NearbyReportResponse {
        private String id;
        private String title;
        private Report.HazardType hazardType;
        private Report.Severity severity;
        private Double latitude;
        private Double longitude;
        private String imageUrl;
        private Integer distanceMeters;
        private Report.CommunityStatus communityStatus;
        private Integer voteScore;
        private UserInfo createdBy;

        @Data
        @Builder
        @NoArgsConstructor
        @AllArgsConstructor
        public static class UserInfo {
            private String id;
            private String name;
            private Integer trustScore;
            private boolean isTrusted;
        }
    }

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class RouteHazardResponse {
        private Response report;
        private Double distanceToRouteMeters;
        private Double distanceFromStartMeters;
        private Integer waypointIndex;
    }

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class CheckRouteRequest {
        private List<Waypoint> waypoints;
        @Builder.Default
        private Double bufferMeters = 150.0;

        @Data
        @Builder
        @NoArgsConstructor
        @AllArgsConstructor
        public static class Waypoint {
            private Double latitude;
            private Double longitude;
        }
    }

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class UpdateStatusRequest {
        @NotNull
        private Report.Status status;
    }
}