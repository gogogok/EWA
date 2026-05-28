package com.example.EWA_backend.alarms;

import com.example.EWA_backend.alarms.alarmsRegistration.AlarmRegistrationRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.inOrder;
import org.mockito.InOrder;

@ExtendWith(MockitoExtension.class)
class AlarmCleanupServiceTest {

    @Mock
    private AlarmRepository alarmRepository;

    @Mock
    private AlarmRegistrationRepository alarmRegistrationRepository;

    @InjectMocks
    private AlarmCleanupService service;

    @Test
    void cleanupExpiredAlarmsDeletesRegistrationsBeforeAlarms() {
        service.cleanupExpiredAlarms();

        InOrder inOrder = inOrder(alarmRegistrationRepository, alarmRepository);
        inOrder.verify(alarmRegistrationRepository).deleteRegistrationsForExpiredAlarms();
        inOrder.verify(alarmRepository).deleteExpiredAlarms();
    }
}
