package com.example.event_echo.users.domain;

public record User(
        String id,
        String name,
        String phoneNumber,
        String email,
        String password
) {}
