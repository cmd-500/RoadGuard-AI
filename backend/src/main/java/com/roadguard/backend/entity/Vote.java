package com.roadguard.backend.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import java.time.LocalDateTime;

@Entity
@Table(name = "votes", uniqueConstraints = {
    @UniqueConstraint(name = "uk_vote_user_report", columnNames = {"user_id", "report_id"})
}, indexes = {
    @Index(name = "idx_vote_report", columnList = "report_id"),
    @Index(name = "idx_vote_user", columnList = "user_id")
})
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Vote {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    @JdbcTypeCode(SqlTypes.UUID)
    @Convert(converter = UuidStringConverter.class)
    private String id;

    @Column(name = "report_id", nullable = false)
    @JdbcTypeCode(SqlTypes.UUID)
    @Convert(converter = UuidStringConverter.class)
    private String reportId;

    @Column(name = "user_id", nullable = false)
    @JdbcTypeCode(SqlTypes.UUID)
    @Convert(converter = UuidStringConverter.class)
    private String userId;

    @Enumerated(EnumType.STRING)
    @Column(name = "vote_type", nullable = false)
    private VoteType voteType;

    @Column(nullable = false)
    private Integer weight;

    @CreationTimestamp
    @Column(updatable = false)
    private LocalDateTime createdAt;

    public enum VoteType {
        UPVOTE, DOWNVOTE
    }

    public int getSignedWeight() {
        return voteType == VoteType.UPVOTE ? weight : -weight;
    }
}