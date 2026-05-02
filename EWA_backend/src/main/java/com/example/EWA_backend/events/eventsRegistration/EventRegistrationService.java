package com.example.EWA_backend.events;

import org.springframework.stereotype.Service;

import java.util.UUID;

@Service
public class EventRegistrationService {

    private final EventRegistrationRepository eventRegistrationRepository;

    public EventRegistrationService(EventRegistrationRepository eventRegistrationRepository) {
        this.eventRegistrationRepository = eventRegistrationRepository;
    }

    public void registerUserToEvent(String eventId, String userId) {
        boolean alreadyExists = eventRegistrationRepository.existsByEventIdAndUserId(eventId, userId);

        if (alreadyExists) {
            throw new RuntimeException("User already registered for this event");
        }

        EventRegistrationEntity registration = new EventRegistrationEntity();
        registration.setId(UUID.randomUUID().toString());
        registration.setEventId(eventId);
        registration.setUserId(userId);

        eventRegistrationRepository.save(registration);
    }

    public long getResponsesCount(String eventId) {
        return eventRegistrationRepository.countByEventId(eventId);
    }
}
