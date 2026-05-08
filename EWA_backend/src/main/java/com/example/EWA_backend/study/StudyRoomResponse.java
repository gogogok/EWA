package com.example.EWA_backend.study;

import com.example.EWA_backend.users.UserResponse;

public class StudyRoomResponse {

    private String id;
    private String userId;
    private String name;
    private String description;
    private String category;
    private String type;
    private UserResponse user;
    private String mediaUrl;
    private String password;

    public StudyRoomResponse() {
    }

    public StudyRoomResponse(
            String id,
            String userId,
            String name,
            String description,
            String category,
            String type,
            UserResponse user,
            String mediaUrl,
            String password
    ) {
        this.id = id;
        this.userId = userId;
        this.name = name;
        this.description = description;
        this.category = category;
        this.type = type;
        this.user = user;
        this.mediaUrl = mediaUrl;
        this.password = password;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public UserResponse getUser() {
        return user;
    }

    public void setUser(UserResponse user) {
        this.user = user;
    }

    public String getMediaUrl() {
        return mediaUrl;
    }

    public void setMediaUrl(String mediaUrl) {
        this.mediaUrl = mediaUrl;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
}