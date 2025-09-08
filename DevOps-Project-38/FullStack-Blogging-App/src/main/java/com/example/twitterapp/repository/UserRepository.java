package com.example.twitterapp.repository;

import com.example.twitterapp.model.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<User, Long> {
    User findByUsername(String username);

    User save(User userDto);
}
