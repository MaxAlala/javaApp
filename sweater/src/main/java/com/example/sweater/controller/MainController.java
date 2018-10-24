package com.example.sweater.controller;

import com.example.sweater.domain.Message;
import com.example.sweater.domain.User;
import com.example.sweater.repos.MessageRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.validation.Valid;
import java.io.File;
import java.io.IOException;
import java.util.Map;
import java.util.UUID;


@Controller
public class MainController {
    @Autowired
    private MessageRepo messageRepo;

    @Value("${upload.path}")
    private String uploadPath;


    @GetMapping("/")
    public String greeting(Map<String, Object> model) {
        return "greeting";
    }

    @GetMapping("/main")
    public String main(@RequestParam(required = false, defaultValue = "") String filter, Model model) {
        Iterable<Message> messages = messageRepo.findAll();

        if (filter != null && !filter.isEmpty()) {

            messages = messageRepo.findByTag(filter);
        } else {
            messages = messageRepo.findAll();
        }

        model.addAttribute("messages", messages);
        model.addAttribute("filter", filter);
        return "main";
    }

    // request param = get info from form or URL param
    @PostMapping("/main")
    public String add(
            @RequestParam("file") MultipartFile file,
            @AuthenticationPrincipal User user,
            @Valid Message message,
            BindingResult bindingResult,
            Model model
    ) throws IOException {
        return getString(file, user, message, bindingResult, model);
    }


    @PostMapping("/maindelete")
    public String delete(
            @Valid Message message,
            Model model
    ) throws IOException {


        messageRepo.delete(message);

        Iterable<Message> messages = messageRepo.findAll();
        model.addAttribute("messages", messages);

        return "redirect:/main";
    }

    @PostMapping("/mainchange")
    public String update(
            @RequestParam("file") MultipartFile file,
            @AuthenticationPrincipal User user,
            @Valid Message message,
            BindingResult bindingResult,
            Model model
    ) throws IOException {


        System.out.println(message.getFilename());
        System.out.println(file.getOriginalFilename() + "HEYs");
        return getString(file, user, message, bindingResult, model);
    }

    private String getString(@RequestParam("file") MultipartFile file, @AuthenticationPrincipal User user, @Valid Message message, BindingResult bindingResult, Model model) throws IOException {
        message.setAuthor(user);


        if (bindingResult.hasErrors()) {
            Map<String, String> errorsMap = ControllerUtils.getErrors(bindingResult);
            model.mergeAttributes(errorsMap);
            model.addAttribute("message", message);
            System.out.println("/////////222");
        } else {


            if (file != null && !file.getOriginalFilename().isEmpty()) {
                File uploadDir = new File(uploadPath);

                if (!uploadDir.exists()) {
                    uploadDir.mkdir();
                }

                String uuidFile = UUID.randomUUID().toString();
                String resultFileName = uuidFile + "." + file.getOriginalFilename();

                file.transferTo(new File(uploadPath + "\\" + resultFileName));
                message.setFilename(resultFileName);
                System.out.println(resultFileName + "/////////");
            }
            System.out.println( "/////////333");
            model.addAttribute("message", null);
            System.out.println(message.getFilename());
            messageRepo.save(message);

        }
        Iterable<Message> messages = messageRepo.findAll();
        model.addAttribute("messages", messages);
        return "redirect:/main";
    }
}
