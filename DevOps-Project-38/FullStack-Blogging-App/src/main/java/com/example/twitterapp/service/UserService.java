package com.example.twitterapp.service;

import com.example.twitterapp.model.User;

public interface UserService {
    User findByUsername(String username);

    User save(User userDto);

}