package com.example.EWA_backend.users;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(
        name = "user_blacklist",
        uniqueConstraints = {
                @UniqueConstraint(columnNames = {"user_id", "blocked_user_id"})
        }
)
public class UserBlacklistEntity {

    @Id
    private String id;

    @Column(name = "user_id", nullable = false)
    private String userId;

    @Column(name = "blocked_user_id", nullable = false)
    private String blockedUserId;

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;

    public UserBlacklistEntity() {
    }

    public UserBlacklistEntity(String userId, String blockedUserId) {
        this.id = UUID.randomUUID().toString();
        this.userId = userId;
        this.blockedUserId = blockedUserId;
        this.createdAt = LocalDateTime.now();
    }

    public String getId() {
        return id;
    }

    public String getUserId() {
        return userId;
    }

    public String getBlockedUserId() {
        return blockedUserId;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
}