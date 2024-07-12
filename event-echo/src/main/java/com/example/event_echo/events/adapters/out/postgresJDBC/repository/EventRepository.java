package com.example.event_echo.events.adapters.out.postgresJDBC.repository;

import com.example.event_echo.events.adapters.out.postgresJDBC.entity.EventEntity;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface EventRepository extends CrudRepository<EventEntity, Long> {
    @Query("SELECT e FROM EventEntity e WHERE e.uid = :uid AND e.title = :title")
    Optional<EventEntity> findEventByUidAndTitle(@Param("uid") String uid, @Param("title") String title);
    @Query("SELECT e FROM EventEntity e WHERE e.uid = :uid")
    List<EventEntity> findEventByUid(@Param("uid") String uid);
}
