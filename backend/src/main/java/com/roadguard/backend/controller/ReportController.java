package com.roadguard.backend.controller;

import com.roadguard.backend.dto.ReportDtos;
import com.roadguard.backend.service.ReportService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import com.roadguard.backend.entity.Report;
import com.roadguard.backend.entity.User;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@RestController
@RequestMapping("/reports")
@RequiredArgsConstructor
public class ReportController {

    private final ReportService reportService;

    @PostMapping(consumes = "multipart/form-data")
    public ResponseEntity<ReportDtos.Response> createReport(
            @RequestPart("data") @Valid ReportDtos.CreateRequest request,
            @RequestPart("image") MultipartFile image,
            @AuthenticationPrincipal User user
    ) {
        return ResponseEntity.status(201).body(reportService.createReport(request, image, user.getId()));
    }

    @GetMapping
    public ResponseEntity<Page<ReportDtos.Response>> getReports(
            @RequestParam(required = false) Report.Status status,
            @RequestParam(required = false) Report.HazardType hazardType,
            @PageableDefault(size = 20) Pageable pageable
    ) {
        return ResponseEntity.ok(reportService.getReports(status, hazardType, pageable));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ReportDtos.Response> getReportById(@PathVariable String id) {
        return ResponseEntity.ok(reportService.getReportById(id));
    }

    @GetMapping("/nearby")
    public ResponseEntity<List<ReportDtos.NearbyReportResponse>> getNearbyReports(
            @RequestParam double latitude,
            @RequestParam double longitude,
            @RequestParam(defaultValue = "300") double radiusMeters
    ) {
        return ResponseEntity.ok(reportService.getNearbyReports(latitude, longitude, radiusMeters));
    }

    @PostMapping("/check-route")
    public ResponseEntity<List<ReportDtos.RouteHazardResponse>> checkRoute(
            @Valid @RequestBody ReportDtos.CheckRouteRequest request
    ) {
        return ResponseEntity.ok(reportService.checkRoute(request.getWaypoints(), request.getBufferMeters()));
    }

    @PutMapping("/{id}/status")
    public ResponseEntity<ReportDtos.Response> updateStatus(
            @PathVariable String id,
            @Valid @RequestBody ReportDtos.UpdateStatusRequest request
    ) {
        return ResponseEntity.ok(reportService.updateStatus(id, request.getStatus()));
    }
}