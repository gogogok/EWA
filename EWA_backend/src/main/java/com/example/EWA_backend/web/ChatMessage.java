package com.example.EWA_backend.web;

import java.time.LocalDateTime;

public class ChatMessage {

    private String roomId;
    private String userId;
    private String username;
    private String text;
    private LocalDateTime createdAt;

    public ChatMessage() {}

    public ChatMessage(String roomId, String userId, String username, String text, LocalDateTime createdAt) {
        this.roomId = roomId;
        this.userId = userId;
        this.username = username;
        this.text = text;
        this.createdAt = createdAt;
    }

    public String getRoomId() { return roomId; }
    public void setRoomId(String roomId) { this.roomId = roomId; }

    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getText() { return text; }
    public void setText(String text) { this.text = text; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}