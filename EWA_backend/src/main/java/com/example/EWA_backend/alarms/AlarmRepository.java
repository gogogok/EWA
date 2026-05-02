package com.example.EWA_backend.alarms;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;

public interface AlarmRepository extends JpaRepository<AlarmEntity, String> {
    List<AlarmEntity> findByUserId(String userId);


    @Query("""
SELECT a FROM AlarmEntity a
WHERE a.userId <> :userId
AND NOT EXISTS (
    SELECT 1 FROM EventRegistrationEntity r
    WHERE r.eventId = a.id
    AND r.userId = :userId
)
""")
    Page<AlarmEntity> findAvailableAlarms(@Param("userId") String userId, Pageable pageable);

    void delete(AlarmEntity event);

    Page<AlarmEntity> findByDateAndTimeBetween(
            LocalDate date,
            LocalTime from,
            LocalTime to,
            Pageable pageable
    );

    Page<AlarmEntity> findByDateAfter(
            LocalDate date,
            Pageable pageable
    );
}