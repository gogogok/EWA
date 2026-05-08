package com.example.EWA_backend.alarms.alarmsRegistration;

import jakarta.transaction.Transactional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;

public interface AlarmRegistrationRepository extends JpaRepository<AlarmsRegistrationEntity, String> {

    List<AlarmsRegistrationEntity> findByUserId(String userId);

    List<AlarmsRegistrationEntity> findByAlarmId(String alarmId);

    long countByAlarmId(String alarmId);

    boolean existsByAlarmIdAndUserId(String alarmId, String userId);

    void deleteByAlarmIdAndUserId(String alarmId, String userId);

    Optional<AlarmsRegistrationEntity> findByAlarmIdAndUserId(String alarmId, String userId);

    void deleteByAlarmId(String id);

    @Modifying
    @Transactional
    @Query(value = """
        DELETE FROM alarm_registrations
        WHERE alarm_id IN (
            SELECT id FROM alarms
            WHERE (date + time) < NOW()
        )
        """, nativeQuery = true)
    void deleteRegistrationsForExpiredAlarms();
}