package com.example.EWA_backend.users;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class UserServiceTest {

    @Mock
    private UserRepository userRepository;

    @InjectMocks
    private UserService userService;

    @Test
    void getUserByIdReturnsDtoWhenUserExists() {
        UserEntity entity = new UserEntity("u1", "Dara", "cat", "dara@mail.com");
        when(userRepository.findById("u1")).thenReturn(Optional.of(entity));

        UserResponse result = userService.getUserById("u1");

        assertEquals("u1", result.getId());
        assertEquals("Dara", result.getName());
        assertEquals("cat", result.getIconName());
        assertEquals("dara@mail.com", result.getEmail());
    }

    @Test
    void getUserByIdThrowsWhenUserDoesNotExist() {
        when(userRepository.findById("missing")).thenReturn(Optional.empty());

        RuntimeException exception = assertThrows(
                RuntimeException.class,
                () -> userService.getUserById("missing")
        );

        assertEquals("User not found", exception.getMessage());
    }

    @Test
    void addUserMapsDtoToEntityAndSavesIt() {
        UserResponse request = new UserResponse("u1", "Dara", "dog", "dara@mail.com");

        userService.addUser(request);

        ArgumentCaptor<UserEntity> captor = ArgumentCaptor.forClass(UserEntity.class);
        verify(userRepository).save(captor.capture());

        UserEntity saved = captor.getValue();
        assertEquals("u1", saved.getId());
        assertEquals("Dara", saved.getName());
        assertEquals("dog", saved.getIconName());
        assertEquals("dara@mail.com", saved.getEmail());
    }

    @Test
    void updateUserUpdatesExistingEntityAndReturnsUpdatedDto() {
        UserEntity existing = new UserEntity("u1", "Old", "old_icon", "old@mail.com");
        UserEntity saved = new UserEntity("u1", "New", "new_icon", "new@mail.com");

        when(userRepository.findById("u1")).thenReturn(Optional.of(existing));
        when(userRepository.save(existing)).thenReturn(saved);

        UserResponse result = userService.updateUser(
                new UserResponse("u1", "New", "new_icon", "new@mail.com")
        );

        assertEquals("New", result.getName());
        assertEquals("new_icon", result.getIconName());
        assertEquals("new@mail.com", result.getEmail());
        verify(userRepository).save(existing);
    }

    @Test
    void updateUserThrowsWhenUserDoesNotExist() {
        when(userRepository.findById("missing")).thenReturn(Optional.empty());

        RuntimeException exception = assertThrows(
                RuntimeException.class,
                () -> userService.updateUser(new UserResponse("missing", "Name", "icon", "mail"))
        );

        assertEquals("User not found", exception.getMessage());
        verify(userRepository, never()).save(any());
    }
}
