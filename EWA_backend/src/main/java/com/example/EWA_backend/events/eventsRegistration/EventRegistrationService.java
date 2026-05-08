package com.example.EWA_backend.events.eventsRegistration;

import com.example.EWA_backend.events.EventEntity;
import com.example.EWA_backend.events.EventRepository;
import com.example.EWA_backend.events.EventResponse;
import com.example.EWA_backend.events.EventService;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Service
public class EventRegistrationService {

    private final EventRegistrationRepository eventRegistrationRepository;
    private final EventService eventService;

    public EventRegistrationService(EventRegistrationRepository eventRegistrationRepository, EventService eventService) {
        this.eventRegistrationRepository = eventRegistrationRepository;
        this.eventService = eventService;
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

    public List<EventResponse> getEventsByUserId(String userId) {
        List<EventRegistrationEntity> eventsRegistrations = eventRegistrationRepository.findByUserId(userId);
        List<EventResponse> eventsDto = new ArrayList<>();
        for (EventRegistrationEntity eventReg : eventsRegistrations) {
            eventsDto.add(eventService.getEventById(eventReg.getEventId()));
        }
        return eventsDto;
    }

    public void leaveEvent(String eventId, String userId) {

        EventRegistrationEntity registration = eventRegistrationRepository
                .findByEventIdAndUserId(eventId, userId)
                .orElseThrow(() -> new RuntimeException("User is not registered for this event"));

        eventRegistrationRepository.delete(registration);
    }

    public void deleteEvent(String eventId, String userId) {
        EventResponse event = eventService.getEventById(eventId);
        if (!event.getUserId().equals(userId)) {
            throw new RuntimeException("Only creator can delete this event");
        }

        eventRegistrationRepository.deleteById(event.getId());
        eventService.deleteEvent(event.getId());
    }
}
