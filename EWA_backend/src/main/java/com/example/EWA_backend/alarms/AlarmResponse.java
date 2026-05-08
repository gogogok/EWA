package com.example.EWA_backend.alarms;

import com.example.EWA_backend.users.UserResponse;

public class AlarmResponse {

    private String id;
    private String userId;

    private String description;
    private String category;
    private String comment;
    private String categoryHexColor;
    private String date;
    private String time;

    private UserResponse user;
    private int countPart;

    public AlarmResponse() {
    }

    public AlarmResponse(String id,
                         String userId,
                         String description,
                         String category,
                         String comment,
                         String categoryHexColor,
                         String date,
                         String time,
                         UserResponse user,
                         int countPart) {
        this.id = id;
        this.userId = userId;
        this.description = description;
        this.category = category;
        this.comment = comment;
        this.categoryHexColor = categoryHexColor;
        this.date = date;
        this.time = time;
        this.user = user;
        this.countPart = countPart;
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

    public String getCategoryHexColor() {
        return categoryHexColor;
    }

    public void setCategoryHexColor(String categoryHexColor) {
        this.categoryHexColor = categoryHexColor;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
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


    public UserResponse getUser() {
        return user;
    }

    public void setUser(UserResponse user) {
        this.user = user;
    }

    public int getCountPart() {
        return countPart;
    }

    public void setCountPart(int countPart) {
        this.countPart = countPart;
    }
}