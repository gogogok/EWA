package com.example.EWA_backend.alarms.alarmsRegistration;

import com.example.EWA_backend.alarms.AlarmRegistrationException;
import com.example.EWA_backend.alarms.AlarmRepository;
import com.example.EWA_backend.alarms.AlarmResponse;
import com.example.EWA_backend.alarms.AlarmService;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Service
public class AlarmRegistrationService {

    private final AlarmRegistrationRepository alarmRegistrationRepository;
    private final AlarmService alarmService;
    private final AlarmRepository alarmRepository;

    public AlarmRegistrationService(AlarmRegistrationRepository alarmRegistrationRepository, AlarmService alarmService, AlarmRepository alarmRepository) {
        this.alarmRegistrationRepository = alarmRegistrationRepository;
        this.alarmService = alarmService;
        this.alarmRepository = alarmRepository;
    }

    public AlarmResponse joinAlarm(String alarmId, String userId, String status) {
        boolean alreadyExists =
                alarmRegistrationRepository.existsByAlarmIdAndUserId(alarmId, userId);

        if (alreadyExists) {
            throw new AlarmRegistrationException(
                    "Нельзя зарегистрироваться второй раз или на собственный будильник!"
            );
        }

        AlarmsRegistrationEntity registration = new AlarmsRegistrationEntity();
        registration.setId(UUID.randomUUID().toString());
        registration.setAlarmId(alarmId);
        registration.setUserId(userId);
        registration.setStatus(status);

        alarmRegistrationRepository.save(registration);

        return alarmService.getAlarmById(alarmId);
    }


    public long getResponsesCount(String alarmId) {
        return alarmRegistrationRepository.countByAlarmId(alarmId);
    }

    public List<AlarmResponse> getAlarmsByUserId(String userId) {

        List<AlarmsRegistrationEntity> alarmRegistrations =
                alarmRegistrationRepository.findByUserId(userId);

        List<AlarmResponse> alarmsDto = new ArrayList<>();

        for (AlarmsRegistrationEntity alarmReg : alarmRegistrations) {

            if ("scheduled".equalsIgnoreCase(alarmReg.getStatus())) {
                continue;
            }

            alarmsDto.add(
                    alarmService.getAlarmById(alarmReg.getAlarmId())
            );
        }

        return alarmsDto;
    }

    @Transactional
    public void leaveAlarm(String alarmId, String userId) {

        AlarmsRegistrationEntity registration = alarmRegistrationRepository
                .findByAlarmIdAndUserId(alarmId, userId)
                .orElseThrow(() -> new RuntimeException("User is not registered for this event"));

        alarmRegistrationRepository.delete(registration);
    }

    @Transactional
    public void deleteAlarm(String alarmId, String userId) {
        AlarmResponse alarm = alarmService.getAlarmById(alarmId);
        if (!alarm.getUserId().equals(userId)) {
            throw new RuntimeException("Only creator can delete this event");
        }

        alarmRegistrationRepository.deleteByAlarmId(alarm.getId());
        alarmService.deleteAlarm(alarm.getId());
    }
}
