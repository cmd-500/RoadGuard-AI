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

    @Query("""
        SELECT r FROM Report r
        WHERE r.status != :rejectedStatus
        AND ST_DWithin(r.location, ST_SetSRID(ST_MakePoint(:lng, :lat), 4326)::geography, :radiusMeters)
        ORDER BY ST_Distance(r.location, ST_SetSRID(ST_MakePoint(:lng, :lat), 4326)::geography)
        """)
    List<Report> findNearbyReports(
            @Param("rejectedStatus") Report.Status rejectedStatus,
            @Param("lat") double lat,
            @Param("lng") double lng,
            @Param("radiusMeters") double radiusMeters
    );

    @Query("""
        SELECT r FROM Report r
        WHERE r.status != :rejectedStatus
        AND ST_Within(r.location, ST_Buffer(ST_GeomFromText(:polylineWKT, 4326)::geography, :bufferMeters)::geometry)
        """)
    List<Report> findReportsOnRoute(
            @Param("rejectedStatus") Report.Status rejectedStatus,
            @Param("polylineWKT") String polylineWKT,
            @Param("bufferMeters") double bufferMeters
    );

    @Query("""
        SELECT r FROM Report r
        WHERE r.createdAt >= :since
        AND r.verification.imageHash IS NOT NULL
        AND ST_DWithin(r.location, ST_SetSRID(ST_MakePoint(:lng, :lat), 4326)::geography, :radiusMeters)
        """)
    List<Report> findPotentialDuplicates(
            @Param("since") LocalDateTime since,
            @Param("lat") double lat,
            @Param("lng") double lng,
            @Param("radiusMeters") double radiusMeters
    );

    List<Report> findByCreatedBy(String userId);

    Optional<Report> findByIdWithCreator(String id);
}