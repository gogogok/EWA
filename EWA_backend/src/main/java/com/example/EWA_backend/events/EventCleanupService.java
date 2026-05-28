package com.example.EWA_backend.events;

import com.example.EWA_backend.events.eventsRegistration.EventRegistrationRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class EventCleanupService {

    private final EventRegistrationRepository eventRegistrationRepository;
    private final EventRepository eventRepository;

    @Transactional
    public void deleteExpiredEvents() {
        eventRegistrationRepository.deleteRegistrationsForExpiredEvents();
        eventRepository.deleteExpiredEvents();
    }
}