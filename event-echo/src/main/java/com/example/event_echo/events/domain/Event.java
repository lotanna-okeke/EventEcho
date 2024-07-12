package com.example.event_echo.events.domain;

import java.time.LocalDate;

public record Event(
        Long id,
        String uid,
        String category,
        String title,
        String content,
        LocalDate issueDate,
        LocalDate expiryDate,
        Integer renewalDays,
        Reminders reminders
) {}
