package com.example.EWA_backend.Controllers;

import com.example.EWA_backend.users.UserBlacklistService;
import com.example.EWA_backend.users.AddUserToBlacklistRequest;
import com.example.EWA_backend.users.UserResponse;
import com.example.EWA_backend.users.UserService;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/user")
public class UserController {

    private final UserService userService;
    private final UserBlacklistService blacklistService;

    public UserController(UserService userService, UserBlacklistService blacklistService) {
        this.userService = userService;
        this.blacklistService = blacklistService;
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

    @PostMapping("blacklist/add")
    public Map<String, String> addToBlacklist(
            @RequestBody AddUserToBlacklistRequest request
    ) {
        blacklistService.addToBlacklist(
                request.getUserId(),
                request.getBlockedUserId()
        );

        return Map.of("status", "ok");
    }

    @DeleteMapping("blacklist/delete")
    public Map<String, String> deleteFromBlacklist(
            @RequestBody AddUserToBlacklistRequest request
    ) {
        blacklistService.removeFromBlacklist(request.getUserId(), request.getBlockedUserId());

        return Map.of("status", "ok");
    }

    @GetMapping("blacklist/{userId}")
    public List<UserResponse> getUsersInBlackList(@PathVariable String userId) {
        return blacklistService.getUsersInBlackList(userId);
    }
}