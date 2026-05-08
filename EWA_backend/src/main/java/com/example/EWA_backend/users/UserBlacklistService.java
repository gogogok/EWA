package com.example.EWA_backend.users;

import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class UserBlacklistService {

    private final UserBlacklistRepository repository;
    private final UserService userService;

    public UserBlacklistService(UserBlacklistRepository repository, UserService userService) {
        this.repository = repository;
        this.userService = userService;
    }

    public List<UserResponse> getUsersInBlackList(String userId){
        List<UserBlacklistEntity> blacklistEntities = repository.findByUserId(userId);
        if (blacklistEntities == null || blacklistEntities.isEmpty()) {
            return new ArrayList<>();
        }
        List<UserResponse> userResponses = new ArrayList<>();
        for(UserBlacklistEntity blacklistEntity : blacklistEntities){
            UserResponse userResponse = userService.getUserById(blacklistEntity.getBlockedUserId());
            userResponses.add(userResponse);
        }
        return userResponses;
    }

    public void addToBlacklist(String userId, String blockedUserId) {
        if (userId == null || blockedUserId == null) {
            throw new IllegalArgumentException("userId and blockedUserId are required");
        }

        if (userId.equals(blockedUserId)) {
            throw new IllegalArgumentException("User cannot block himself");
        }

        boolean alreadyExists = repository.existsByUserIdAndBlockedUserId(
                userId,
                blockedUserId
        );

        if (alreadyExists) {
            return;
        }

        UserBlacklistEntity entity = new UserBlacklistEntity(
                userId,
                blockedUserId
        );

        repository.save(entity);
    }

    @Transactional
    public void removeFromBlacklist(String userId, String blockedUserId) {
        if (userId == null || blockedUserId == null) {
            throw new IllegalArgumentException("userId and blockedUserId are required");
        }
        repository.deleteByUserIdAndBlockedUserId(userId, blockedUserId);
    }
}