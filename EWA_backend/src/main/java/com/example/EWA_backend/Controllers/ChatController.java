package com.example.EWA_backend.Controllers;

import com.example.EWA_backend.web.ChatMessage;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

import java.time.LocalDateTime;

@Controller
public class ChatController {

    private final SimpMessagingTemplate messagingTemplate;

    public ChatController(SimpMessagingTemplate messagingTemplate) {
        this.messagingTemplate = messagingTemplate;
    }

    @MessageMapping("/chat.send")
    public void sendMessage(ChatMessage message) {
        message.setCreatedAt(LocalDateTime.now());

        messagingTemplate.convertAndSend(
                "/topic/rooms/" + message.getRoomId(),
                message
        );
    }
}