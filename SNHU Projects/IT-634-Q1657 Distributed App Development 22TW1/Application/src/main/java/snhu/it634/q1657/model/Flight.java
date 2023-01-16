package snhu.it634.q1657.model;

/*
Colby Lithyouvong
IT-634-Q1657 Distributed App Development 22TW1
Final Project Part I Submission: Web Application With Annotated Code
*/

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity	
@Table(name = "Flight", schema = "dbo")
public class Flight {
	//The ID of the Flight
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Id
	@Column(name = "ID")
	private int id;
	
	//The original airport
	@Column(name = "OriginAirportCode")
	private String originAirportCode;
	
	//the Destination Airport
	@Column(name = "DestinationAirportCode")
	private String destinationAirportCode;
	
	//The department time
	@Column(name = "DepartureTime")
	private String DepartureTime;
	
	//The Arrival Time
	@Column(name = "ArrivalTime")
	private String ArrivalTime;
	
	//The economy price
	@Column(name = "EconomyPrice")
	private String EconomyPrice;
	
	//The premium economy price
	@Column(name = "PremiumEconomyPrice")
	private String PremiumEconomyPrice;
	
	//the business class price
	@Column(name = "BusinessClassPrice")
	private String BusinessClassPrice;

	public Flight() {
	}

	public int getId() {
		return id;
	}

	public void setId(int i) {
		id = i;
	}

	public String getOriginAirportCode() {
		return originAirportCode;
	}

	public void setOriginAirportCode(String o) {
		originAirportCode = o;
	}

	public String getDestinationAirportCode() {
		return destinationAirportCode;
	}

	public void setDestinationAirportCode(String d) {
		destinationAirportCode = d;
	}

	public String getDepartureTime() {
		return DepartureTime;
	}

	public void setDepartureTime(String departureTime) {
		DepartureTime = departureTime;
	}

	public String getArrivalTime() {
		return ArrivalTime;
	}

	public void setArrivalTime(String arrivalTime) {
		ArrivalTime = arrivalTime;
	}

	public String getEconomyPrice() {
		return EconomyPrice;
	}

	public void setEconomyPrice(String economyPrice) {
		EconomyPrice = economyPrice;
	}

	public String getPremiumEconomyPrice() {
		return PremiumEconomyPrice;
	}

	public void setPremiumEconomyPrice(String premiumEconomyPrice) {
		PremiumEconomyPrice = premiumEconomyPrice;
	}

	public String getBusinessClassPrice() {
		return BusinessClassPrice;
	}

	public void setBusinessClassPrice(String businessClassPrice) {
		BusinessClassPrice = businessClassPrice;
	}
}
