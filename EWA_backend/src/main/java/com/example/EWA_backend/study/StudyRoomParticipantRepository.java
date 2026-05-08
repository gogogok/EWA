package com.example.EWA_backend.study;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface StudyRoomParticipantRepository
        extends JpaRepository<StudyRoomParticipant, String> {

    List<StudyRoomParticipant> findByRoomId(String roomId);

    Optional<StudyRoomParticipant> findByRoomIdAndUserId(String roomId, String userId);

    void deleteByRoomIdAndUserId(String roomId, String userId);

    long countByRoomId(String roomId);
}