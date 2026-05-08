package com.example.EWA_backend.alarms;

import com.example.EWA_backend.alarms.alarmsRegistration.AlarmRegistrationRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import jakarta.transaction.Transactional;

@Service
@RequiredArgsConstructor
public class AlarmCleanupService {

    private final AlarmRepository alarmRepository;
    private final AlarmRegistrationRepository alarmRegistrationRepository;

    @Transactional
    @Scheduled(fixedRate = 60000)
    public void cleanupExpiredAlarms() {
        alarmRegistrationRepository.deleteRegistrationsForExpiredAlarms();
        alarmRepository.deleteExpiredAlarms();
    }
}