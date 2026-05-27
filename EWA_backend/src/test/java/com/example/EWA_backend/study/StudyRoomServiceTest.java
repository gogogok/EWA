package com.example.EWA_backend.study;

import com.example.EWA_backend.users.UserBlacklistEntity;
import com.example.EWA_backend.users.UserBlacklistRepository;
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

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class StudyRoomServiceTest {

    @Mock
    private StudyRoomRepository repository;

    @Mock
    private UserService userService;

    @Mock
    private UserBlacklistRepository blacklistRepository;

    @InjectMocks
    private StudyRoomService service;

    @Test
    void createRoomSavesPublicRoomWithoutPassword() {
        StudyRoomResponse request = roomRequest("public", null);

        Map<String, String> result = service.createRoom(request);

        assertEquals("ok", result.get("status"));
        ArgumentCaptor<StudyRoomEntity> captor = ArgumentCaptor.forClass(StudyRoomEntity.class);
        verify(repository).save(captor.capture());
        assertNotNull(captor.getValue().getId());
        assertEquals("u1", captor.getValue().getUserId());
        assertEquals("public", captor.getValue().getType());
        assertNull(captor.getValue().getPasswordHash());
        assertNotNull(captor.getValue().getCreatedAt());
    }

    @Test
    void createRoomSavesPrivateRoomWithPasswordHash() {
        StudyRoomResponse request = roomRequest("private", "1234");

        service.createRoom(request);

        ArgumentCaptor<StudyRoomEntity> captor = ArgumentCaptor.forClass(StudyRoomEntity.class);
        verify(repository).save(captor.capture());
        assertEquals("1234", captor.getValue().getPasswordHash());
    }

    @Test
    void getRoomsFiltersBlockedUsersAndMapsToResponse() {
        StudyRoomEntity allowed = room("r1", "creator1", "public");
        StudyRoomEntity blocked = room("r2", "blockedUser", "public");
        Page<StudyRoomEntity> page = new PageImpl<>(List.of(allowed, blocked));

        when(repository.findAll(any(Pageable.class))).thenReturn(page);
        when(blacklistRepository.findByUserId("current")).thenReturn(List.of(new UserBlacklistEntity("current", "blockedUser")));
        when(userService.getUserById("creator1")).thenReturn(new UserResponse("creator1", "Creator", "icon", "mail"));

        StudyRoomsPageResponse result = service.getRooms("current", 0, 20);

        assertEquals(1, result.getContent().size());
        assertEquals("r1", result.getContent().get(0).getId());
        assertEquals("Creator", result.getContent().get(0).getUser().getName());
        verify(userService, never()).getUserById("blockedUser");
    }

    @Test
    void getRandomPublicRoomReturnsOneOfPublicRooms() {
        StudyRoomEntity room = room("r1", "creator1", "public");
        when(repository.findByType("public")).thenReturn(List.of(room));
        when(userService.getUserById("creator1")).thenReturn(new UserResponse("creator1", "Creator", "icon", "mail"));

        StudyRoomResponse result = service.getRandomPublicRoom();

        assertEquals("r1", result.getId());
        assertEquals("public", result.getType());
    }

    @Test
    void getRandomPublicRoomThrowsWhenThereAreNoPublicRooms() {
        when(repository.findByType("public")).thenReturn(List.of());

        RuntimeException exception = assertThrows(RuntimeException.class, () -> service.getRandomPublicRoom());

        assertEquals("Нет доступных публичных комнат", exception.getMessage());
    }

    private static StudyRoomResponse roomRequest(String type, String password) {
        return new StudyRoomResponse(
                null, "u1", "Room", "Description", "study", type,
                null, "https://youtube.com/video", password
        );
    }

    private static StudyRoomEntity room(String id, String userId, String type) {
        return new StudyRoomEntity(
                id, userId, "Room", "Description", "study", type,
                "https://youtube.com/video", null, LocalDateTime.now()
        );
    }
}
