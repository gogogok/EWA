package com.example.EWA_backend.Controllers;

import com.example.EWA_backend.events.EventResponse;
import com.example.EWA_backend.events.EventService;
import com.example.EWA_backend.events.EventsPageResponse;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/events")
public class EventController {

    private final EventService eventService;

    public EventController(EventService eventService) {
        this.eventService = eventService;
    }

    @GetMapping("/{id}")
    public EventResponse getEventById(@PathVariable String id) {
        return eventService.getEventById(id);
    }

    @PostMapping("/add")
    public Map<String, String> addEvent(@RequestBody EventResponse request) {
        eventService.addEvent(request);
        return Map.of("status", "ok");
    }

    @GetMapping()
    public EventsPageResponse getEvents(
            @RequestParam String userId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size
    ) {
        return eventService.getEvents(userId, page, size);
    }

    @GetMapping("/my/{userId}")
    public List<EventResponse> getMyEvents (@PathVariable String userId){
        return eventService.getEventByUserId(userId);
    }

    @PutMapping("edit/{eventId}")
    public Map<String, String> updateEvent(
            @PathVariable String eventId,
            @RequestBody EventResponse request
    ) {
        eventService.updateEvent(eventId, request);
        return Map.of("status", "ok");
    }
}