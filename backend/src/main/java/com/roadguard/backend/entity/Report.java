package com.roadguard.backend.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
import org.locationtech.jts.geom.Point;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "reports", indexes = {
    @Index(name = "idx_report_location", columnList = "location"),
    @Index(name = "idx_report_status", columnList = "status"),
    @Index(name = "idx_report_hazard_type", columnList = "hazard_type"),
    @Index(name = "idx_report_created_by", columnList = "created_by"),
    @Index(name = "idx_report_community_status", columnList = "community_status")
})
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Report {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private String id;

    @Column(nullable = false)
    private String title;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String description;

    @Column(nullable = false)
    private String address;

    @Enumerated(EnumType.STRING)
    @Column(name = "hazard_type", nullable = false)
    private HazardType hazardType;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Severity severity;

    @Column(name = "location", nullable = false, columnDefinition = "geometry(Point, 4326)")
    private Point location;

    @Column(name = "image_url", nullable = false)
    private String imageUrl;

    @Column(name = "image_public_id", nullable = false)
    private String imagePublicId;

    @Embedded
    @Builder.Default
    private Verification verification = new Verification();

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    @Builder.Default
    private Status status = Status.PENDING;

    @Enumerated(EnumType.STRING)
    @Column(name = "community_status", nullable = false)
    @Builder.Default
    private CommunityStatus communityStatus = CommunityStatus.UNVERIFIED;

    @Column(name = "vote_score", nullable = false)
    @Builder.Default
    private Integer voteScore = 0;

    @Column(name = "upvote_count", nullable = false)
    @Builder.Default
    private Integer upvoteCount = 0;

    @Column(name = "downvote_count", nullable = false)
    @Builder.Default
    private Integer downvoteCount = 0;

    @Column(name = "created_by", nullable = false)
    private String createdBy;

    @CreationTimestamp
    @Column(updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    private LocalDateTime updatedAt;

    public enum HazardType {
        POTHOLE, UNMARKED_BREAKER, ILLEGAL_BREAKER, WATERLOGGED_HAZARD, OTHER
    }

    public enum Severity {
        LOW, MEDIUM, HIGH, CRITICAL
    }

    public enum Status {
        PENDING, IN_PROGRESS, RESOLVED, REJECTED
    }

    public enum CommunityStatus {
        UNVERIFIED, CONFIRMED, DISPUTED
    }

    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    @Embeddable
    public static class Verification {
        @Enumerated(EnumType.STRING)
        @Builder.Default
        private VerificationStatus status = VerificationStatus.PASSED;

        @ElementCollection
        @CollectionTable(name = "verification_reasons", joinColumns = @JoinColumn(name = "report_id"))
        @Column(name = "reason")
        @Builder.Default
        private List<String> reasons = new ArrayList<>();

        private Double blurScore;
        private Boolean isBlurry;
        private String imageHash;
        private Boolean gpsMatch;
        private Double gpsDistanceMeters;
        private String duplicateOfReport;
        @Builder.Default
        private Boolean trustEffectApplied = false;

        public enum VerificationStatus {
            PASSED, FLAGGED
        }
    }
}