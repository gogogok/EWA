package com.example.EWA_backend.events;

import com.example.EWA_backend.users.UserResponse;
import com.example.EWA_backend.users.UserService;
import org.springframework.stereotype.Service;

@Service
public class EventService {

    private final EventRepository eventRepository;
    private final UserService userService;

    public EventService(EventRepository eventRepository, UserService userService) {
        this.eventRepository = eventRepository;
        this.userService = userService;
    }

    public EventResponse getEventById(Long id) {

        EventEntity event = eventRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Event not found"));

        UserResponse user = userService.getUserById(event.getId());

        return new EventResponse(
                event.getId(),
                event.getUserId(),
                event.getName(),
                event.getCategory(),
                event.getDateTime().toString(),
                event.getPlace(),
                event.getDescription(),
                event.getComment(),
                user
        );
    }

}