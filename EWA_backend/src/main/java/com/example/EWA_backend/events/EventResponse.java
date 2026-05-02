package com.example.EWA_backend.events;

import com.example.EWA_backend.users.UserResponse;

public class EventResponse {

    private String id;
    private String userId;
    private String name;
    private String category;
    private String date;
    private String time;
    private String place;
    private String description;
    private String comment;
    private UserResponse user;

    public EventResponse() {
    }

    public EventResponse(String id, String userId, String name, String category,
                         String date, String time, String place,
                         String description, String comment,
                         UserResponse user) {
        this.id = id;
        this.userId = userId;
        this.name = name;
        this.category = category;
        this.date = date;
        this.time = time;
        this.place = place;
        this.description = description;
        this.comment = comment;
        this.user = user;
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

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public String getTime() {
        return time;
    }

    public void setTime(String time) {
        this.time = time;
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