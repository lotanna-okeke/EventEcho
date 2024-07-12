package com.example.event_echo.eventcategories.adapters.out.postgresJDBC.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Entity
@Table(name = "event_categories")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class EventCategoryEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String type;

    @Column(nullable = true)
    private String title;

    @Column(nullable = true)
    private Integer renewalDays;

    @Column(nullable = false)
    private Boolean multiple;

    @ElementCollection
    @CollectionTable(name = "event_category_expiry_years", joinColumns = @JoinColumn(name = "event_category_id"))
    @Column(name = "expiry_year")
    private List<Integer> expiryYears;
}