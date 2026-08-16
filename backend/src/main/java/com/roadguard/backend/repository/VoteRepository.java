package com.roadguard.backend.repository;

import com.roadguard.backend.entity.Vote;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface VoteRepository extends JpaRepository<Vote, String> {

    Optional<Vote> findByReportIdAndUserId(String reportId, String userId);

    List<Vote> findByReportId(String reportId);

    @Query("SELECT COUNT(v) FROM Vote v WHERE v.reportId = :reportId AND v.voteType = 'UPVOTE'")
    long countUpvotesByReportId(@Param("reportId") String reportId);

    @Query("SELECT COUNT(v) FROM Vote v WHERE v.reportId = :reportId AND v.voteType = 'DOWNVOTE'")
    long countDownvotesByReportId(@Param("reportId") String reportId);

    @Query("SELECT SUM(CASE WHEN v.voteType = 'UPVOTE' THEN v.weight ELSE -v.weight END) FROM Vote v WHERE v.reportId = :reportId")
    Integer getVoteScoreByReportId(@Param("reportId") String reportId);

    boolean existsByReportIdAndUserId(String reportId, String userId);
}