package snhu.it634.q1657.controller;

import javax.crypto.SecretKey;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.fasterxml.jackson.databind.ObjectMapper;

import snhu.it634.q1657.model.Login;
import snhu.it634.q1657.model.Search;
import snhu.it634.q1657.service.AirportService;
import snhu.it634.q1657.service.EncryptionService;

/*
Colby Lithyouvong
IT-634-Q1657 Distributed App Development 22TW1
Final Project Part I Submission: Web Application With Annotated Code
*/

@Controller
public class HomeController {
	//dependency injection of the airport class via service
	@Autowired
	private AirportService airportService;
	
	//This is the home page. we need to bring in the list of airports
	@GetMapping("/")
	public String index(HttpServletRequest request, Model model) {
		model.addAttribute("listAirports", airportService.GetAllAirports());
		
		//Session: Search
        try {
            //grab session values
            String obj = (String) request.getSession().getAttribute("searchValues");

            //map values from json
            ObjectMapper mapper = new ObjectMapper();  
            Search searchObj = mapper.readValue(obj, Search.class);
            
            //send to view
            model.addAttribute("Search", searchObj);
            
        }catch(Exception e) {
            model.addAttribute("Search", new Search());
        }
        

        //Session: Login Authorized
        try {
            //grab session values
            String obj = (String) request.getSession().getAttribute("loginAuthorized");

            //map values from json
            ObjectMapper mapper = new ObjectMapper();  
            Login loginObj = mapper.readValue(obj, Login.class);
            
            //start encryption service
            EncryptionService es = new EncryptionService();
            
            //get Secret key
            String k = loginObj.getKey();
            SecretKey key = es.convertStringToSecretKeyto(k);
            
            //reassign just what we need to the UI
            loginObj.setFirstName(es.decrypt(loginObj.getFirstName(), key));
            
            //send to view
            model.addAttribute("loginAuthorized", loginObj);
            
        }catch(Exception e) {
            //do nothing...
        }
		 
		
		return "index";
	}
	
}
