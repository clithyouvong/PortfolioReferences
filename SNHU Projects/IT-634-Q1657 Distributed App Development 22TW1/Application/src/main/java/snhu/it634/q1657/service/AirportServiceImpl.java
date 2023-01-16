package snhu.it634.q1657.service;

/*
Colby Lithyouvong
IT-634-Q1657 Distributed App Development 22TW1
Final Project Part I Submission: Web Application With Annotated Code
*/

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import snhu.it634.q1657.model.Airport;
import snhu.it634.q1657.repository.AirportRepository;

//implements the Airport repository
@Service
public class AirportServiceImpl implements AirportService{

	@Autowired
	private AirportRepository airportRepository;
	
	@Override
	public List<Airport> GetAllAirports() {
		return airportRepository.findAll();
	}

}
