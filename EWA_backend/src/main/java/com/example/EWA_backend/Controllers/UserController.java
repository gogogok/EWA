package com.example.EWA_backend.Controllers;

import com.example.EWA_backend.events.EventResponse;
import com.example.EWA_backend.users.UserResponse;
import com.example.EWA_backend.users.UserService;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/user")
public class UserController {

    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    @PostMapping("/add")
    public Map<String, String> addUser(@RequestBody UserResponse request) {
        userService.addUser(request);
        return Map.of("status", "ok");
    }

    @PostMapping("/update")
    public Map<String, String> updateUser(@RequestBody UserResponse request) {
        userService.updateUser(request);
        return Map.of("status", "ok");
    }

    @GetMapping("/{id}")
    public UserResponse getUserById(@PathVariable String id) {
        return userService.getUserById(id);
    }
}