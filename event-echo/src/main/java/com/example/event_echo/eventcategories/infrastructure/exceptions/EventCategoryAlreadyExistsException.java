package com.example.event_echo.eventcategories.infrastructure.exceptions;

public class EventCategoryAlreadyExistsException extends RuntimeException {
    public EventCategoryAlreadyExistsException(String message) {
        super(message);
    }
}
