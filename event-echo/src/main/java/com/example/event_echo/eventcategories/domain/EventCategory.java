package com.example.event_echo.eventcategories.domain;

import java.util.List;

public record EventCategory(
        Long id,
        String type,
        String title,
        Integer renewalDays,
        Boolean multiple,
        List<Integer> expiryYears
) {}