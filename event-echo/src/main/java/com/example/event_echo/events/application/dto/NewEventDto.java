package com.example.event_echo.events.application.dto;

import com.example.event_echo.events.domain.Reminders;

import java.time.LocalDate;

public record NewEventDto(
        String uid,
        String category,
        String title,
        String content,
        LocalDate issueDate,
        LocalDate expiryDate,
        Integer renewalDays, // New field
        Reminders reminders
) {
}