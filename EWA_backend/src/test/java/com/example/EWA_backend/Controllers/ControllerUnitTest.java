package com.example.EWA_backend.Controllers;

import com.example.EWA_backend.alarms.*;
import com.example.EWA_backend.alarms.alarmsRegistration.AlarmRegistrationService;
import com.example.EWA_backend.events.EventCleanupService;
import com.example.EWA_backend.events.EventResponse;
import com.example.EWA_backend.events.EventService;
import com.example.EWA_backend.events.EventsPageResponse;
import com.example.EWA_backend.events.eventsRegistration.EventRegistrationService;
import com.example.EWA_backend.study.*;
import com.example.EWA_backend.users.AddUserToBlacklistRequest;
import com.example.EWA_backend.users.UserBlacklistService;
import com.example.EWA_backend.users.UserResponse;
import com.example.EWA_backend.users.UserService;
import com.example.EWA_backend.web.ChatMessage;
import com.example.EWA_backend.web.VideoSyncEvent;
import org.junit.jupiter.api.Test;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.test.util.ReflectionTestUtils;

import java.util.List;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

class ControllerUnitTest {

    @Test
    void healthControllerReturnsOkStatus() {
        HealthController controller = new HealthController();

        assertEquals(Map.of("status", "ok"), controller.health());
    }

    @Test
    void userControllerDelegatesToServices() {
        UserService userService = mock(UserService.class);
        UserBlacklistService blacklistService = mock(UserBlacklistService.class);
        UserController controller = new UserController(userService, blacklistService);
        UserResponse user = new UserResponse("u1", "Dara", "icon", "mail");
        when(userService.getUserById("u1")).thenReturn(user);
        when(blacklistService.getUsersInBlackList("u1")).thenReturn(List.of(user));

        assertEquals("ok", controller.addUser(user).get("status"));
        assertEquals("ok", controller.updateUser(user).get("status"));
        assertSame(user, controller.getUserById("u1"));
        assertEquals(1, controller.getUsersInBlackList("u1").size());

        AddUserToBlacklistRequest request = new AddUserToBlacklistRequest();
        ReflectionTestUtils.setField(request, "userId", "u1");
        ReflectionTestUtils.setField(request, "blockedUserId", "u2");

        assertEquals("ok", controller.addToBlacklist(request).get("status"));
        assertEquals("ok", controller.deleteFromBlacklist(request).get("status"));
        verify(userService).addUser(user);
        verify(userService).updateUser(user);
        verify(blacklistService).addToBlacklist("u1", "u2");
        verify(blacklistService).removeFromBlacklist("u1", "u2");
    }

    @Test
    void eventControllerDelegatesToEventService() {
        EventService service = mock(EventService.class);
        EventCleanupService cleanupService = mock(EventCleanupService.class);
        EventController controller = new EventController(service, cleanupService);
        EventResponse event = event("e1", "u1");
        EventsPageResponse page = new EventsPageResponse(List.of(event), 0, 20, 1, 1, true);

        when(service.getEventById("e1")).thenReturn(event);
        when(service.getEvents("u1", 0, 20)).thenReturn(page);
        when(service.getEventByUserId("u1")).thenReturn(List.of(event));

        assertSame(event, controller.getEventById("e1"));
        assertEquals("ok", controller.addEvent(event).get("status"));
        assertSame(page, controller.getEvents("u1", 0, 20));
        assertEquals(1, controller.getMyEvents("u1").size());
        assertEquals("ok", controller.updateEvent("e1", event).get("status"));

        verify(service).addEvent(event);
        verify(service).updateEvent("e1", event);
    }

    @Test
    void eventsRegistrationControllerDelegatesToRegistrationService() {
        EventRegistrationService service = mock(EventRegistrationService.class);
        EventsRegistrationController controller = new EventsRegistrationController(service);
        EventResponse event = event("e1", "u1");
        when(service.getEventsByUserId("u1")).thenReturn(List.of(event));

        assertEquals(1, controller.getEventsByUserId("u1").size());
        assertEquals("ok", controller.addUser("e1", "u1").get("status"));
        assertEquals("ok", controller.leaveEvent("e1", "u1").get("status"));
        assertEquals("ok", controller.deleteEvent("e1", "u1").get("status"));

        verify(service).registerUserToEvent("e1", "u1");
        verify(service).leaveEvent("e1", "u1");
        verify(service).deleteEvent("e1", "u1");
    }

    @Test
    void alarmControllerDelegatesToServices() {
        AlarmService alarmService = mock(AlarmService.class);
        AlarmRegistrationService registrationService = mock(AlarmRegistrationService.class);
        AlarmController controller = new AlarmController(alarmService, registrationService);
        AlarmResponse alarm = alarm("a1", "u1");
        AlarmsPageResponse page = new AlarmsPageResponse(List.of(alarm), 0, 20, 1, 1, true);

        when(alarmService.addAlarm(alarm)).thenReturn(alarm);
        when(alarmService.getAlarms("u1", 0, 20, AlarmType.WAKE_IN_ADVANCE)).thenReturn(page);
        when(alarmService.getAlarmsByUserId("u1")).thenReturn(List.of(alarm));

        assertSame(alarm, controller.addAlarm(alarm));
        assertSame(page, controller.getAlarms("u1", 0, 20, AlarmType.WAKE_IN_ADVANCE));
        assertEquals(1, controller.getMyAlarms("u1").size());
        assertEquals("ok", controller.updateAlarm("a1", alarm).get("status"));

        verify(registrationService).joinAlarm("a1", "u1", "SCHEDULED");
        verify(alarmService).updateAlarm("a1", alarm);
    }

    @Test
    void alarmsRegistrationControllerDelegatesToRegistrationService() {
        AlarmRegistrationService service = mock(AlarmRegistrationService.class);
        AlarmsRegistrationController controller = new AlarmsRegistrationController(service);
        AlarmResponse alarm = alarm("a1", "u1");
        when(service.getAlarmsByUserId("u1")).thenReturn(List.of(alarm));

        assertEquals(1, controller.getAlarmsByUserId("u1").size());
        assertEquals("a1", controller.addAlarmRegistration("a1", "u1", "INVITED").getId());
        assertEquals("ok", controller.leaveAlarm("u1", "a1").get("status"));
        assertEquals("ok", controller.deleteEvent("a1", "u1").get("status"));

        verify(service).joinAlarm("a1", "u1", "INVITED");
        verify(service).leaveAlarm("u1", "a1");
        verify(service).deleteAlarm("a1", "u1");
    }

    @Test
    void studyRoomControllerDelegatesToServices() {
        StudyRoomService roomService = mock(StudyRoomService.class);
        AlarmRegistrationService alarmRegistrationService = mock(AlarmRegistrationService.class);
        StudyRoomParticipantService participantService = mock(StudyRoomParticipantService.class);
        StudyRoomController controller = new StudyRoomController(roomService, alarmRegistrationService, participantService);
        StudyRoomResponse room = room("r1", "u1");
        StudyRoomsPageResponse page = new StudyRoomsPageResponse(List.of(room), 0, 20, 1, 1, true);
        StudyRoomParticipant participant = new StudyRoomParticipant();
        participant.setUserId("u1");

        when(roomService.getRooms("u1", 0, 20)).thenReturn(page);
        when(roomService.getRandomPublicRoom()).thenReturn(room);
        when(participantService.getParticipants("r1")).thenReturn(List.of(participant));

        assertEquals("ok", controller.addRoom(room).get("status"));
        assertSame(page, controller.getRooms("u1", 0, 20));
        assertEquals("ok", controller.joinRoom("r1", participant).get("status"));
        assertEquals("r1", participant.getRoomId());
        assertEquals(1, controller.getParticipants("r1").size());
        assertSame(room, controller.getRandomPublicRoom());
        assertEquals("ok", controller.leaveRoom("r1", "u1").get("status"));

        verify(roomService).createRoom(room);
        verify(participantService).joinRoom(participant);
        verify(participantService).leaveRoom("r1", "u1");
    }

    @Test
    void chatControllerSendsMessageToRoomTopic() {
        SimpMessagingTemplate template = mock(SimpMessagingTemplate.class);
        ChatController controller = new ChatController(template);
        ChatMessage message = new ChatMessage();
        message.setRoomId("room1");

        controller.sendMessage(message);

        verify(template).convertAndSend("/topic/rooms/room1", message);
    }

    @Test
    void videoSyncControllerSendsVideoEventToRoomTopic() {
        SimpMessagingTemplate template = mock(SimpMessagingTemplate.class);
        VideoSyncController controller = new VideoSyncController(template);
        VideoSyncEvent event = new VideoSyncEvent();
        event.setRoomId("room1");

        controller.syncVideo(event);

        verify(template).convertAndSend("/topic/room/room1/video", event);
    }

    @Test
    void youTubePlayerControllerInsertsRequestedVideoIdIntoHtml() {
        YouTubePlayerController controller = new YouTubePlayerController();

        String html = controller.player("abc123");

        assertTrue(html.contains("videoId: 'abc123'"));
        assertFalse(html.contains("VIDEO_ID_PLACEHOLDER"));
        assertTrue(html.contains("function playVideo()"));
    }

    private static EventResponse event(String id, String userId) {
        return new EventResponse(id, userId, "Name", "cat", "20.05.2026", "12:30", "Place", "Desc", "Comment", new UserResponse(userId, "User", "icon", "mail"));
    }

    private static AlarmResponse alarm(String id, String userId) {
        return new AlarmResponse(id, userId, "Wake", "morning", "comment", "#fff", "20.05.2026", "06:30", new UserResponse(userId, "User", "icon", "mail"), 1);
    }

    private static StudyRoomResponse room(String id, String userId) {
        return new StudyRoomResponse(id, userId, "Room", "Description", "study", "public", new UserResponse(userId, "User", "icon", "mail"), "url", null);
    }
}
