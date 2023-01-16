package snhu.it634.q1657.controller;

import java.text.DateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import javax.crypto.SecretKey;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;

/*
Colby Lithyouvong
IT-634-Q1657 Distributed App Development 22TW1
Final Project Part I Submission: Web Application With Annotated Code
*/

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;

import com.fasterxml.jackson.databind.ObjectMapper;

import snhu.it634.q1657.model.Flight;
import snhu.it634.q1657.model.Login;
import snhu.it634.q1657.model.Search;
import snhu.it634.q1657.model.SelectedFlight;
import snhu.it634.q1657.service.EncryptionService;
import snhu.it634.q1657.service.FlightService;
import snhu.it634.q1657.service.RandomStringService;

@Controller
public class ConfirmFlightController {
    //dependency injection of the flight data service
    @Autowired
    private FlightService flightService;
    
	@PostMapping("/confirmFlight")
	public String postIndex(
	        HttpServletRequest request,
	        SelectedFlight selectedFlight,
			Model model) {
        
        //Session: Login Authorized
	    // used to grab personal information that was called upon.
        try {
            //grab session values
            String obj = (String) request.getSession().getAttribute("loginAuthorized");

            //map values from json
            ObjectMapper mapper = new ObjectMapper();  
            Login l = mapper.readValue(obj, Login.class);

            //because the values in the sessio are 'encrypted' 
            //we want to decrypt them for this 'view' only
            EncryptionService es = new EncryptionService();
            SecretKey key = es.convertStringToSecretKeyto(l.getKey());
            l.setFirstName(es.decrypt(l.getFirstName(), key));
            l.setMiddleName(es.decrypt(l.getMiddleName(), key));
            l.setLastName(es.decrypt(l.getLastName(), key));
            l.setDateOfBirth(es.decrypt(l.getDateOfBirth(), key));
            l.setGender(es.decrypt(l.getGender(), key));
            l.setPhone(es.decrypt(l.getPhone(), key));
            l.setEmail(es.decrypt(l.getEmail(), key));
            
            //send to view
            model.addAttribute("loginAuthorized", l);
            
        }catch(Exception e) {
            return "redirect:/login/error2";
        }

        //Session: Search
        //Used to grab the Date Depart and Arrive
        // Adult / Child count
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
        

        // used to grab the specific flight that was chosen. 
        model.addAttribute("selectedFlight", selectedFlight);

        // used to grab the current flight
        String[] selectedFlightSplit = selectedFlight.getSelectedFlight().split(":");
        List<Flight> currentFlight = flightService.GetFlightsById(Integer.parseInt(selectedFlightSplit[0]));
        
        model.addAttribute("currentFlight", currentFlight.get(0));
        
        // this outputs what the user has selected, 
        // the ticket price as well as the selected class,
        // i.e. economy, premium economy, or business
        String currentClass = selectedFlightSplit[1];
        String currentClassPrice = "";
        
        //switches the current class price to the price in the flight row
        //based on the pairing coming in from the available flight selector. 
        switch(currentClass) {
            case "Economy": 
                currentClassPrice = currentFlight.get(0).getEconomyPrice();
                break;
            case "PremiumEconomy": 
                currentClassPrice = currentFlight.get(0).getPremiumEconomyPrice();
                break;
            case "Business": 
                currentClassPrice = currentFlight.get(0).getBusinessClassPrice();
                break;
        }
        
        model.addAttribute("currentClass", currentClass);
        model.addAttribute("currentClassPrice", currentClassPrice);
        
        
        
        // used to generate the current date and time for the Dear Column
        Locale locale = new Locale("en", "US");
        DateFormat dateFormat = DateFormat.getDateInstance(DateFormat.DEFAULT, locale);
        String date = dateFormat.format(new Date());
        model.addAttribute("currentDate", date);
        
        // used to generate the specific random string for confirmation
        RandomStringService rss = new RandomStringService();
        model.addAttribute("confirmationCode", rss.nextString());
		
		return "confirmFlight";
	}
}
