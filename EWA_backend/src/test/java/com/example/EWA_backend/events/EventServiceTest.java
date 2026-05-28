package com.example.EWA_backend.events;

import com.example.EWA_backend.users.UserResponse;
import com.example.EWA_backend.users.UserService;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class EventServiceTest {

    @Mock
    private EventRepository eventRepository;

    @Mock
    private UserService userService;

    @InjectMocks
    private EventService eventService;

    @Test
    void getEventByIdReturnsEventWithCreator() {
        EventEntity event = event("e1", "u1");
        when(eventRepository.findById("e1")).thenReturn(Optional.of(event));
        when(userService.getUserById("u1")).thenReturn(user("u1"));

        EventResponse result = eventService.getEventById("e1");

        assertEquals("e1", result.getId());
        assertEquals("u1", result.getUserId());
        assertEquals("Football", result.getName());
        assertEquals("2026-05-20", result.getDate());
        assertEquals("12:30", result.getTime());
        assertEquals("Dara", result.getUser().getName());
    }

    @Test
    void getEventByIdThrowsWhenEventDoesNotExist() {
        when(eventRepository.findById("missing")).thenReturn(Optional.empty());

        RuntimeException exception = assertThrows(RuntimeException.class, () -> eventService.getEventById("missing"));

        assertEquals("Event not found", exception.getMessage());
    }

    @Test
    void getEventByUserIdReturnsAllUserEvents() {
        when(eventRepository.findByUserId("u1")).thenReturn(List.of(event("e1", "u1"), event("e2", "u1")));
        when(userService.getUserById("u1")).thenReturn(user("u1"));

        List<EventResponse> result = eventService.getEventByUserId("u1");

        assertEquals(2, result.size());
        assertEquals("e1", result.get(0).getId());
        assertEquals("Dara", result.get(0).getUser().getName());
    }

    @Test
    void addEventParsesDateAndTimeAndSavesEntity() {
        EventResponse request = new EventResponse(
                "e1", "u1", "Meeting", "study", "20.05.2026", "09:15",
                "Warsaw", "desc", "comment", null
        );

        eventService.addEvent(request);

        ArgumentCaptor<EventEntity> captor = ArgumentCaptor.forClass(EventEntity.class);
        verify(eventRepository).save(captor.capture());
        EventEntity saved = captor.getValue();
        assertEquals("e1", saved.getId());
        assertEquals("u1", saved.getUserId());
        assertEquals(LocalDate.of(2026, 5, 20), saved.getDate());
        assertEquals(LocalTime.of(9, 15), saved.getTime());
    }

    @Test
    void addEventUsesNoonWhenTimeIsEmpty() {
        EventResponse request = new EventResponse(
                "e1", "u1", "Meeting", "study", "20.05.2026", "",
                "Warsaw", "desc", "comment", null
        );

        eventService.addEvent(request);

        ArgumentCaptor<EventEntity> captor = ArgumentCaptor.forClass(EventEntity.class);
        verify(eventRepository).save(captor.capture());
        assertEquals(LocalTime.NOON, captor.getValue().getTime());
    }

    @Test
    void deleteEventDeletesById() {
        eventService.deleteEvent("e1");

        verify(eventRepository).deleteById("e1");
    }

    @Test
    void getEventsReturnsPagedResponse() {
        Page<EventEntity> page = new PageImpl<>(List.of(event("e1", "u1")));
        when(eventRepository.findAll(any(Pageable.class))).thenReturn(page);
        when(userService.getUserById("u1")).thenReturn(user("u1"));

        EventsPageResponse result = eventService.getEvents("current", 0, 20);

        assertEquals(1, result.getContent().size());
        assertEquals("20.05.2026", result.getContent().get(0).getDate());
        assertEquals("12:30", result.getContent().get(0).getTime());
    }

    @Test
    void updateEventChangesOnlyProvidedDateAndTime() {
        EventEntity existing = event("e1", "u1");
        when(eventRepository.findById("e1")).thenReturn(Optional.of(existing));

        EventResponse request = new EventResponse();
        request.setName("Updated");
        request.setCategory("new category");
        request.setPlace("New place");
        request.setDescription("new desc");
        request.setComment("new comment");
        request.setDate("21.05.2026");
        request.setTime("10:45");

        eventService.updateEvent("e1", request);

        assertEquals("Updated", existing.getName());
        assertEquals("new category", existing.getCategory());
        assertEquals("New place", existing.getPlace());
        assertEquals(LocalDate.of(2026, 5, 21), existing.getDate());
        assertEquals(LocalTime.of(10, 45), existing.getTime());
        verify(eventRepository).save(existing);
    }

    @Test
    void updateEventThrowsWhenEventDoesNotExist() {
        when(eventRepository.findById("missing")).thenReturn(Optional.empty());

        RuntimeException exception = assertThrows(RuntimeException.class, () -> eventService.updateEvent("missing", new EventResponse()));

        assertEquals("Event not found", exception.getMessage());
        verify(eventRepository, never()).save(any());
    }

    private static EventEntity event(String id, String userId) {
        EventEntity event = new EventEntity();
        event.setId(id);
        event.setUserId(userId);
        event.setName("Football");
        event.setCategory("sport");
        event.setDate(LocalDate.of(2026, 5, 20));
        event.setTime(LocalTime.of(12, 30));
        event.setPlace("Warsaw");
        event.setDescription("description");
        event.setComment("comment");
        return event;
    }

    private static UserResponse user(String id) {
        return new UserResponse(id, "Dara", "icon", "dara@mail.com");
    }
}
