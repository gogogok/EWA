package com.example.EWA_backend.Controllers;

import com.example.EWA_backend.alarms.*;
import com.example.EWA_backend.alarms.alarmsRegistration.AlarmRegistrationService;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/alarms")
public class AlarmController {

    private final AlarmService alarmService;
    private final AlarmRegistrationService alarmRegistrationService;

    public AlarmController(AlarmService alarmService, AlarmRegistrationService alarmRegistrationService) {
        this.alarmService = alarmService;
        this.alarmRegistrationService = alarmRegistrationService;
    }

    @PostMapping("/add")
    public Map<String, String> addUser(@RequestBody AlarmResponse request) {
        alarmService.addAlarm(request);
        alarmRegistrationService.createRegistrationToAlarm(request.getId(), request.getUserId(), "SCHEDULED");
        return Map.of("status", "ok");
    }

    @GetMapping()
    public AlarmsPageResponse getAlarms(
            @RequestParam String userId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            @RequestParam AlarmType type
    ) {
        return alarmService.getAlarms(userId, page, size, type);
    }

    @GetMapping("/my/{userId}")
    public List<AlarmResponse> getMyAlarms (@PathVariable String userId){
        return alarmService.getAlarmsByUserId(userId);
    }

    @PutMapping("edit/{alarmId}")
    public Map<String, String> updateAlarm(
            @PathVariable String alarmId,
            @RequestBody AlarmResponse request
    ) {
        alarmService.updateAlarm(alarmId, request);
        return Map.of("status", "ok");
    }
}