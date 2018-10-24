package com.example.sweater.service;

import com.example.sweater.domain.Message;
import com.example.sweater.repos.MessageRepo;
import com.example.sweater.repos.UserRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class MessageService {
    @Autowired
    private MessageRepo messageRepo;


    public void deleteMessage(long id){
        messageRepo.deleteById(id);
    }

    public void updateMessage(Message message){
    messageRepo.save(message);
    }
}
