package com.example.EWA_backend.web;

public class VideoSyncEvent {
    private String roomId;
    private String userId;
    private String action;
    private double currentTime;
    private double sentAt;

    public String getRoomId() {
        return roomId;
    }

    public void setRoomId(String roomId) {
        this.roomId = roomId;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public double getCurrentTime() {
        return currentTime;
    }

    public void setCurrentTime(double currentTime) {
        this.currentTime = currentTime;
    }

    public double getSentAt() {
        return sentAt;
    }

    public void setSentAt(double sentAt) {
        this.sentAt = sentAt;
    }
}