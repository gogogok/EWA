package com.example.EWA_backend.events;

import com.example.EWA_backend.events.eventsRegistration.EventRegistrationRepository;
import com.example.EWA_backend.events.eventsRegistration.EventRegistrationService;
import com.example.EWA_backend.users.UserEntity;
import com.example.EWA_backend.users.UserResponse;
import com.example.EWA_backend.users.UserService;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

@Service
public class EventService {

    private final EventRepository eventRepository;
    private final UserService userService;
    private static final DateTimeFormatter DATE_FORMATTER =
            DateTimeFormatter.ofPattern("dd.MM.yyyy");

    private static final DateTimeFormatter TIME_FORMATTER =
            DateTimeFormatter.ofPattern("HH:mm");

    public EventService(EventRepository eventRepository, UserService userService) {
        this.eventRepository = eventRepository;
        this.userService = userService;
    }

    public EventResponse getEventById(String id) {

        EventEntity event = eventRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Event not found"));

        UserResponse user = userService.getUserById(event.getUserId());

        return new EventResponse(
                event.getId(),
                event.getUserId(),
                event.getName(),
                event.getCategory(),
                event.getDate().toString(),
                event.getTime().toString(),
                event.getPlace(),
                event.getDescription(),
                event.getComment(),
                user
        );
    }

    public List<EventResponse> getEventByUserId(String userId) {

        List<EventEntity> events = eventRepository.findByUserId(userId);
        UserResponse user = userService.getUserById(userId);

        List<EventResponse> eventsDto = new ArrayList<>();
        for (EventEntity event : events) {
            eventsDto.add(new EventResponse(
                    event.getId(),
                    event.getUserId(),
                    event.getName(),
                    event.getCategory(),
                    event.getDate().toString(),
                    event.getTime().toString(),
                    event.getPlace(),
                    event.getDescription(),
                    event.getComment(),
                    user
            ));
        }
        return eventsDto;
    }

    public void addEvent(EventResponse request) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd.MM.yyyy");
        EventEntity event = new EventEntity();
        event.setId(request.getId());
        event.setName(request.getName());
        event.setUserId(request.getUserId());
        event.setCategory(request.getCategory());
        event.setDescription(request.getDescription());
        event.setPlace(request.getPlace());
        event.setDate(LocalDate.parse(request.getDate(), formatter));
        event.setTime(LocalTime.parse(request.getTime()));
        event.setComment(request.getComment());
        eventRepository.save(event);
    }

    public void deleteEvent(String id)
    {
        eventRepository.deleteById(id);
    }

    public EventsPageResponse getEvents(String currentUserId, int page, int size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by("date").descending());

        //Page<EventEntity> result = eventRepository.findAvailableEvents(currentUserId, pageable);
        Page<EventEntity> result = eventRepository.findAll(pageable);

        List<EventResponse> content = result.getContent().stream()
                .map(this::toResponse)
                .toList();

        return new EventsPageResponse(
                content,
                result.getNumber(),
                result.getSize(),
                result.getTotalElements(),
                result.getTotalPages(),
                result.isLast()
        );
    }

    private EventResponse toResponse(EventEntity event) {
        return new EventResponse(
                event.getId(),
                event.getUserId(),
                event.getName(),
                event.getCategory(),
                event.getDate() != null ? event.getDate().format(DATE_FORMATTER) : null,
                event.getTime() != null ? event.getTime().format(TIME_FORMATTER) : null,
                event.getPlace(),
                event.getDescription(),
                event.getComment(),
                toUserResponse(event)
        );
    }

    private UserResponse toUserResponse(EventEntity event) {
        UserResponse user = userService.getUserById(event.getUserId());

        return new UserResponse(
                user.getId(),
                user.getName(),
                user.getIconName(),
                user.getEmail()
        );
    }

    public void updateEvent(String eventId, EventResponse request) {
        EventEntity event = eventRepository.findById(eventId)
                .orElseThrow(() -> new RuntimeException("Event not found"));

        event.setName(request.getName());
        event.setCategory(request.getCategory());
        event.setPlace(request.getPlace());
        event.setDescription(request.getDescription());
        event.setComment(request.getComment());

        if (request.getDate() != null && !request.getDate().isBlank()) {
            event.setDate(LocalDate.parse(request.getDate(), DateTimeFormatter.ofPattern("dd.MM.yyyy")));
        }

        if (request.getTime() != null && !request.getTime().isBlank()) {
            event.setTime(LocalTime.parse(request.getTime(), DateTimeFormatter.ofPattern("HH:mm")));
        }

        eventRepository.save(event);
    }
}