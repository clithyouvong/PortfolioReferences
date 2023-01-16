package snhu.it634.q1657.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import snhu.it634.q1657.model.Flight;
import snhu.it634.q1657.repository.FlightRepository;

//implements the flight repository
@Service
public class FlightServiceImpl implements FlightService{

	@Autowired
	private FlightRepository flightRepository;
	
	@Override
	public List<Flight> GetAllFlights() {
		return flightRepository.findAll();
	}

	@Override
	public List<Flight> GetFlightsByAirportCode(String originAirportCode, String destinationAirportCode) {
		return flightRepository.findByOriginAirportCodeAndDestinationAirportCode(originAirportCode, destinationAirportCode);
	}
	
	@Override
	public List<Flight> GetFlightsById(int id) {
		return flightRepository.findById(id);
	}
	
}
