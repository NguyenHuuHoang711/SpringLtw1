package com.example.demo.modules.registration.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class WebController {

    @GetMapping("/")
    public String index() {
        return "index";
    }

    @GetMapping("/student")
    public String studentDashboard() {
        return "student";
    }

    @GetMapping("/student/requests")
    public String studentRequestsPage() {
        return "student-requests";
    }

    @GetMapping("/student/focus-courses")
    public String studentFocusCoursesPage() {
        return "student-focus-courses";
    }

    @GetMapping("/student/all-courses")
    public String studentAllCoursesPage() {
        return "student-all-courses";
    }

    @GetMapping("/admin")
    public String adminDashboard() {
        return "admin";
    }

    @GetMapping("/admin/requests")
    public String adminRequestsPage() {
        return "admin-requests";
    }
}
