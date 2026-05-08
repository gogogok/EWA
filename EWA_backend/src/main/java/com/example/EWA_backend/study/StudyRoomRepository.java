package com.example.EWA_backend.study;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface StudyRoomRepository extends JpaRepository<StudyRoomEntity, String> {
    List<StudyRoomEntity> findByType(String type);
}
