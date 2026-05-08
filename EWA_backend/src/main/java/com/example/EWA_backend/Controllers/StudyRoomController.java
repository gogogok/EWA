package com.example.EWA_backend.Controllers;

import com.example.EWA_backend.alarms.*;
import com.example.EWA_backend.alarms.alarmsRegistration.AlarmRegistrationService;
import com.example.EWA_backend.study.*;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("api/study/room")
public class StudyRoomController {

    private final StudyRoomService studyService;
    private final StudyRoomParticipantService participantService;

    public StudyRoomController(StudyRoomService studyService, AlarmRegistrationService alarmRegistrationService, StudyRoomParticipantService participantService) {
        this.studyService = studyService;
        this.participantService = participantService;
    }

    @PostMapping("/add")
    public Map<String, String> addRoom(@RequestBody StudyRoomResponse request) {
        studyService.createRoom(request);
        return Map.of("status", "ok");
    }

    @GetMapping()
    public StudyRoomsPageResponse getRooms(
            @RequestParam String userId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size
    ) {
        return studyService.getRooms(userId, page, size);
    }

    @PostMapping("/{roomId}/participants/join")
    public Map<String, String> joinRoom(
            @PathVariable String roomId,
            @RequestBody StudyRoomParticipant request
    ) {
        request.setRoomId(roomId);
        participantService.joinRoom(request);
        return Map.of("status", "ok");
    }

    @GetMapping("/{roomId}/participants")
    public List<StudyRoomParticipant> getParticipants(@PathVariable String roomId) {
        return participantService.getParticipants(roomId);
    }

    @GetMapping("/random-public")
    public StudyRoomResponse getRandomPublicRoom() {
        return studyService.getRandomPublicRoom();
    }

    @DeleteMapping("/{roomId}/participants/{userId}/leave")
    public Map<String, String> leaveRoom(
            @PathVariable String roomId,
            @PathVariable String userId
    ) {
        participantService.leaveRoom(roomId, userId);
        return Map.of("status", "ok");
    }
}