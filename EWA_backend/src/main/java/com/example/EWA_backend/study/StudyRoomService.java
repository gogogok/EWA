package com.example.EWA_backend.study;

import com.example.EWA_backend.alarms.AlarmType;
import com.example.EWA_backend.users.UserBlacklistEntity;
import com.example.EWA_backend.users.UserBlacklistRepository;
import com.example.EWA_backend.users.UserResponse;
import com.example.EWA_backend.users.UserService;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.UUID;

@Service
public class StudyRoomService {

    private final StudyRoomRepository repository;
    private final UserService userService;
    private final UserBlacklistRepository blacklistRepository;

    public StudyRoomService(StudyRoomRepository repository, UserService userService, UserBlacklistRepository blacklistRepository) {
        this.repository = repository;
        this.userService = userService;
        this.blacklistRepository = blacklistRepository;
    }

    public Map<String, String> createRoom(StudyRoomResponse request) {
        String id = UUID.randomUUID().toString();

        String passwordHash = null;

        if ("private".equalsIgnoreCase(request.getType()) && request.getPassword() != null) {
            passwordHash = String.valueOf(request.getPassword());
        }

        StudyRoomEntity entity = new StudyRoomEntity(
                id,
                request.getUserId(),
                request.getName(),
                request.getDescription(),
                request.getCategory(),
                request.getType(),
                request.getMediaUrl(),
                passwordHash,
                LocalDateTime.now()
        );

        repository.save(entity);

        return Map.of("status", "ok");
    }

    public StudyRoomsPageResponse getRooms(String currentUserId, int page, int size) {

        Pageable pageable = PageRequest.of(page, size, Sort.by("type").descending());

        //Page<EventEntity> result = eventRepository.findAvailableEvents(currentUserId, pageable);
        Page<StudyRoomEntity> result = repository.findAll(pageable);

        List<String> blockedUsersIds = blacklistRepository
                .findByUserId(currentUserId)
                .stream()
                .map(UserBlacklistEntity::getBlockedUserId)
                .toList();

        List<StudyRoomResponse> content = result.getContent().stream()
                .filter(room -> !blockedUsersIds.contains(room.getUserId()))
                .map(this::toResponse)
                .toList();

        return new StudyRoomsPageResponse(
                content,
                result.getNumber(),
                result.getSize(),
                result.getTotalElements(),
                result.getTotalPages(),
                result.isLast()
        );
    }

    public StudyRoomResponse getRandomPublicRoom() {
        List<StudyRoomEntity> rooms = repository.findByType("public");

        if (rooms.isEmpty()) {
            throw new RuntimeException("Нет доступных публичных комнат");
        }

        StudyRoomEntity randomRoom = rooms.get(new Random().nextInt(rooms.size()));

        return toResponse(randomRoom);
    }

    private StudyRoomResponse toResponse(StudyRoomEntity roomEntity) {
        return new StudyRoomResponse(
                roomEntity.getId(),
                roomEntity.getUserId(),
                roomEntity.getName(),
                roomEntity.getDescription(),
                roomEntity.getCategory(),
                roomEntity.getType(),
                toUserResponse(roomEntity),
                roomEntity.getMediaUrl(),
                roomEntity.getPasswordHash()
        );
    }

    private UserResponse toUserResponse(StudyRoomEntity event) {
        UserResponse user = userService.getUserById(event.getUserId());

        return new UserResponse(
                user.getId(),
                user.getName(),
                user.getIconName(),
                user.getEmail()
        );
    }


}