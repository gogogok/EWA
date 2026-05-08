package com.example.EWA_backend.events;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface EventRepository extends JpaRepository<EventEntity, String> {
    List<EventEntity> findByUserId(String userId);

    @Query("""
SELECT e FROM EventEntity e
WHERE e.userId <> :userId
AND NOT EXISTS (
    SELECT 1 FROM EventRegistrationEntity r
    WHERE r.eventId = e.id
    AND r.userId = :userId
)
""")
    Page<EventEntity> findAvailableEvents(@Param("userId") String userId, Pageable pageable);

    void delete(EventEntity event);
}