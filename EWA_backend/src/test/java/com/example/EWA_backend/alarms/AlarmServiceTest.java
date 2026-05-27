package com.example.EWA_backend.alarms;

import com.example.EWA_backend.alarms.alarmsRegistration.AlarmRegistrationRepository;
import com.example.EWA_backend.users.UserResponse;
import com.example.EWA_backend.users.UserService;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AlarmServiceTest {

    @Mock
    private AlarmRepository alarmRepository;

    @Mock
    private AlarmRegistrationRepository alarmRegistrationRepository;

    @Mock
    private UserService userService;

    @InjectMocks
    private AlarmService alarmService;

    @Test
    void getAlarmByIdReturnsAlarmWithCreatorAndParticipantsCount() {
        AlarmEntity alarm = alarm("a1", "u1");
        when(alarmRepository.findById("a1")).thenReturn(Optional.of(alarm));
        when(userService.getUserById("u1")).thenReturn(user("u1"));
        when(alarmRegistrationRepository.countByAlarmId("a1")).thenReturn(2L);

        AlarmResponse result = alarmService.getAlarmById("a1");

        assertEquals("a1", result.getId());
        assertEquals("u1", result.getUserId());
        assertEquals("Wake me up", result.getDescription());
        assertEquals("2026-05-20", result.getDate());
        assertEquals("06:30", result.getTime());
        assertEquals(2, result.getCountPart());
        assertEquals("Dara", result.getUser().getName());
    }

    @Test
    void getAlarmByIdThrowsWhenAlarmDoesNotExist() {
        when(alarmRepository.findById("missing")).thenReturn(Optional.empty());

        RuntimeException exception = assertThrows(RuntimeException.class, () -> alarmService.getAlarmById("missing"));

        assertEquals("Event not found", exception.getMessage());
    }

    @Test
    void getAlarmsByUserIdReturnsUserAlarms() {
        when(alarmRepository.findByUserId("u1")).thenReturn(List.of(alarm("a1", "u1"), alarm("a2", "u1")));
        when(userService.getUserById("u1")).thenReturn(user("u1"));
        when(alarmRegistrationRepository.countByAlarmId(anyString())).thenReturn(1L);

        List<AlarmResponse> result = alarmService.getAlarmsByUserId("u1");

        assertEquals(2, result.size());
        assertEquals("a1", result.get(0).getId());
        assertEquals(1, result.get(0).getCountPart());
    }

    @Test
    void addAlarmParsesRequestSavesEntityAndReturnsResponse() {
        AlarmResponse request = new AlarmResponse(
                "a1", "u1", "Wake", "morning", "comment", "#FFFFFF",
                "20.05.2026", "06:15", null, 4
        );
        when(userService.getUserById("u1")).thenReturn(user("u1"));
        when(alarmRegistrationRepository.countByAlarmId("a1")).thenReturn(0L);

        AlarmResponse result = alarmService.addAlarm(request);

        ArgumentCaptor<AlarmEntity> captor = ArgumentCaptor.forClass(AlarmEntity.class);
        verify(alarmRepository).save(captor.capture());
        assertEquals(LocalDate.of(2026, 5, 20), captor.getValue().getDate());
        assertEquals(LocalTime.of(6, 15), captor.getValue().getTime());
        assertEquals("20.05.2026", result.getDate());
        assertEquals("06:15", result.getTime());
    }

    @Test
    void deleteAlarmDeletesAlarmAndItsRegistrations() {
        alarmService.deleteAlarm("a1");

        verify(alarmRepository).deleteById("a1");
        verify(alarmRegistrationRepository).deleteByAlarmId("a1");
    }

    @Test
    void getAlarmsWithAlmostWakeUpUsesDateAndTimeBetweenQuery() {
        Page<AlarmEntity> page = new PageImpl<>(List.of(alarm("a1", "u1")));
        when(alarmRepository.findByDateAndTimeBetween(any(LocalDate.class), any(LocalTime.class), any(LocalTime.class), any(Pageable.class)))
                .thenReturn(page);
        when(userService.getUserById("u1")).thenReturn(user("u1"));
        when(alarmRegistrationRepository.countByAlarmId("a1")).thenReturn(1L);

        AlarmsPageResponse result = alarmService.getAlarms("current", 0, 20, AlarmType.ALMOST_WAKE_UP);

        assertEquals(1, result.getContent().size());
        verify(alarmRepository).findByDateAndTimeBetween(any(LocalDate.class), any(LocalTime.class), any(LocalTime.class), any(Pageable.class));
        verify(alarmRepository, never()).findByDateAfter(any(LocalDate.class), any(Pageable.class));
    }

    @Test
    void getAlarmsWithWakeInAdvanceUsesDateAfterQuery() {
        Page<AlarmEntity> page = new PageImpl<>(List.of(alarm("a1", "u1")));
        when(alarmRepository.findByDateAfter(any(LocalDate.class), any(Pageable.class))).thenReturn(page);
        when(userService.getUserById("u1")).thenReturn(user("u1"));
        when(alarmRegistrationRepository.countByAlarmId("a1")).thenReturn(1L);

        AlarmsPageResponse result = alarmService.getAlarms("current", 0, 20, AlarmType.WAKE_IN_ADVANCE);

        assertEquals(1, result.getContent().size());
        verify(alarmRepository).findByDateAfter(any(LocalDate.class), any(Pageable.class));
    }

    @Test
    void updateAlarmUpdatesExistingAlarm() {
        AlarmEntity existing = alarm("a1", "u1");
        when(alarmRepository.findById("a1")).thenReturn(Optional.of(existing));

        AlarmResponse request = new AlarmResponse();
        request.setDescription("Updated");
        request.setCategory("new category");
        request.setComment("new comment");
        request.setCategoryHexColor("#000000");
        request.setDate("21.05.2026");
        request.setTime("07:45");
        request.setCountPart(5);

        alarmService.updateAlarm("a1", request);

        assertEquals("Updated", existing.getDescription());
        assertEquals("new category", existing.getCategory());
        assertEquals(LocalDate.of(2026, 5, 21), existing.getDate());
        assertEquals(LocalTime.of(7, 45), existing.getTime());
        assertEquals(5, existing.getCountPart());
        verify(alarmRepository).save(existing);
    }

    @Test
    void updateAlarmThrowsWhenAlarmDoesNotExist() {
        when(alarmRepository.findById("missing")).thenReturn(Optional.empty());

        RuntimeException exception = assertThrows(RuntimeException.class, () -> alarmService.updateAlarm("missing", new AlarmResponse()));

        assertEquals("Alarm not found", exception.getMessage());
        verify(alarmRepository, never()).save(any());
    }

    private static AlarmEntity alarm(String id, String userId) {
        AlarmEntity alarm = new AlarmEntity();
        alarm.setId(id);
        alarm.setUserId(userId);
        alarm.setDescription("Wake me up");
        alarm.setCategory("morning");
        alarm.setComment("comment");
        alarm.setCategoryHexColor("#FFFFFF");
        alarm.setDate(LocalDate.of(2026, 5, 20));
        alarm.setTime(LocalTime.of(6, 30));
        alarm.setCountPart(3);
        return alarm;
    }

    private static UserResponse user(String id) {
        return new UserResponse(id, "Dara", "icon", "dara@mail.com");
    }
}
