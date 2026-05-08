package com.example.EWA_backend.Controllers;

import com.example.EWA_backend.web.VideoSyncEvent;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

@Controller
public class VideoSyncController {

    private final SimpMessagingTemplate messagingTemplate;

    public VideoSyncController(SimpMessagingTemplate messagingTemplate) {
        this.messagingTemplate = messagingTemplate;
    }

    @MessageMapping("/video/sync")
    public void syncVideo(VideoSyncEvent event) {
        messagingTemplate.convertAndSend(
                "/topic/room/" + event.getRoomId() + "/video",
                event
        );
    }
}