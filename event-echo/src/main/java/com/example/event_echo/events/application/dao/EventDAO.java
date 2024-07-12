package com.example.event_echo.events.application.dao;

import com.example.event_echo.events.application.dto.NewEventDto;
import com.example.event_echo.events.domain.Event;

import java.util.List;
import java.util.Optional;

public interface EventDAO {
    Optional<Event> findEventById(Long id);

    List<Event> findEventsByUid(String uid); // Changed from Long to String

    List<Event> findAllEvents();
    void saveEvent(NewEventDto event);
    void updateEvent(Long id, Event event);
    void deleteEvent(Event event); // Changed parameter type from Event to Event
}
