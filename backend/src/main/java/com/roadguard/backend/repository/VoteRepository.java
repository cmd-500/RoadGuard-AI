package com.roadguard.backend.repository;

import com.roadguard.backend.entity.Vote;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface VoteRepository extends JpaRepository<Vote, UUID> {

    Optional<Vote> findByReportIdAndUserId(UUID reportId, UUID userId);

    List<Vote> findByReportId(UUID reportId);

    @Query("SELECT COUNT(v) FROM Vote v WHERE v.reportId = :reportId AND v.voteType = 'UPVOTE'")
    long countUpvotesByReportId(@Param("reportId") UUID reportId);

    @Query("SELECT COUNT(v) FROM Vote v WHERE v.reportId = :reportId AND v.voteType = 'DOWNVOTE'")
    long countDownvotesByReportId(@Param("reportId") UUID reportId);

    @Query("SELECT SUM(CASE WHEN v.voteType = 'UPVOTE' THEN v.weight ELSE -v.weight END) FROM Vote v WHERE v.reportId = :reportId")
    Integer getVoteScoreByReportId(@Param("reportId") UUID reportId);

    boolean existsByReportIdAndUserId(UUID reportId, UUID userId);
}