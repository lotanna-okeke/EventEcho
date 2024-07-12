package com.example.event_echo.eventcategories.adapters.out.postgresJDBC;

import com.example.event_echo.eventcategories.adapters.out.postgresJDBC.entity.EventCategoryEntity;
import com.example.event_echo.eventcategories.adapters.out.postgresJDBC.repository.EventCategoryRepository;
import com.example.event_echo.eventcategories.application.dao.EventCategoryDAO;
import com.example.event_echo.eventcategories.domain.EventCategory;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@RequiredArgsConstructor
@Component
public class EventCategoryDaoAdapter implements EventCategoryDAO {
    private final EventCategoryRepository eventCategoryRepository;

    @Override
    public Optional<EventCategory> findEventCategoryByTypeAndTitle(String type, String title) {
        return eventCategoryRepository.findByTypeAndTitle(type, title)
                .map(this::toDomain);
    }

    @Override
    public Optional<EventCategory> findEventCategoryById(Long id) {
        return eventCategoryRepository.findById(id)
                .map(this::toDomain);
    }

    @Override
    public List<EventCategory> findAllEventCategories() {
        return eventCategoryRepository.findAll().stream()
                .map(this::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<String> findAllCategoryTypes() {
        return eventCategoryRepository.findAllCategoryTypes();
    }

    @Override
    public Optional<Integer> findRenewalDaysByTypeAndTitle(String type, String title) {
        return eventCategoryRepository.findRenewalDaysByTypeAndTitle(type, title);
    }

    @Override
    public void saveEventCategory(EventCategory eventCategory) {
        EventCategoryEntity entity = toEntity(eventCategory);
        eventCategoryRepository.save(entity);
    }

    @Override
    public void updateEventCategory(Long id, EventCategory eventCategory) {
        EventCategoryEntity entity = toEntity(eventCategory);
        entity.setId(id);
        eventCategoryRepository.save(entity);
    }

    @Override
    public void deleteEventCategory(EventCategory eventCategory) {
        EventCategoryEntity entity = toEntity(eventCategory);
        eventCategoryRepository.delete(entity);
    }

    private EventCategory toDomain(EventCategoryEntity entity) {
        return new EventCategory(
                entity.getId(),
                entity.getType(),
                entity.getTitle(),
                entity.getRenewalDays(),
                entity.getMultiple(),
                entity.getExpiryYears()
        );
    }

    private EventCategoryEntity toEntity(EventCategory eventCategory) {
        return new EventCategoryEntity(
                eventCategory.id(),
                eventCategory.type(),
                eventCategory.title(),
                eventCategory.renewalDays(),
                eventCategory.multiple(),
                eventCategory.expiryYears()
        );
    }
}
