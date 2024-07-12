package com.example.event_echo.users.adapters.out.postgresJDBC;

import com.example.event_echo.users.adapters.out.postgresJDBC.entity.UserEntity;
import com.example.event_echo.users.adapters.out.postgresJDBC.repository.UserRepository;
import com.example.event_echo.users.application.dao.UserDAO;
import com.example.event_echo.users.application.dto.NewUserDto;
import com.example.event_echo.users.domain.User;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import java.util.stream.StreamSupport;

@RequiredArgsConstructor
@Component
public class UserDaoAdapter implements UserDAO {
    private final UserRepository userRepository;

    @Override
    public Optional<User> findUserById(String id) {
        return userRepository.findById(id).map(this::toDomain);
    }

    @Override
    public Optional<User> findUserByEmail(String email) {
        return userRepository.findByEmail(email).map(this::toDomain);
    }

    @Override
    public List<User> findAllUsers() {
        return StreamSupport.stream(userRepository.findAll().spliterator(), false)
                .map(this::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public void saveUser(NewUserDto user) {
        UserEntity entity = toEntity(user);
        userRepository.save(entity);
    }

    @Override
    public void updateUser(String id, User user) {
        User updatedUser = new User(
                id,
                user.name(),
                user.phoneNumber(),
                user.email(),
                user.password()
        );

        UserEntity entity = toEntity(updatedUser);
        userRepository.save(entity);
    }

    @Override
    public void deleteUser(String id) {
        userRepository.deleteById(id);
    }

    private User toDomain(UserEntity entity) {
        return new User(
                entity.getId(),
                entity.getName(),
                entity.getPhoneNumber(),
                entity.getEmail(),
                entity.getPassword()
        );
    }

    private UserEntity toEntity(NewUserDto dto) {
        return new UserEntity(dto.id(), dto.name(), dto.phoneNumber(), dto.email(), dto.password());
    }

    private UserEntity toEntity(User user) {
        return new UserEntity(user.id(), user.name(), user.phoneNumber(), user.email(), user.password());
    }
}
