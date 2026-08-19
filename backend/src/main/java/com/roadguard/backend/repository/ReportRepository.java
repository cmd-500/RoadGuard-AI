package com.roadguard.backend.repository;

import com.roadguard.backend.entity.Report;
import org.locationtech.jts.geom.Point;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface ReportRepository extends JpaRepository<Report, String> {

    Page<Report> findByStatusNot(Report.Status status, Pageable pageable);

    Page<Report> findByHazardTypeAndStatusNot(Report.HazardType hazardType, Report.Status status, Pageable pageable);

    @Query(value = """
        SELECT * FROM reports r
        WHERE r.report_status != :rejectedStatus
        AND ST_DWithin(r.location, CAST(ST_SetSRID(ST_MakePoint(:lng, :lat), 4326) AS geography), :radiusMeters)
        ORDER BY ST_Distance(r.location, CAST(ST_SetSRID(ST_MakePoint(:lng, :lat), 4326) AS geography))
        """, nativeQuery = true)
    List<Report> findNearbyReports(
            @Param("rejectedStatus") String rejectedStatus,
            @Param("lat") double lat,
            @Param("lng") double lng,
            @Param("radiusMeters") double radiusMeters
    );

    @Query(value = """
        SELECT * FROM reports r
        WHERE r.report_status != :rejectedStatus
        AND ST_Within(r.location, CAST(ST_Buffer(CAST(ST_GeomFromText(:polylineWKT, 4326) AS geography), :bufferMeters) AS geometry))
        """, nativeQuery = true)
    List<Report> findReportsOnRoute(
            @Param("rejectedStatus") String rejectedStatus,
            @Param("polylineWKT") String polylineWKT,
            @Param("bufferMeters") double bufferMeters
    );

    @Query(value = """
        SELECT * FROM reports r
        WHERE r.created_at >= :since
        AND r.verification_image_hash IS NOT NULL
        AND ST_DWithin(r.location, CAST(ST_SetSRID(ST_MakePoint(:lng, :lat), 4326) AS geography), :radiusMeters)
        """, nativeQuery = true)
    List<Report> findPotentialDuplicates(
            @Param("since") LocalDateTime since,
            @Param("lat") double lat,
            @Param("lng") double lng,
            @Param("radiusMeters") double radiusMeters
    );

    List<Report> findByCreatedBy(String userId);
}