package com.example.event_echo.events.adapters.out.postgresJDBC;

import com.example.event_echo.events.adapters.out.postgresJDBC.entity.EventEntity;
import com.example.event_echo.events.adapters.out.postgresJDBC.entity.ReminderEntity;
import com.example.event_echo.events.adapters.out.postgresJDBC.repository.EventRepository;
import com.example.event_echo.events.application.dao.EventDAO;
import com.example.event_echo.events.application.dto.NewEventDto;
import com.example.event_echo.events.domain.Event;
import com.example.event_echo.events.domain.Reminders;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import java.util.stream.StreamSupport;

@RequiredArgsConstructor
@Component
public class EventDaoAdapter implements EventDAO {
    private final EventRepository eventRepository;

    @Override
    public Optional<Event> findEventById(Long id) {
        return eventRepository.findById(id)
                .map(this::toDomain);
    }

    @Override
    public List<Event> findEventsByUid(String uid) { // Changed from Long to String
        return eventRepository.findEventByUid(uid)
                .stream()
                .map(this::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<Event> findAllEvents() {
        return StreamSupport.stream(eventRepository.findAll().spliterator(), false)
                .map(this::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public void saveEvent(NewEventDto event) {
        EventEntity entity = toEntity(event);
        eventRepository.save(entity);
    }

    @Override
    public void updateEvent(Long id, Event event) {
        // Create a new Event instance with the updated id
        Event updatedEvent = new Event(
                id,
                event.uid(), // Changed from Long to String
                event.category(),
                event.title(),
                event.content(),
                event.issueDate(),
                event.expiryDate(),
                event.renewalDays(),
                event.reminders()
        );

        EventEntity entity = toEntity(updatedEvent);
        eventRepository.save(entity);
    }

    @Override
    public void deleteEvent(Event event) {
        EventEntity entity = toEntity(event);
        eventRepository.delete(entity);
    }

    private Event toDomain(EventEntity entity) {
        List<Reminders.ReminderType> reminderTypes = entity.getReminders().stream()
                .flatMap(reminderEntity -> reminderEntity.getTypes().stream())
                .map(Reminders.ReminderType::valueOf)
                .collect(Collectors.toList());

        boolean recurring = entity.getReminders().stream().anyMatch(ReminderEntity::isRecurring);

        Reminders reminders = new Reminders(recurring, reminderTypes);

        return new Event(
                entity.getId(),
                entity.getUid(), // Changed from Long to String
                entity.getCategory(),
                entity.getTitle(),
                entity.getContent(),
                entity.getIssueDate(),
                entity.getExpiryDate(),
                entity.getRenewalDays(),
                reminders
        );
    }

    private EventEntity toEntity(NewEventDto dto) {
        EventEntity eventEntity = new EventEntity();
        eventEntity.setUid(String.valueOf(dto.uid()));
        eventEntity.setCategory(dto.category());
        eventEntity.setTitle(dto.title());
        eventEntity.setContent(dto.content());
        eventEntity.setIssueDate(dto.issueDate());
        eventEntity.setExpiryDate(dto.expiryDate());
        eventEntity.setRenewalDays(dto.renewalDays());

        // Create ReminderEntities even if types are empty
        List<ReminderEntity> reminderEntities = dto.reminders().getTypes().stream()
                .map(type -> new ReminderEntity(null, eventEntity, dto.reminders().isRecurring(), List.of(String.valueOf(type))))
                .collect(Collectors.toList());

        // Handle case when types are empty
        if (reminderEntities.isEmpty()) {
            reminderEntities.add(new ReminderEntity(null, eventEntity, dto.reminders().isRecurring(), new ArrayList<>()));
        }

        eventEntity.setReminders(reminderEntities);
        return eventEntity;
    }


    private EventEntity toEntity(Event event) {
        EventEntity eventEntity = new EventEntity();
        eventEntity.setId(event.id());
        eventEntity.setUid(event.uid());
        eventEntity.setCategory(event.category());
        eventEntity.setTitle(event.title());
        eventEntity.setContent(event.content());
        eventEntity.setIssueDate(event.issueDate());
        eventEntity.setExpiryDate(event.expiryDate());
        eventEntity.setRenewalDays(event.renewalDays());

        // Handle empty types
        List<ReminderEntity> reminderEntities;
        if (event.reminders().getTypes().isEmpty()) {
            reminderEntities = List.of(new ReminderEntity(null, eventEntity, event.reminders().isRecurring(), new ArrayList<>()));
        } else {
            reminderEntities = event.reminders().getTypes().stream()
                    .map(type -> new ReminderEntity(null, eventEntity, event.reminders().isRecurring(), List.of(String.valueOf(type))))
                    .collect(Collectors.toList());
        }

        eventEntity.setReminders(reminderEntities);
        return eventEntity;
    }
}
