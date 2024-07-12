package com.example.event_echo.eventcategories.adapters.in.web;

import com.example.event_echo.eventcategories.application.usecases.EventCategoryUseCase;
import com.example.event_echo.eventcategories.domain.EventCategory;
import com.example.event_echo.eventcategories.infrastructure.exceptions.EventCategoryNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/eventcategories")
@RequiredArgsConstructor
public class EventCategoryController {

    private final EventCategoryUseCase eventCategoryUseCase;

    @PostMapping
    public ResponseEntity<String> createEventCategory(@RequestBody EventCategory eventCategory) {
        try {
            eventCategoryUseCase.saveEventCategory(eventCategory);
            return ResponseEntity.ok("Event category created successfully");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<String> updateEventCategory(@PathVariable Long id, @RequestBody EventCategory eventCategory) {
        try {
            eventCategoryUseCase.updateEventCategory(id, eventCategory);
            return ResponseEntity.ok("Event category updated successfully");
        } catch (EventCategoryNotFoundException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<String> deleteEventCategory(@PathVariable Long id) {
        try {
            eventCategoryUseCase.deleteEventCategory(id);
            return ResponseEntity.ok("Event category deleted successfully");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @GetMapping("/{id}")
    public ResponseEntity<EventCategory> getEventCategoryById(@PathVariable Long id) {
        try {
            EventCategory eventCategory = eventCategoryUseCase.getEventCategoryById(id);
            return ResponseEntity.ok(eventCategory);
        } catch (Exception e) {
            return ResponseEntity.notFound().build();
        }
    }

    @GetMapping
    public ResponseEntity<List<EventCategory>> getAllEventCategories() {
        List<EventCategory> eventCategories = eventCategoryUseCase.getAllEventCategories();
        return ResponseEntity.ok(eventCategories);
    }

    @GetMapping("/types")
    public ResponseEntity<List<String>> getAllCategoryTypes() {
        List<String> types = eventCategoryUseCase.getAllCategoryTypes();
        return ResponseEntity.ok(types);
    }

    @GetMapping("/renewal-days")
    public ResponseEntity<Integer> getRenewalDaysByTypeAndTitle(
            @RequestParam String type,
            @RequestParam String title) {
        try {
            Integer renewalDays = eventCategoryUseCase.getRenewalDaysByTypeAndTitle(type, title);
            return ResponseEntity.ok(renewalDays);
        } catch (EventCategoryNotFoundException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
        }
    }
}
