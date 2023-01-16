package snhu.it634.q1657.service;

/*
Colby Lithyouvong
IT-634-Q1657 Distributed App Development 22TW1
Final Project Part I Submission: Web Application With Annotated Code
*/

import java.util.List;
import snhu.it634.q1657.model.Flight;

public interface FlightService {
	List<Flight> GetAllFlights();
	
    List<Flight> GetFlightsByAirportCode(String originAirportCode, String destinationAirportCode);
    
    List<Flight> GetFlightsById(int id);
}
