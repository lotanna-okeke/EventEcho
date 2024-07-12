package com.example.event_echo.events.application.dto;


import java.util.List;

public record RemindersDto(
        boolean isRecurring,
        List<String> types
) {}

