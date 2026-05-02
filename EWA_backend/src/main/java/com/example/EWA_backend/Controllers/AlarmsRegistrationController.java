package com.example.EWA_backend.Controllers;

import com.example.EWA_backend.alarms.AlarmResponse;
import com.example.EWA_backend.alarms.alarmsRegistration.AlarmRegistrationService;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/alarmsregistration")
public class AlarmsRegistrationController {

    private final AlarmRegistrationService alarmRegistrationService;

    public AlarmsRegistrationController(AlarmRegistrationService alarmRegistrationService) {
        this.alarmRegistrationService = alarmRegistrationService;
    }

    @GetMapping("/{userId}")
    public List<AlarmResponse> getAlarmsByUserId(@PathVariable String userId) {
        return alarmRegistrationService.getAlarmsByUserId(userId);
    }

    @PostMapping("/addToAlarm/{alarmId}/{userId}/{status}")
    public Map<String, String> addAlarmRegistration(@PathVariable String alarmId, @PathVariable String userId, @PathVariable String status) {
        alarmRegistrationService.createRegistrationToAlarm(alarmId, userId, status);
        return Map.of("status", "ok");
    }

    @DeleteMapping("/{userId}/{alarmId}/leave")
    public Map<String, String> leaveAlarm(
            @PathVariable String alarmId,
            @PathVariable String userId
    ) {
        alarmRegistrationService.leaveAlarm(alarmId, userId);
        return Map.of("status", "ok");
    }

    @DeleteMapping("delete/{alarmId}/{userId}")
    public Map<String, String> deleteEvent(
            @PathVariable String alarmId,
            @PathVariable String userId
    ) {
        alarmRegistrationService.deleteAlarm(alarmId, userId);
        return Map.of("status", "ok");
    }
}