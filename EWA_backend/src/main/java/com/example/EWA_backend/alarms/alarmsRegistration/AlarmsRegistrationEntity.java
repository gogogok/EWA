package com.example.EWA_backend.alarms.alarmsRegistration;

import jakarta.persistence.*;

import java.time.LocalDateTime;

@Entity
@Table(
        name = "alarm_registrations",
        uniqueConstraints = {
                @UniqueConstraint(
                        name = "unique_user_alarm",
                        columnNames = {"user_id", "alarm_id"}
                )
        }
)
public class AlarmsRegistrationEntity {

    @Id
    private String id;

    @Column(name = "alarm_id", nullable = false)
    private String alarmId;

    @Column(name = "user_id", nullable = false)
    private String userId;

    @Column(nullable = false)
    private String status = "INVITED";

    @Column(name = "alarm_kit_id")
    private String alarmKitId;

    @Column(name = "scheduled_at")
    private LocalDateTime scheduledAt;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    public AlarmsRegistrationEntity() {
    }

    public AlarmsRegistrationEntity(String id, String alarmId, String userId) {
        this.id = id;
        this.alarmId = alarmId;
        this.userId = userId;
        this.status = "INVITED";
        this.createdAt = LocalDateTime.now();
    }

    public AlarmsRegistrationEntity(
            String id,
            String alarmId,
            String userId,
            String status,
            String alarmKitId,
            LocalDateTime scheduledAt,
            LocalDateTime createdAt
    ) {
        this.id = id;
        this.alarmId = alarmId;
        this.userId = userId;
        this.status = status;
        this.alarmKitId = alarmKitId;
        this.scheduledAt = scheduledAt;
        this.createdAt = createdAt;
    }

    @PrePersist
    public void prePersist() {
        if (status == null) {
            status = "INVITED";
        }

        if (createdAt == null) {
            createdAt = LocalDateTime.now();
        }
    }

    public String getId() {
        return id;
    }

    public String getAlarmId() {
        return alarmId;
    }

    public String getUserId() {
        return userId;
    }

    public String getStatus() {
        return status;
    }

    public String getAlarmKitId() {
        return alarmKitId;
    }

    public LocalDateTime getScheduledAt() {
        return scheduledAt;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setId(String id) {
        this.id = id;
    }

    public void setAlarmId(String alarmId) {
        this.alarmId = alarmId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public void setAlarmKitId(String alarmKitId) {
        this.alarmKitId = alarmKitId;
    }

    public void setScheduledAt(LocalDateTime scheduledAt) {
        this.scheduledAt = scheduledAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}