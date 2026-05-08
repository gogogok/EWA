package com.example.EWA_backend.users;

public class AddUserToBlacklistRequest {

    private String userId;
    private String blockedUserId;

    public AddUserToBlacklistRequest() {
    }

    public String getUserId() {
        return userId;
    }

    public String getBlockedUserId() {
        return blockedUserId;
    }
}