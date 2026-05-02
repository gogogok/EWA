package com.example.EWA_backend.events;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "event_registrations")
public class EventRegistrationEntity {

    @Id
    private String id;

    private String eventId;

    private String userId;

    public EventRegistrationEntity() {
    }

    public EventRegistrationEntity(String id, String eventId, String userId) {
        this.id = id;
        this.eventId = eventId;
        this.userId = userId;
    }

    public String getId() {
        return id;
    }

    public String getEventId() {
        return eventId;
    }

    public String getUserId() {
        return userId;
    }

    public void setId(String id) {
        this.id = id;
    }

    public void setEventId(String eventId) {
        this.eventId = eventId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }
}