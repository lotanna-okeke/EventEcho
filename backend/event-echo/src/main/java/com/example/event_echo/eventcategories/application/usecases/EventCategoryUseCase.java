package com.example.event_echo.eventcategories.application.usecases;

import com.example.event_echo.eventcategories.application.dao.EventCategoryDAO;
import com.example.event_echo.eventcategories.domain.EventCategory;
import com.example.event_echo.eventcategories.infrastructure.exceptions.EventCategoryAlreadyExistsException;
import com.example.event_echo.eventcategories.infrastructure.exceptions.EventCategoryNotFoundException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;

@RequiredArgsConstructor
@Service
@Slf4j
public class EventCategoryUseCase {
    private final EventCategoryDAO eventCategoryDAO;

    public String saveEventCategory(EventCategory eventCategory) throws EventCategoryAlreadyExistsException {
        if (eventCategoryDAO.findEventCategoryByTypeAndTitle(eventCategory.type(), eventCategory.title()).isPresent()) {
            throw new EventCategoryAlreadyExistsException("Event category with the same type and title already exists");
        }

        eventCategoryDAO.saveEventCategory(eventCategory);
        return "Event category saved successfully";
    }

    public List<EventCategory> getAllEventCategories() {
        return eventCategoryDAO.findAllEventCategories();
    }

    public EventCategory getEventCategoryById(Long id) {
        return eventCategoryDAO.findEventCategoryById(id).orElseThrow(
                () -> new EventCategoryNotFoundException("Event category not found")
        );
    }

    public List<String> getAllCategoryTypes() {
        return eventCategoryDAO.findAllCategoryTypes();
    }

    public Integer getRenewalDaysByTypeAndTitle(String type, String title) {
        return eventCategoryDAO.findRenewalDaysByTypeAndTitle(type, title).orElseThrow(
                () -> new EventCategoryNotFoundException("Event category not found")
        );
    }

    public String updateEventCategory(Long id, EventCategory eventCategory) throws EventCategoryNotFoundException {
        eventCategoryDAO.findEventCategoryById(id).orElseThrow(
                () -> new EventCategoryNotFoundException("Event category not found")
        );

        eventCategoryDAO.updateEventCategory(id, eventCategory);
        return "Event category updated successfully";
    }

    public String deleteEventCategory(Long id) throws EventCategoryNotFoundException {
        EventCategory eventCategory = eventCategoryDAO.findEventCategoryById(id).orElseThrow(
                () -> new EventCategoryNotFoundException("Event category not found")
        );

        eventCategoryDAO.deleteEventCategory(eventCategory);
        return "Event category deleted successfully";
    }
}
