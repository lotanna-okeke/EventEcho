package com.example.event_echo.eventcategories.adapters.out.postgresJDBC.repository;

import com.example.event_echo.eventcategories.adapters.out.postgresJDBC.entity.EventCategoryEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;

public interface EventCategoryRepository extends JpaRepository<EventCategoryEntity, Long> {
    Optional<EventCategoryEntity> findByTypeAndTitle(String type, String title);

    @Query("SELECT DISTINCT e.type FROM EventCategoryEntity e")
    List<String> findAllCategoryTypes();

    @Query("SELECT e.renewalDays FROM EventCategoryEntity e WHERE e.type = :type AND e.title = :title")
    Optional<Integer> findRenewalDaysByTypeAndTitle(String type, String title);
}
