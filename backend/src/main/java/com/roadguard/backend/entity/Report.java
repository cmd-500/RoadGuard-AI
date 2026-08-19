package com.roadguard.backend.entity;

import jakarta.persistence.*;
import lombok.*;
import org.locationtech.jts.geom.Point;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Entity
@Table(name = "reports")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Report {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(nullable = false, length = 200)
    private String title;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String description;

    @Column(nullable = false, length = 500)
    private String address;

    @Enumerated(EnumType.STRING)
    @Column(name = "hazard_type", nullable = false)
    private HazardType hazardType;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Severity severity;

    @Column(
            name = "location",
            nullable = false,
            columnDefinition = "geometry(Point, 4326)"
    )
    private Point location;

    @Column(name = "image_url", nullable = false, length = 500)
    private String imageUrl;

    @Column(name = "image_public_id", nullable = false, length = 255)
    private String imagePublicId;

    @Enumerated(EnumType.STRING)
    @Column(name = "report_status", nullable = false)
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

    @Column(name = "created_by", nullable = true)
    private UUID createdBy;

    @Column(name = "created_at", nullable = false)
    @Builder.Default
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(name = "updated_at", nullable = false)
    @Builder.Default
    private LocalDateTime updatedAt = LocalDateTime.now();

    @Embedded
    @Builder.Default
    private Verification verification = new Verification();

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }

    public enum HazardType {
        POTHOLE,
        ACCIDENT,
        FOG,
        SPEED_BREAKER,
        WATERLOGGING,
        ROAD_DAMAGE,
        CONSTRUCTION,
        EMERGENCY,
        UNMARKED_BREAKER,
        ILLEGAL_BREAKER,
        WATERLOGGED_HAZARD,
        OTHER
    }

    public enum Severity {
        LOW,
        MEDIUM,
        HIGH,
        CRITICAL
    }

    public enum Status {
        PENDING,
        IN_PROGRESS,
        RESOLVED,
        REJECTED
    }

    public enum CommunityStatus {
        UNVERIFIED,
        CONFIRMED,
        DISPUTED
    }

    @Embeddable
    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class Verification {

        @Enumerated(EnumType.STRING)
        @Column(name = "verification_status")
        @Builder.Default
        private VerificationStatus status = VerificationStatus.PASSED;

        @ElementCollection
        @CollectionTable(
                name = "verification_reasons",
                joinColumns = @JoinColumn(name = "report_id")
        )
        @Column(name = "reason")
        @Builder.Default
        private List<String> reasons = new ArrayList<>();

        @Column(name = "verification_blur_score")
        private Double blurScore;

        @Column(name = "verification_is_blurry")
        private Boolean isBlurry;

        @Column(name = "verification_image_hash")
        private String imageHash;

        @Column(name = "verification_gps_match")
        private Boolean gpsMatch;

        @Column(name = "verification_gps_distance_meters")
        private Double gpsDistanceMeters;

        @Column(name = "verification_duplicate_of_report")
        private UUID duplicateOfReport;

        @Column(name = "verification_trust_effect_applied")
        @Builder.Default
        private Boolean trustEffectApplied = false;

        public enum VerificationStatus {
            PASSED,
            FLAGGED
        }
    }
}