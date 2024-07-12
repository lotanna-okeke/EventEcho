package com.example.event_echo.events.adapters.out.postgresJDBC.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Entity
@Table(name = "reminders")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class ReminderEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "event_id", nullable = false)
    private EventEntity event;

    private boolean recurring;

    @ElementCollection(fetch = FetchType.EAGER)
    @CollectionTable(name = "reminder_types", joinColumns = @JoinColumn(name = "reminder_id"))
    @Column(name = "type")
    private List<String> types;
}