package com.example.EWA_backend.events;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface EventRegistrationRepository extends JpaRepository<EventRegistrationEntity, String> {

    List<EventRegistrationEntity> findByUserId(String userId);

    List<EventRegistrationEntity> findByEventId(String eventId);

    long countByEventId(String eventId);

    boolean existsByEventIdAndUserId(String eventId, String userId);

    Optional<EventRegistrationEntity> findByEventIdAndUserId(String eventId, String userId);
}