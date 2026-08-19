package com.roadguard.backend.repository;

import com.roadguard.backend.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, java.util.UUID> {

    Optional<User> findByEmail(String email);

    boolean existsByEmail(String email);

    @Query("SELECT u FROM User u WHERE u.trustScore >= 75")
    long countTrustedUsers();

    @Query("SELECT u FROM User u WHERE u.id = :id")
    Optional<User> findByIdWithRole(@Param("id") java.util.UUID id);

    @Modifying
    @Transactional
    @Query("UPDATE User u SET u.reportsSubmitted = u.reportsSubmitted + 1 WHERE u.id = :userId")
    void incrementReportsSubmitted(@Param("userId") java.util.UUID userId);
}