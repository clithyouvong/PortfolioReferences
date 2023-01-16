package snhu.it634.q1657.controller;

import javax.servlet.http.HttpServletRequest;

/*
Colby Lithyouvong
IT-634-Q1657 Distributed App Development 22TW1
Final Project Part I Submission: Web Application With Annotated Code
*/

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;

import com.fasterxml.jackson.databind.ObjectMapper;

import snhu.it634.q1657.model.Search;
import snhu.it634.q1657.service.FlightService;
import snhu.it634.q1657.model.SelectedFlight;

@Controller
public class AvailableFlightsController {
	//dependency injection of the flight data service
	@Autowired
	private FlightService flightService;
	

	//the method that initializes the available flights
	@PostMapping("/availableFlights")
	public String postIndex(HttpServletRequest request, Search search, Model model) {
		model.addAttribute("search", search);
		model.addAttribute("SelectedFlight", new SelectedFlight());
		model.addAttribute("listFlights", flightService.GetFlightsByAirportCode(search.getOriginAirport(), search.getDestinationAirport()));
		
		//this attempts to repopulate the search values based on a "back" or "previous" command
		//where the user wants to return to the previous screen
		//this will attempt to reset those values for quicker re-searching
        try {
            ObjectMapper mapper = new ObjectMapper();  
            String searchSerialized = mapper.writeValueAsString(search);

            request.getSession().setAttribute("searchValues", searchSerialized);
        }catch(Exception e) {
            System.out.println(e.getMessage());
        }
		
		return "availableFlights";
	}
}
