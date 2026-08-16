package com.roadguard.backend.service;

import com.roadguard.backend.dto.ReportDtos;
import com.roadguard.backend.entity.Report;
import com.roadguard.backend.entity.User;
import com.roadguard.backend.exception.ApiException;
import com.roadguard.backend.repository.ReportRepository;
import com.roadguard.backend.repository.UserRepository;
import com.roadguard.backend.util.ImageVerificationUtil;
import lombok.RequiredArgsConstructor;
import org.locationtech.jts.geom.Coordinate;
import org.locationtech.jts.geom.GeometryFactory;
import org.locationtech.jts.geom.Point;
import org.locationtech.jts.geom.PrecisionModel;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ReportService {

    private final ReportRepository reportRepository;
    private final UserRepository userRepository;
    private final CloudinaryService cloudinaryService;
    private final ImageVerificationUtil imageVerificationUtil;
    private final TrustService trustService;
    private final NotificationService notificationService;

    @Value("${app.geo.duplicate-radius:100}")
    private double duplicateRadius;

    @Value("${app.image.duplicate-lookback-days:30}")
    private int duplicateLookbackDays;

    @Value("${app.image.gps-mismatch-threshold:500}")
    private double gpsMismatchThreshold;

    @Transactional
    public ReportDtos.Response createReport(ReportDtos.CreateRequest request, MultipartFile image, String userId) {
        if (image == null || image.isEmpty()) {
            throw ApiException.badRequest("IMAGE_REQUIRED", "An image is required (capture with camera, not gallery)");
        }

        byte[] imageBytes;
        try {
            imageBytes = image.getBytes();
        } catch (Exception e) {
            throw ApiException.badRequest("INVALID_IMAGE", "Failed to read image");
        }

        CloudinaryService.UploadResult uploadResult = cloudinaryService.uploadImage(image);
        ImageVerificationUtil.VerificationResult verification = imageVerificationUtil.analyze(imageBytes);

        boolean gpsMatch = true;
        Double gpsDistanceMeters = null;
        String duplicateOfReport = null;

        if (verification.exifGps() != null) {
            gpsDistanceMeters = imageVerificationUtil.haversineDistance(
                    request.getLatitude(), request.getLongitude(),
                    verification.exifGps().latitude(), verification.exifGps().longitude()
            );
            gpsMatch = gpsDistanceMeters <= gpsMismatchThreshold;
        }

        LocalDateTime since = LocalDateTime.now().minusDays(duplicateLookbackDays);
        List<Report> nearby = reportRepository.findPotentialDuplicates(since, request.getLatitude(), request.getLongitude(), duplicateRadius);

        for (Report candidate : nearby) {
            if (candidate.getVerification() != null && candidate.getVerification().getImageHash() != null) {
                int distance = imageVerificationUtil.hammingDistance(verification.imageHash(), candidate.getVerification().getImageHash());
                if (distance <= 8) {
                    duplicateOfReport = candidate.getId();
                    break;
                }
            }
        }

        Report.Verification verificationEntity = new Report.Verification();
        verificationEntity.setStatus(verification.isBlurry() || !gpsMatch || duplicateOfReport != null
                ? Report.Verification.VerificationStatus.FLAGGED
                : Report.Verification.VerificationStatus.PASSED);
        verificationEntity.setBlurScore(verification.blurScore());
        verificationEntity.setIsBlurry(verification.isBlurry());
        verificationEntity.setImageHash(verification.imageHash());
        verificationEntity.setGpsMatch(gpsMatch);
        verificationEntity.setGpsDistanceMeters(gpsDistanceMeters);
        verificationEntity.setDuplicateOfReport(duplicateOfReport);
        verificationEntity.setTrustEffectApplied(false);

        List<String> reasons = new java.util.ArrayList<>();
        if (verification.isBlurry()) reasons.add("image appears blurry");
        if (!gpsMatch) reasons.add("photo EXIF GPS does not match submitted location");
        if (duplicateOfReport != null) reasons.add("looks like a duplicate of a nearby existing report");
        verificationEntity.setReasons(reasons);

        Point location = new GeometryFactory(new PrecisionModel(), 4326)
                .createPoint(new Coordinate(request.getLongitude(), request.getLatitude()));

        Report report = Report.builder()
                .title(request.getTitle())
                .description(request.getDescription())
                .address(request.getAddress())
                .hazardType(request.getHazardType())
                .severity(request.getSeverity())
                .location(location)
                .imageUrl(uploadResult.secureUrl())
                .imagePublicId(uploadResult.publicId())
                .verification(verificationEntity)
                .createdBy(userId)
                .build();

        reportRepository.save(report);
        userRepository.incrementReportsSubmitted(userId);

        notificationService.broadcastNewReport(mapToResponse(report));

        return mapToResponse(report);
    }

    public Page<ReportDtos.Response> getReports(Report.Status status, Report.HazardType hazardType, Pageable pageable) {
        Page<Report> reports;
        if (status != null && hazardType != null) {
            reports = reportRepository.findByHazardTypeAndStatusNot(hazardType, status, pageable);
        } else if (status != null) {
            reports = reportRepository.findByStatusNot(status, pageable);
        } else {
            reports = reportRepository.findAll(pageable);
        }
        return reports.map(this::mapToResponse);
    }

    public ReportDtos.Response getReportById(String id) {
        Report report = reportRepository.findById(id)
                .orElseThrow(() -> ApiException.notFound("REPORT_NOT_FOUND", "Report not found"));
        return mapToResponse(report);
    }

    public List<ReportDtos.NearbyReportResponse> getNearbyReports(double latitude, double longitude, double radiusMeters) {
        List<Report> reports = reportRepository.findNearbyReports(Report.Status.REJECTED.name(), latitude, longitude, radiusMeters);
        return reports.stream().map(this::mapToNearbyResponse).collect(Collectors.toList());
    }

    public List<ReportDtos.RouteHazardResponse> checkRoute(List<ReportDtos.CheckRouteRequest.Waypoint> waypoints, double bufferMeters) {
        if (waypoints == null || waypoints.size() < 2) {
            throw ApiException.badRequest("INVALID_ROUTE", "At least 2 waypoints required");
        }

        String polylineWKT = buildLineStringWKT(waypoints);
        List<Report> reports = reportRepository.findReportsOnRoute(Report.Status.REJECTED.name(), polylineWKT, bufferMeters);

        return reports.stream().map(report -> {
            double distanceToRoute = calculateDistanceToRoute(report, waypoints);
            double distanceFromStart = calculateDistanceFromStart(report, waypoints);
            int waypointIndex = findNearestWaypointIndex(report, waypoints);

            return ReportDtos.RouteHazardResponse.builder()
                    .report(mapToResponse(report))
                    .distanceToRouteMeters(distanceToRoute)
                    .distanceFromStartMeters(distanceFromStart)
                    .waypointIndex(waypointIndex)
                    .build();
        }).collect(Collectors.toList());
    }

    @Transactional
    public ReportDtos.Response updateStatus(String id, Report.Status status) {
        Report report = reportRepository.findById(id)
                .orElseThrow(() -> ApiException.notFound("REPORT_NOT_FOUND", "Report not found"));
        report.setStatus(status);
        reportRepository.save(report);
        return mapToResponse(report);
    }

    private ReportDtos.Response mapToResponse(Report report) {
        User creator = userRepository.findById(report.getCreatedBy()).orElse(null);

        return ReportDtos.Response.builder()
                .id(report.getId())
                .title(report.getTitle())
                .description(report.getDescription())
                .address(report.getAddress())
                .hazardType(report.getHazardType())
                .severity(report.getSeverity())
                .latitude(report.getLocation().getY())
                .longitude(report.getLocation().getX())
                .imageUrl(report.getImageUrl())
                .verification(mapVerification(report.getVerification()))
                .status(report.getStatus())
                .communityStatus(report.getCommunityStatus())
                .voteScore(report.getVoteScore())
                .upvoteCount(report.getUpvoteCount())
                .downvoteCount(report.getDownvoteCount())
                .createdBy(creator != null ? ReportDtos.Response.UserInfo.builder()
                        .id(creator.getId())
                        .name(creator.getName())
                        .trustScore(creator.getTrustScore())
                        .isTrusted(creator.isTrusted())
                        .build() : null)
                .createdAt(report.getCreatedAt())
                .updatedAt(report.getUpdatedAt())
                .build();
    }

    private ReportDtos.NearbyReportResponse mapToNearbyResponse(Report report) {
        User creator = userRepository.findById(report.getCreatedBy()).orElse(null);

        return ReportDtos.NearbyReportResponse.builder()
                .id(report.getId())
                .title(report.getTitle())
                .hazardType(report.getHazardType())
                .severity(report.getSeverity())
                .latitude(report.getLocation().getY())
                .longitude(report.getLocation().getX())
                .imageUrl(report.getImageUrl())
                .communityStatus(report.getCommunityStatus())
                .voteScore(report.getVoteScore())
                .createdBy(creator != null ? ReportDtos.NearbyReportResponse.UserInfo.builder()
                        .id(creator.getId())
                        .name(creator.getName())
                        .trustScore(creator.getTrustScore())
                        .isTrusted(creator.isTrusted())
                        .build() : null)
                .build();
    }

    private ReportDtos.Response.VerificationResponse mapVerification(Report.Verification v) {
        if (v == null) return null;
        return ReportDtos.Response.VerificationResponse.builder()
                .status(v.getStatus())
                .reasons(v.getReasons())
                .blurScore(v.getBlurScore())
                .isBlurry(v.getIsBlurry())
                .imageHash(v.getImageHash())
                .gpsMatch(v.getGpsMatch())
                .gpsDistanceMeters(v.getGpsDistanceMeters())
                .duplicateOfReport(v.getDuplicateOfReport())
                .trustEffectApplied(v.getTrustEffectApplied())
                .build();
    }

    private String buildLineStringWKT(List<ReportDtos.CheckRouteRequest.Waypoint> waypoints) {
        StringBuilder sb = new StringBuilder("LINESTRING(");
        for (int i = 0; i < waypoints.size(); i++) {
            ReportDtos.CheckRouteRequest.Waypoint wp = waypoints.get(i);
            sb.append(wp.getLongitude()).append(" ").append(wp.getLatitude());
            if (i < waypoints.size() - 1) sb.append(", ");
        }
        sb.append(")");
        return sb.toString();
    }

    private double calculateDistanceToRoute(Report report, List<ReportDtos.CheckRouteRequest.Waypoint> waypoints) {
        double minDist = Double.MAX_VALUE;
        for (int i = 0; i < waypoints.size() - 1; i++) {
            double dist = distanceToSegment(
                    report.getLocation().getY(), report.getLocation().getX(),
                    waypoints.get(i).getLatitude(), waypoints.get(i).getLongitude(),
                    waypoints.get(i + 1).getLatitude(), waypoints.get(i + 1).getLongitude()
            );
            minDist = Math.min(minDist, dist);
        }
        return minDist;
    }

    private double calculateDistanceFromStart(Report report, List<ReportDtos.CheckRouteRequest.Waypoint> waypoints) {
        double cumulative = 0;
        double minDist = Double.MAX_VALUE;
        int nearestIdx = 0;

        for (int i = 0; i < waypoints.size() - 1; i++) {
            double dist = distanceToSegment(
                    report.getLocation().getY(), report.getLocation().getX(),
                    waypoints.get(i).getLatitude(), waypoints.get(i).getLongitude(),
                    waypoints.get(i + 1).getLatitude(), waypoints.get(i + 1).getLongitude()
            );
            if (dist < minDist) {
                minDist = dist;
                nearestIdx = i;
            }
        }

        for (int i = 0; i < nearestIdx; i++) {
            cumulative += haversineDistance(
                    waypoints.get(i).getLatitude(), waypoints.get(i).getLongitude(),
                    waypoints.get(i + 1).getLatitude(), waypoints.get(i + 1).getLongitude()
            );
        }
        return cumulative;
    }

    private int findNearestWaypointIndex(Report report, List<ReportDtos.CheckRouteRequest.Waypoint> waypoints) {
        double minDist = Double.MAX_VALUE;
        int nearestIdx = 0;
        for (int i = 0; i < waypoints.size(); i++) {
            double dist = haversineDistance(
                    report.getLocation().getY(), report.getLocation().getX(),
                    waypoints.get(i).getLatitude(), waypoints.get(i).getLongitude()
            );
            if (dist < minDist) {
                minDist = dist;
                nearestIdx = i;
            }
        }
        return nearestIdx;
    }

    private double distanceToSegment(double lat, double lon, double lat1, double lon1, double lat2, double lon2) {
        double A = lat - lat1;
        double B = lon - lon1;
        double C = lat2 - lat1;
        double D = lon2 - lon1;

        double dot = A * C + B * D;
        double lenSq = C * C + D * D;
        double param = lenSq != 0 ? dot / lenSq : -1;

        double xx, yy;
        if (param < 0) {
            xx = lat1; yy = lon1;
        } else if (param > 1) {
            xx = lat2; yy = lon2;
        } else {
            xx = lat1 + param * C;
            yy = lon1 + param * D;
        }

        return haversineDistance(lat, lon, xx, yy);
    }

    private double haversineDistance(double lat1, double lon1, double lat2, double lon2) {
        final int R = 6371000;
        double phi1 = Math.toRadians(lat1);
        double phi2 = Math.toRadians(lat2);
        double deltaPhi = Math.toRadians(lat2 - lat1);
        double deltaLambda = Math.toRadians(lon2 - lon1);

        double a = Math.sin(deltaPhi / 2) * Math.sin(deltaPhi / 2) +
                Math.cos(phi1) * Math.cos(phi2) *
                Math.sin(deltaLambda / 2) * Math.sin(deltaLambda / 2);
        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        return R * c;
    }
}