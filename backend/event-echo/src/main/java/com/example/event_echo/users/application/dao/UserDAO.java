package com.example.event_echo.users.application.dao;

import com.example.event_echo.users.application.dto.NewUserDto;
import com.example.event_echo.users.domain.User;

import java.util.List;
import java.util.Optional;

public interface UserDAO {
    Optional<User> findUserById(String id);
    Optional<User> findUserByEmail(String email);
    List<User> findAllUsers();
    void saveUser(NewUserDto user);
    void updateUser(String id, User user);
    void deleteUser(String id);
}
