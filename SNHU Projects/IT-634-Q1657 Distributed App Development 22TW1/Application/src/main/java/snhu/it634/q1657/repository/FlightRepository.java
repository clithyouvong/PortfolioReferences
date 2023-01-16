 package snhu.it634.q1657.repository;

import java.util.List;

/*
Colby Lithyouvong
IT-634-Q1657 Distributed App Development 22TW1
Final Project Part I Submission: Web Application With Annotated Code
*/
 
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import snhu.it634.q1657.model.Flight;

@Repository
public interface FlightRepository extends JpaRepository<Flight, Integer> {
	List<Flight> findByOriginAirportCodeAndDestinationAirportCode(String originAirportCode, String destinationAirportCode);
	List<Flight> findById(int id);
}