package com.example.EWA_backend.Controllers;

import com.example.EWA_backend.alarms.AlarmRegistrationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.util.Map;

@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(AlarmRegistrationException.class)
    public ResponseEntity<Map<String, String>> handleAlarmRegistrationException(
            AlarmRegistrationException ex
    ) {
        return ResponseEntity
                .status(HttpStatus.CONFLICT)
                .body(Map.of("message", ex.getMessage()));
    }
}
