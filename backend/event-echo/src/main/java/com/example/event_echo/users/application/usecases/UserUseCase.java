package com.example.event_echo.users.application.usecases;

import com.example.event_echo.users.application.dao.UserDAO;
import com.example.event_echo.users.application.dto.NewUserDto;
import com.example.event_echo.users.domain.User;
import com.example.event_echo.users.infrastructure.exceptions.UserAlreadyExistsException;
import com.example.event_echo.users.infrastructure.exceptions.UserNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@RequiredArgsConstructor
@Service
public class UserUseCase {
    private final UserDAO userDAO;

    public String saveUser(NewUserDto newUserDto) throws UserAlreadyExistsException {
        boolean isPresent = userDAO.findUserByEmail(newUserDto.email()).isPresent();
        if (isPresent) throw new UserAlreadyExistsException("User already exists with this email");

        userDAO.saveUser(newUserDto);
        return "User saved successfully";
    }

    public List<User> getAllUsers() {
        return userDAO.findAllUsers();
    }

    public User getUserById(String id) {
        return userDAO.findUserById(id).orElseThrow(
                () -> new UserNotFoundException("User not found")
        );
    }

    public User authenticateUser(String email, String password) {
        User user = userDAO.findUserByEmail(email).orElseThrow(
                () -> new UserNotFoundException("User doesn't exist")
        );

        if (!user.password().equals(password)) {
            throw new UserNotFoundException("Incorrect password");
        }

        return user;
    }

    public String updateUser(String id, User user) throws UserNotFoundException {
        userDAO.findUserById(id).orElseThrow(
                () -> new UserNotFoundException("User not found")
        );

        userDAO.updateUser(id, user);
        return "User updated successfully";
    }

    public String deleteUser(String id) throws UserNotFoundException {
        User user = userDAO.findUserById(id).orElseThrow(
                () -> new UserNotFoundException("User not found")
        );

        userDAO.deleteUser(id);
        return "User deleted successfully";
    }
}
