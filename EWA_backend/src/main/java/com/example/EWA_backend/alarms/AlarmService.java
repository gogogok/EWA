package com.example.EWA_backend.alarms;

import com.example.EWA_backend.alarms.alarmsRegistration.AlarmRegistrationRepository;
import com.example.EWA_backend.users.UserResponse;
import com.example.EWA_backend.users.UserService;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

@Service
public class AlarmService {

    private final AlarmRepository alarmRepository;
    private final AlarmRegistrationRepository alarmRegistrationRepository;
    private final UserService userService;
    private static final DateTimeFormatter DATE_FORMATTER =
            DateTimeFormatter.ofPattern("dd.MM.yyyy");

    private static final DateTimeFormatter TIME_FORMATTER =
            DateTimeFormatter.ofPattern("HH:mm");

    public AlarmService(AlarmRepository eventRepository, AlarmRegistrationRepository alarmRegistrationRepository, UserService userService) {
        this.alarmRepository = eventRepository;
        this.alarmRegistrationRepository = alarmRegistrationRepository;
        this.userService = userService;
    }

    public AlarmResponse getAlarmById(String id) {

        AlarmEntity alarm = alarmRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Event not found"));

        UserResponse user = userService.getUserById(alarm.getUserId());

        int alarmCount = Math.toIntExact(alarmRegistrationRepository.countByAlarmId(alarm.getId()));

        return new AlarmResponse(
                alarm.getId(),
                alarm.getUserId(),
                alarm.getDescription(),
                alarm.getCategory(),
                alarm.getComment(),
                alarm.getCategoryHexColor(),
                alarm.getDate().toString(),
                alarm.getTime().toString(),
                user,
                alarmCount
        );
    }

    public List<AlarmResponse> getAlarmsByUserId(String userId) {

        List<AlarmEntity> alarms = alarmRepository.findByUserId(userId);
        UserResponse user = userService.getUserById(userId);

        List<AlarmResponse> alarmsDto = new ArrayList<>();
        for (AlarmEntity alarm : alarms) {
            int alarmCount = Math.toIntExact(alarmRegistrationRepository.countByAlarmId(alarm.getId()));
            alarmsDto.add(new AlarmResponse(
                    alarm.getId(),
                    alarm.getUserId(),
                    alarm.getDescription(),
                    alarm.getCategory(),
                    alarm.getComment(),
                    alarm.getCategoryHexColor(),
                    alarm.getDate().toString(),
                    alarm.getTime().toString(),
                    user,
                    alarmCount
            ));
        }
        return alarmsDto;
    }

    public void addAlarm(AlarmResponse request) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd.MM.yyyy");
        AlarmEntity alarm = new AlarmEntity();
        alarm.setId(request.getId());
        alarm.setUserId(request.getUserId());
        alarm.setDescription(request.getDescription());
        alarm.setCategory(request.getCategory());
        alarm.setComment(request.getComment());
        alarm.setCategoryHexColor(request.getCategoryHexColor());
        alarm.setDate(LocalDate.parse(request.getDate(), formatter));
        alarm.setTime(LocalTime.parse(request.getTime()));
        alarm.setCountPart(request.getCountPart());
        alarmRepository.save(alarm);
    }

    public void deleteAlarm(String id)
    {
        alarmRepository.deleteById(id);
        alarmRegistrationRepository.deleteByAlarmId(id);
    }

    public AlarmsPageResponse getAlarms(String currentUserId, int page, int size, AlarmType alarmType) {
        Pageable pageable = PageRequest.of(
                page,
                size,
                Sort.by("date").ascending().and(Sort.by("time").ascending())
        );

        LocalDate today = LocalDate.now();
        LocalTime now = LocalTime.now();

        Page<AlarmEntity> result;

        if (alarmType == AlarmType.ALMOST_WAKE_UP) {
            result = alarmRepository.findByDateAndTimeBetween(
                    today,
                    now,
                    now.plusMinutes(10),
                    pageable
            );
        } else {
            result = alarmRepository.findByDateAfter(
                    today,
                    pageable
            );
        }

        List<AlarmResponse> content = result.getContent().stream()
                .map(this::toResponse)
                .toList();

        return new AlarmsPageResponse(
                content,
                result.getNumber(),
                result.getSize(),
                result.getTotalElements(),
                result.getTotalPages(),
                result.isLast()
        );
    }

    private AlarmResponse toResponse(AlarmEntity alarm) {
        int alarmCount = Math.toIntExact(alarmRegistrationRepository.countByAlarmId(alarm.getId()));
        return new AlarmResponse(
                alarm.getId(),
                alarm.getUserId(),
                alarm.getDescription(),
                alarm.getCategory(),
                alarm.getComment(),
                alarm.getCategoryHexColor(),
                alarm.getDate() != null ? alarm.getDate().format(DATE_FORMATTER) : null,
                alarm.getTime() != null ? alarm.getTime().format(TIME_FORMATTER) : null,
                toUserResponse(alarm),
                alarmCount
        );
    }

    private UserResponse toUserResponse(AlarmEntity event) {
        UserResponse user = userService.getUserById(event.getUserId());

        return new UserResponse(
                user.getId(),
                user.getName(),
                user.getIconName(),
                user.getEmail()
        );
    }

    public void updateAlarm(String alarmId, AlarmResponse request) {
        AlarmEntity alarm = alarmRepository.findById(alarmId)
                .orElseThrow(() -> new RuntimeException("Alarm not found"));
        alarm.setDescription(request.getDescription());
        alarm.setCategory(request.getCategory());
        alarm.setComment(request.getComment());
        alarm.setCategoryHexColor(request.getCategoryHexColor());

        if (request.getDate() != null && !request.getDate().isBlank()) {
            alarm.setDate(LocalDate.parse(request.getDate(), DateTimeFormatter.ofPattern("dd.MM.yyyy")));
        }

        if (request.getTime() != null && !request.getTime().isBlank()) {
            alarm.setTime(LocalTime.parse(request.getTime(), DateTimeFormatter.ofPattern("HH:mm")));
        }

        alarm.setCountPart(request.getCountPart());
        alarmRepository.save(alarm);
    }
}