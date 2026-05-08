package com.example.EWA_backend.users;

import org.springframework.stereotype.Service;

@Service
public class UserService {
    private final UserRepository userRepository;

    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public UserResponse getUserById(String id) {

        UserEntity user = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("User not found"));

        return new UserResponse(
                user.getId(),
                user.getName(),
                user.getIconName(),
                user.getEmail()
        );
    }

    public void addUser(UserResponse request) {
        UserEntity user = new UserEntity();
        user.setId(request.getId());
        user.setName(request.getName());
        user.setIconName(request.getIconName());
        user.setEmail(request.getEmail());
        userRepository.save(user);
    }

    public UserResponse updateUser(UserResponse request) {

        UserEntity user = userRepository.findById(request.getId())
                .orElseThrow(() -> new RuntimeException("User not found"));

        user.setName(request.getName());
        user.setIconName(request.getIconName());
        user.setEmail(request.getEmail());

        UserEntity updatedUser = userRepository.save(user);

        return new UserResponse(
                updatedUser.getId(),
                updatedUser.getName(),
                updatedUser.getIconName(),
                updatedUser.getEmail()
        );
    }

}