package com.roadguard.backend.controller;

import com.roadguard.backend.dto.VoteDtos;
import com.roadguard.backend.service.VoteService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import com.roadguard.backend.entity.User;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/reports/{reportId}/votes")
@RequiredArgsConstructor
public class VoteController {

    private final VoteService voteService;

    @PostMapping
    public ResponseEntity<VoteDtos.VoteResponse> castVote(
            @PathVariable String reportId,
            @Valid @RequestBody VoteDtos.VoteRequest request,
            @AuthenticationPrincipal User user
    ) {
        return ResponseEntity.ok(voteService.castVote(reportId, request, user.getId().toString()));
    }

    @GetMapping("/me")
    public ResponseEntity<VoteDtos.VoteStatusResponse> getMyVote(
            @PathVariable String reportId,
            @AuthenticationPrincipal User user
    ) {
        return ResponseEntity.ok(voteService.getVoteStatus(reportId, user.getId().toString()));
    }
}