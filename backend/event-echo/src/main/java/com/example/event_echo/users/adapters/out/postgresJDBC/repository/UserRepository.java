package com.example.event_echo.users.adapters.out.postgresJDBC.repository;

import com.example.event_echo.users.adapters.out.postgresJDBC.entity.UserEntity;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface UserRepository extends JpaRepository<UserEntity, String> {
    Optional<UserEntity> findByEmail(String email);
}
