package com.example.event_echo.eventcategories.application.dao;

import com.example.event_echo.eventcategories.domain.EventCategory;

import java.util.List;
import java.util.Optional;

public interface EventCategoryDAO {
    Optional<EventCategory> findEventCategoryByTypeAndTitle(String type, String title);
    Optional<EventCategory> findEventCategoryById(Long id);
    List<EventCategory> findAllEventCategories();
    List<String> findAllCategoryTypes();
    Optional<Integer> findRenewalDaysByTypeAndTitle(String type, String title);
    void saveEventCategory(EventCategory eventCategory);
    void updateEventCategory(Long id, EventCategory eventCategory);
    void deleteEventCategory(EventCategory eventCategory);
}
