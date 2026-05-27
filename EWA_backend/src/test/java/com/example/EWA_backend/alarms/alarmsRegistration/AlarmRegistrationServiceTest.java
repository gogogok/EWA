package com.example.EWA_backend.alarms.alarmsRegistration;

import com.example.EWA_backend.alarms.AlarmRepository;
import com.example.EWA_backend.alarms.AlarmResponse;
import com.example.EWA_backend.alarms.AlarmService;
import com.example.EWA_backend.users.UserResponse;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AlarmRegistrationServiceTest {

    @Mock
    private AlarmRegistrationRepository repository;

    @Mock
    private AlarmService alarmService;

    @Mock
    private AlarmRepository alarmRepository;

    @InjectMocks
    private AlarmRegistrationService service;

    @Test
    void joinAlarmReturnsExistingAlarmWhenRegistrationAlreadyExists() {
        AlarmResponse alarm = alarm("a1", "creator");
        when(repository.existsByAlarmIdAndUserId("a1", "u1")).thenReturn(true);
        when(alarmService.getAlarmById("a1")).thenReturn(alarm);

        AlarmResponse result = service.joinAlarm("a1", "u1", "INVITED");

        assertSame(alarm, result);
        verify(repository, never()).save(any());
    }

    @Test
    void joinAlarmSavesRegistrationAndReturnsAlarmWhenItDoesNotExist() {
        AlarmResponse alarm = alarm("a1", "creator");
        when(repository.existsByAlarmIdAndUserId("a1", "u1")).thenReturn(false);
        when(alarmService.getAlarmById("a1")).thenReturn(alarm);

        AlarmResponse result = service.joinAlarm("a1", "u1", "SCHEDULED");

        ArgumentCaptor<AlarmsRegistrationEntity> captor = ArgumentCaptor.forClass(AlarmsRegistrationEntity.class);
        verify(repository).save(captor.capture());
        assertEquals("a1", captor.getValue().getAlarmId());
        assertEquals("u1", captor.getValue().getUserId());
        assertEquals("SCHEDULED", captor.getValue().getStatus());
        assertSame(alarm, result);
    }

    @Test
    void getResponsesCountDelegatesToRepository() {
        when(repository.countByAlarmId("a1")).thenReturn(4L);

        assertEquals(4L, service.getResponsesCount("a1"));
    }

    @Test
    void getAlarmsByUserIdSkipsScheduledRegistrations() {
        AlarmsRegistrationEntity invited = new AlarmsRegistrationEntity("r1", "a1", "u1", "INVITED", null, null, null);
        AlarmsRegistrationEntity scheduled = new AlarmsRegistrationEntity("r2", "a2", "u1", "SCHEDULED", null, null, null);
        when(repository.findByUserId("u1")).thenReturn(List.of(invited, scheduled));
        when(alarmService.getAlarmById("a1")).thenReturn(alarm("a1", "creator"));

        List<AlarmResponse> result = service.getAlarmsByUserId("u1");

        assertEquals(1, result.size());
        assertEquals("a1", result.get(0).getId());
        verify(alarmService, never()).getAlarmById("a2");
    }

    @Test
    void leaveAlarmDeletesExistingRegistration() {
        AlarmsRegistrationEntity registration = new AlarmsRegistrationEntity("r1", "a1", "u1");
        when(repository.findByAlarmIdAndUserId("a1", "u1")).thenReturn(Optional.of(registration));

        service.leaveAlarm("a1", "u1");

        verify(repository).delete(registration);
    }

    @Test
    void leaveAlarmThrowsWhenRegistrationDoesNotExist() {
        when(repository.findByAlarmIdAndUserId("a1", "u1")).thenReturn(Optional.empty());

        RuntimeException exception = assertThrows(RuntimeException.class, () -> service.leaveAlarm("a1", "u1"));

        assertEquals("User is not registered for this event", exception.getMessage());
    }

    @Test
    void deleteAlarmAllowsOnlyCreator() {
        when(alarmService.getAlarmById("a1")).thenReturn(alarm("a1", "creator"));

        service.deleteAlarm("a1", "creator");

        verify(repository).deleteByAlarmId("a1");
        verify(alarmService).deleteAlarm("a1");
    }

    @Test
    void deleteAlarmThrowsWhenUserIsNotCreator() {
        when(alarmService.getAlarmById("a1")).thenReturn(alarm("a1", "creator"));

        RuntimeException exception = assertThrows(RuntimeException.class, () -> service.deleteAlarm("a1", "other"));

        assertEquals("Only creator can delete this event", exception.getMessage());
        verify(repository, never()).deleteByAlarmId(anyString());
        verify(alarmService, never()).deleteAlarm(anyString());
    }

    private static AlarmResponse alarm(String id, String userId) {
        return new AlarmResponse(id, userId, "Wake", "morning", "comment", "#fff", "20.05.2026", "06:30", new UserResponse(userId, "Creator", "icon", "mail"), 1);
    }
}
