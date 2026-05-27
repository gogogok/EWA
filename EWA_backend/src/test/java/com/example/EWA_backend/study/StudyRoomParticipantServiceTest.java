package com.example.EWA_backend.study;

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
class StudyRoomParticipantServiceTest {

    @Mock
    private StudyRoomParticipantRepository repository;

    @Mock
    private StudyRoomRepository roomRepository;

    @InjectMocks
    private StudyRoomParticipantService service;

    @Test
    void joinRoomDoesNothingWhenParticipantAlreadyExists() {
        StudyRoomParticipant request = participant("room1", "u1");
        when(repository.findByRoomIdAndUserId("room1", "u1")).thenReturn(Optional.of(request));

        service.joinRoom(request);

        verify(repository, never()).save(any());
    }

    @Test
    void joinRoomSavesNewParticipant() {
        StudyRoomParticipant request = participant("room1", "u1");
        when(repository.findByRoomIdAndUserId("room1", "u1")).thenReturn(Optional.empty());

        service.joinRoom(request);

        ArgumentCaptor<StudyRoomParticipant> captor = ArgumentCaptor.forClass(StudyRoomParticipant.class);
        verify(repository).save(captor.capture());
        assertNotNull(captor.getValue().getId());
        assertEquals("room1", captor.getValue().getRoomId());
        assertEquals("u1", captor.getValue().getUserId());
        assertEquals("Dara", captor.getValue().getUsername());
        assertNotNull(captor.getValue().getJoinedAt());
    }

    @Test
    void getParticipantsReturnsParticipantsFromRepository() {
        StudyRoomParticipant participant = participant("room1", "u1");
        when(repository.findByRoomId("room1")).thenReturn(List.of(participant));

        List<StudyRoomParticipant> result = service.getParticipants("room1");

        assertEquals(1, result.size());
        assertEquals("u1", result.get(0).getUserId());
    }

    @Test
    void leaveRoomDeletesRoomWhenLastParticipantLeaves() {
        when(repository.countByRoomId("room1")).thenReturn(0L);

        service.leaveRoom("room1", "u1");

        verify(repository).deleteByRoomIdAndUserId("room1", "u1");
        verify(roomRepository).deleteById("room1");
    }

    @Test
    void leaveRoomDoesNotDeleteRoomWhenParticipantsRemain() {
        when(repository.countByRoomId("room1")).thenReturn(2L);

        service.leaveRoom("room1", "u1");

        verify(repository).deleteByRoomIdAndUserId("room1", "u1");
        verify(roomRepository, never()).deleteById(anyString());
    }

    private static StudyRoomParticipant participant(String roomId, String userId) {
        StudyRoomParticipant participant = new StudyRoomParticipant();
        participant.setRoomId(roomId);
        participant.setUserId(userId);
        participant.setUsername("Dara");
        participant.setIconName("icon");
        return participant;
    }
}
