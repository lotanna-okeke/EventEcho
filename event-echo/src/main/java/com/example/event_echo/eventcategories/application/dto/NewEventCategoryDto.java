package com.example.event_echo.eventcategories.application.dto;

import java.util.List;

public record NewEventCategoryDto(
        String type,
        String title,
        Integer renewalDays,
        Boolean multiple,
        List<Integer> expiryYears
) {}