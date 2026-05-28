package com.example.EWA_backend.users;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class UserBlacklistServiceTest {

    @Mock
    private UserBlacklistRepository repository;

    @Mock
    private UserService userService;

    @InjectMocks
    private UserBlacklistService service;

    @Test
    void getUsersInBlackListReturnsEmptyListWhenRepositoryReturnsEmptyList() {
        when(repository.findByUserId("u1")).thenReturn(List.of());

        List<UserResponse> result = service.getUsersInBlackList("u1");

        assertTrue(result.isEmpty());
        verifyNoInteractions(userService);
    }

    @Test
    void getUsersInBlackListLoadsBlockedUsers() {
        UserBlacklistEntity first = new UserBlacklistEntity("u1", "blocked1");
        UserBlacklistEntity second = new UserBlacklistEntity("u1", "blocked2");
        when(repository.findByUserId("u1")).thenReturn(List.of(first, second));
        when(userService.getUserById("blocked1")).thenReturn(new UserResponse("blocked1", "One", "i1", "one@mail.com"));
        when(userService.getUserById("blocked2")).thenReturn(new UserResponse("blocked2", "Two", "i2", "two@mail.com"));

        List<UserResponse> result = service.getUsersInBlackList("u1");

        assertEquals(2, result.size());
        assertEquals("blocked1", result.get(0).getId());
        assertEquals("blocked2", result.get(1).getId());
    }

    @Test
    void addToBlacklistThrowsWhenRequiredIdsAreMissing() {
        assertThrows(IllegalArgumentException.class, () -> service.addToBlacklist(null, "u2"));
        assertThrows(IllegalArgumentException.class, () -> service.addToBlacklist("u1", null));
        verify(repository, never()).save(any());
    }

    @Test
    void addToBlacklistThrowsWhenUserBlocksHimself() {
        IllegalArgumentException exception = assertThrows(
                IllegalArgumentException.class,
                () -> service.addToBlacklist("u1", "u1")
        );

        assertEquals("User cannot block himself", exception.getMessage());
        verify(repository, never()).save(any());
    }

    @Test
    void addToBlacklistDoesNothingWhenRecordAlreadyExists() {
        when(repository.existsByUserIdAndBlockedUserId("u1", "u2")).thenReturn(true);

        service.addToBlacklist("u1", "u2");

        verify(repository, never()).save(any());
    }

    @Test
    void addToBlacklistSavesNewBlacklistEntity() {
        when(repository.existsByUserIdAndBlockedUserId("u1", "u2")).thenReturn(false);

        service.addToBlacklist("u1", "u2");

        ArgumentCaptor<UserBlacklistEntity> captor = ArgumentCaptor.forClass(UserBlacklistEntity.class);
        verify(repository).save(captor.capture());
        assertEquals("u1", captor.getValue().getUserId());
        assertEquals("u2", captor.getValue().getBlockedUserId());
        assertNotNull(captor.getValue().getId());
        assertNotNull(captor.getValue().getCreatedAt());
    }

    @Test
    void removeFromBlacklistDeletesRecord() {
        service.removeFromBlacklist("u1", "u2");

        verify(repository).deleteByUserIdAndBlockedUserId("u1", "u2");
    }
}
