package com.example.event_echo.events.adapters.in.web;

import com.example.event_echo.events.application.dto.NewEventDto;
import com.example.event_echo.events.application.usecases.EventUseCase;
import com.example.event_echo.events.domain.Event;
import com.example.event_echo.events.infrastructure.exceptions.EventNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/events")
@RequiredArgsConstructor
public class EventController {

    private final EventUseCase eventUseCase;

    @PostMapping
    public ResponseEntity<String> createEvent(@RequestBody NewEventDto newEventDto) {
        try {
            eventUseCase.saveEvent(newEventDto);
            return ResponseEntity.ok("Event created successfully");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<String> updateEvent(@PathVariable String id, @RequestBody Event event) {
        try {
            eventUseCase.updateEvent(Long.valueOf(id), event);
            return ResponseEntity.ok("Event updated successfully");
        } catch (EventNotFoundException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<String> deleteEvent(@PathVariable String id) {
        try {
            eventUseCase.deleteEvent(Long.valueOf(id));
            return ResponseEntity.ok("Event deleted successfully");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @GetMapping("/{id}")
    public ResponseEntity<Event> getEventById(@PathVariable String id) {
        try {
            Event event = eventUseCase.getEventById(Long.valueOf(id));
            return ResponseEntity.ok(event);
        } catch (Exception e) {
            return ResponseEntity.notFound().build();
        }
    }

    @GetMapping("/uid/{uid}")
    public ResponseEntity<List<Event>> getEventsByUid(@PathVariable String uid) {
        try {
            List<Event> events = eventUseCase.getEventsByUid(uid);
            return ResponseEntity.ok(events);
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }

    @GetMapping
    public ResponseEntity<List<Event>> getAllEvents() {
        List<Event> events = eventUseCase.getAllEvents();
        return ResponseEntity.ok(events);
    }
}
