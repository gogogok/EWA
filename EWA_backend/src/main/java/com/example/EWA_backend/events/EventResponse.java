package com.example.EWA_backend.events;

import com.example.EWA_backend.users.UserResponse;

public class EventResponse {

    private Long id;
    private Long userId;
    private String name;
    private String category;
    private String dateTime;
    private String place;
    private String description;
    private String comment;
    private UserResponse user;

    public EventResponse() {
    }

    public EventResponse(Long id, Long userId, String name, String category,
                         String dateTime, String place,
                         String description, String comment,
                         UserResponse user) {
        this.id = id;
        this.userId = userId;
        this.name = name;
        this.category = category;
        this.dateTime = dateTime;
        this.place = place;
        this.description = description;
        this.comment = comment;
        this.user = user;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getDateTime() {
        return dateTime;
    }

    public void setDateTime(String dateTime) {
        this.dateTime = dateTime;
    }

    public String getPlace() {
        return place;
    }

    public void setPlace(String place) {
        this.place = place;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public UserResponse getUser() {
        return user;
    }

    public void setUser(UserResponse user) {
        this.user = user;
    }
}