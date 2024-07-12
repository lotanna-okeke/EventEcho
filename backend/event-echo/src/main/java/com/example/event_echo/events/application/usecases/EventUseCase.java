package com.example.event_echo.events.application.usecases;

import com.example.event_echo.events.application.dao.EventDAO;
import com.example.event_echo.events.application.dto.NewEventDto;
import com.example.event_echo.events.domain.Event;
import com.example.event_echo.events.infrastructure.exceptions.EventAlreadyExistsException;
import com.example.event_echo.events.infrastructure.exceptions.EventNotFoundException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;

@RequiredArgsConstructor
@Service
@Slf4j
public class EventUseCase {
    private final EventDAO eventDAO;

    public String saveEvent(NewEventDto newEventDto) throws EventAlreadyExistsException {
        // Check if event already exists using uid and title
        boolean isPresent = eventDAO.findEventsByUid(String.valueOf(newEventDto.uid())).stream()
                .anyMatch(event -> event.title().equals(newEventDto.title()));
        if (isPresent) throw new EventAlreadyExistsException("Event already exists for this user");

        // Continue to save event
        eventDAO.saveEvent(newEventDto);
        return "Event saved successfully";
    }

    public List<Event> getAllEvents() {
        return eventDAO.findAllEvents();
    }

    public Event getEventById(Long id) {
        return eventDAO.findEventById(id).orElseThrow(
                () -> new EventNotFoundException("Event not found")
        );
    }

    public List<Event> getEventsByUid(String uid) { // Changed from Long to String
        return eventDAO.findEventsByUid(uid);
    }

    public String updateEvent(Long id, Event event) throws EventNotFoundException {
        // Check if event exists by id
        eventDAO.findEventById(id).orElseThrow(
                () -> new EventNotFoundException("Event not found")
        );

        // Continue to update event
        eventDAO.updateEvent(id, event);
        return "Event updated successfully";
    }

    public String deleteEvent(Long id) throws EventNotFoundException {
        // Check if event exists by id
        Event event = eventDAO.findEventById(id).orElseThrow(
                () -> new EventNotFoundException("Event not found")
        );

        // Continue to delete event
        eventDAO.deleteEvent(event);
        return "Event deleted successfully";
    }
}
