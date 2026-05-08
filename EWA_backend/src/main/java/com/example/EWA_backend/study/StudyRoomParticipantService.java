package com.example.EWA_backend.study;

import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Service
public class StudyRoomParticipantService {

    private final StudyRoomParticipantRepository repository;
    private final StudyRoomRepository roomRepository;

    public StudyRoomParticipantService(StudyRoomParticipantRepository repository, StudyRoomRepository roomRepository) {
        this.repository = repository;
        this.roomRepository = roomRepository;
    }

    public void joinRoom(StudyRoomParticipant request) {
        var existing = repository.findByRoomIdAndUserId(
                request.getRoomId(),
                request.getUserId()
        );

        if (existing.isPresent()) {
            return;
        }

        StudyRoomParticipant participant = new StudyRoomParticipant();
        participant.setId(UUID.randomUUID().toString());
        participant.setRoomId(request.getRoomId());
        participant.setUserId(request.getUserId());
        participant.setUsername(request.getUsername());
        participant.setIconName(request.getIconName());
        participant.setJoinedAt(LocalDateTime.now());

        repository.save(participant);
    }

    public List<StudyRoomParticipant> getParticipants(String roomId) {
        return repository.findByRoomId(roomId);
    }

    @Transactional
    public void leaveRoom(String roomId, String userId) {
        repository.deleteByRoomIdAndUserId(roomId, userId);

        long participantsCount = repository.countByRoomId(roomId);

        if (participantsCount == 0) {
            roomRepository.deleteById(roomId);
        }
    }
}