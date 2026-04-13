package com.example.EWA_backend.users;

public class UserResponse {

    private Long id;
    private String name;
    private String iconName;
    private String email;

    public UserResponse() {
    }

    public UserResponse(Long id, String name, String iconName, String email) {
        this.id = id;
        this.name = name;
        this.iconName = iconName;
        this.email = email;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getIconName() {
        return iconName;
    }

    public void setIconName(String iconName) {
        this.iconName = iconName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }
}