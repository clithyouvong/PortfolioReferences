package snhu.it634.q1657.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

/*
Colby Lithyouvong
IT-634-Q1657 Distributed App Development 22TW1
Final Project Part I Submission: Web Application With Annotated Code
*/

@Controller
public class LogoutController {
    @GetMapping("/logout")
    public String logout(HttpServletRequest request, Model model) {
        request.getSession().invalidate();       
        return "redirect:/";
    }
}
