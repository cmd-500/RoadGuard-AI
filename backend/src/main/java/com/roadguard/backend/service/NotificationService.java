package com.roadguard.backend.service;

import com.roadguard.backend.dto.ReportDtos;
import com.roadguard.backend.entity.Report;
import lombok.RequiredArgsConstructor;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class NotificationService {

    private final SimpMessagingTemplate messagingTemplate;

    public void notifyNearbyUsers(Report report, double latitude, double longitude, double radiusMeters) {
        ReportDtos.NearbyReportResponse response = ReportDtos.NearbyReportResponse.builder()
                .id(report.getId())
                .title(report.getTitle())
                .hazardType(report.getHazardType())
                .severity(report.getSeverity())
                .latitude(report.getLocation().getY())
                .longitude(report.getLocation().getX())
                .imageUrl(report.getImageUrl())
                .communityStatus(report.getCommunityStatus())
                .voteScore(report.getVoteScore())
                .build();

        messagingTemplate.convertAndSend(
                "/topic/hazards/nearby/" + String.format("%.4f,%.4f", latitude, longitude),
                response
        );
    }

    public void broadcastNewReport(ReportDtos.Response report) {
        messagingTemplate.convertAndSend("/topic/reports/new", report);
    }

    public void broadcastReportUpdate(String reportId, ReportDtos.Response report) {
        messagingTemplate.convertAndSend("/topic/reports/" + reportId, report);
    }
}