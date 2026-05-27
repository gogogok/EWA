package com.example.EWA_backend.events.eventsRegistration;

import com.example.EWA_backend.events.EventResponse;
import com.example.EWA_backend.events.EventService;
import com.example.EWA_backend.users.UserResponse;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class EventRegistrationServiceTest {

    @Mock
    private EventRegistrationRepository repository;

    @Mock
    private EventService eventService;

    @InjectMocks
    private EventRegistrationService service;

    @Test
    void registerUserToEventSavesRegistrationWhenItDoesNotExist() {
        when(repository.existsByEventIdAndUserId("e1", "u1")).thenReturn(false);

        service.registerUserToEvent("e1", "u1");

        ArgumentCaptor<EventRegistrationEntity> captor = ArgumentCaptor.forClass(EventRegistrationEntity.class);
        verify(repository).save(captor.capture());
        assertNotNull(captor.getValue().getId());
        assertEquals("e1", captor.getValue().getEventId());
        assertEquals("u1", captor.getValue().getUserId());
    }

    @Test
    void registerUserToEventThrowsWhenRegistrationAlreadyExists() {
        when(repository.existsByEventIdAndUserId("e1", "u1")).thenReturn(true);

        RuntimeException exception = assertThrows(RuntimeException.class, () -> service.registerUserToEvent("e1", "u1"));

        assertEquals("User already registered for this event", exception.getMessage());
        verify(repository, never()).save(any());
    }

    @Test
    void getResponsesCountDelegatesToRepository() {
        when(repository.countByEventId("e1")).thenReturn(3L);

        assertEquals(3L, service.getResponsesCount("e1"));
    }

    @Test
    void getEventsByUserIdLoadsRegisteredEvents() {
        when(repository.findByUserId("u1")).thenReturn(List.of(
                new EventRegistrationEntity("r1", "e1", "u1"),
                new EventRegistrationEntity("r2", "e2", "u1")
        ));
        when(eventService.getEventById("e1")).thenReturn(event("e1", "creator"));
        when(eventService.getEventById("e2")).thenReturn(event("e2", "creator"));

        List<EventResponse> result = service.getEventsByUserId("u1");

        assertEquals(2, result.size());
        assertEquals("e1", result.get(0).getId());
        assertEquals("e2", result.get(1).getId());
    }

    @Test
    void leaveEventDeletesExistingRegistration() {
        EventRegistrationEntity registration = new EventRegistrationEntity("r1", "e1", "u1");
        when(repository.findByEventIdAndUserId("e1", "u1")).thenReturn(Optional.of(registration));

        service.leaveEvent("e1", "u1");

        verify(repository).delete(registration);
    }

    @Test
    void leaveEventThrowsWhenRegistrationDoesNotExist() {
        when(repository.findByEventIdAndUserId("e1", "u1")).thenReturn(Optional.empty());

        RuntimeException exception = assertThrows(RuntimeException.class, () -> service.leaveEvent("e1", "u1"));

        assertEquals("User is not registered for this event", exception.getMessage());
    }

    @Test
    void deleteEventAllowsOnlyCreator() {
        when(eventService.getEventById("e1")).thenReturn(event("e1", "creator"));

        service.deleteEvent("e1", "creator");

        verify(repository).deleteById("e1");
        verify(eventService).deleteEvent("e1");
    }

    @Test
    void deleteEventThrowsWhenUserIsNotCreator() {
        when(eventService.getEventById("e1")).thenReturn(event("e1", "creator"));

        RuntimeException exception = assertThrows(RuntimeException.class, () -> service.deleteEvent("e1", "other"));

        assertEquals("Only creator can delete this event", exception.getMessage());
        verify(repository, never()).deleteById(anyString());
        verify(eventService, never()).deleteEvent(anyString());
    }

    private static EventResponse event(String id, String userId) {
        return new EventResponse(id, userId, "Name", "cat", "20.05.2026", "12:30", "Place", "Desc", "Comment", new UserResponse(userId, "Creator", "icon", "mail"));
    }
}
