package com.example.event_echo.users.application.dto;

public record NewUserDto(
        String id,
        String name,
        String phoneNumber,
        String email,
        String password
) {}
