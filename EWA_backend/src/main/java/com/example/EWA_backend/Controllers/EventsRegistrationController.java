package com.example.EWA_backend.Controllers;

import com.example.EWA_backend.events.EventResponse;
import com.example.EWA_backend.events.eventsRegistration.EventRegistrationService;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/eventsregistration")
public class EventsRegistrationController {

    private final EventRegistrationService eventRegistrationService;

    public EventsRegistrationController(EventRegistrationService eventRegistrationService) {
        this.eventRegistrationService = eventRegistrationService;
    }

    @GetMapping("/{userId}")
    public List<EventResponse> getEventsByUserId(@PathVariable String userId) {
        return eventRegistrationService.getEventsByUserId(userId);
    }

    @PostMapping("/addToEvent/{eventId}/{userId}")
    public Map<String, String> addUser(@PathVariable String eventId, @PathVariable String userId) {
        eventRegistrationService.registerUserToEvent(eventId, userId);
        return Map.of("status", "ok");
    }

    @DeleteMapping("/{userId}/{eventId}/leave")
    public Map<String, String> leaveEvent(
            @PathVariable String eventId,
            @PathVariable String userId
    ) {
        eventRegistrationService.leaveEvent(eventId, userId);
        return Map.of("status", "ok");
    }

    @DeleteMapping("delete/{eventId}/{userId}")
    public Map<String, String> deleteEvent(
            @PathVariable String eventId,
            @PathVariable String userId
    ) {
        eventRegistrationService.deleteEvent(eventId, userId);
        return Map.of("status", "ok");
    }
}