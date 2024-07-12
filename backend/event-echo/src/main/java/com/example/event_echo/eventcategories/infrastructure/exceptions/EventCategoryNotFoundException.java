package com.example.event_echo.eventcategories.infrastructure.exceptions;

public class EventCategoryNotFoundException extends RuntimeException {
    public EventCategoryNotFoundException(String message) {
        super(message);
    }
}

