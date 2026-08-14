package com.roadguard.backend.service;

import com.roadguard.backend.entity.Report;
import com.roadguard.backend.entity.User;
import com.roadguard.backend.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class TrustService {

    private final UserRepository userRepository;

    @Value("${app.trust.threshold:75}")
    private int trustThreshold;

    @Value("${app.trust.trusted-vote-weight:2}")
    private int trustedVoteWeight;

    @Value("${app.trust.default-vote-weight:1}")
    private int defaultVoteWeight;

    @Value("${app.vote.confirm-threshold:5}")
    private int confirmThreshold;

    @Value("${app.vote.dispute-threshold:-5}")
    private int disputeThreshold;

    @Value("${app.trust.bonus:5}")
    private int trustBonus;

    @Value("${app.trust.penalty:8}")
    private int trustPenalty;

    public int getVoteWeight(User voter) {
        return voter.getTrustScore() >= trustThreshold ? trustedVoteWeight : defaultVoteWeight;
    }

    @Transactional
    public void applyCommunityOutcome(Report report) {
        Report.CommunityStatus nextStatus = Report.CommunityStatus.UNVERIFIED;

        if (report.getVoteScore() >= confirmThreshold) {
            nextStatus = Report.CommunityStatus.CONFIRMED;
        } else if (report.getVoteScore() <= disputeThreshold) {
            nextStatus = Report.CommunityStatus.DISPUTED;
        }

        report.setCommunityStatus(nextStatus);

        if (nextStatus != Report.CommunityStatus.UNVERIFIED && !report.getVerification().getTrustEffectApplied()) {
            int delta = nextStatus == Report.CommunityStatus.CONFIRMED ? trustBonus : -trustPenalty;

            User reporter = userRepository.findById(report.getCreatedBy()).orElse(null);
            if (reporter != null) {
                int newScore = Math.max(0, Math.min(100, reporter.getTrustScore() + delta));
                reporter.setTrustScore(newScore);
                if (nextStatus == Report.CommunityStatus.CONFIRMED) {
                    reporter.setReportsConfirmed(reporter.getReportsConfirmed() + 1);
                }
                userRepository.save(reporter);
            }

            report.getVerification().setTrustEffectApplied(true);
        }
    }
}