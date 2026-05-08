package com.example.EWA_backend.users;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface UserBlacklistRepository extends JpaRepository<UserBlacklistEntity, String> {

    boolean existsByUserIdAndBlockedUserId(String userId, String blockedUserId);

    List<UserBlacklistEntity> findByUserId(String userId);

    void deleteByUserIdAndBlockedUserId(String userId, String blockedUserId);
}