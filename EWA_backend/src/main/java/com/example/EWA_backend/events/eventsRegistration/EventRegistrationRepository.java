package com.example.EWA_backend.events.eventsRegistration;

import org.springframework.data.jpa.repository.JpaRepository;
import jakarta.transaction.Transactional;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import java.util.List;
import java.util.Optional;

public interface EventRegistrationRepository extends JpaRepository<EventRegistrationEntity, String> {

    List<EventRegistrationEntity> findByUserId(String userId);

    List<EventRegistrationEntity> findByEventId(String eventId);

    long countByEventId(String eventId);

    boolean existsByEventIdAndUserId(String eventId, String userId);

    void deleteByEventIdAndUserId(String eventId, String userId);

    Optional<EventRegistrationEntity> findByEventIdAndUserId(String eventId, String userId);

    @Modifying
    @Transactional
    @Query(value = """
    DELETE FROM event_registrations
    WHERE event_id IN (
        SELECT id FROM events
        WHERE (date + time) < NOW()
    )
    """, nativeQuery = true)
    void deleteRegistrationsForExpiredEvents();
}