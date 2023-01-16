package snhu.it634.q1657.model;

/*
Colby Lithyouvong
IT-634-Q1657 Distributed App Development 22TW1
Final Project Part I Submission: Web Application With Annotated Code
*/

//The search class represents the data being captured on the search screen. 
//this is being sent to the available flights screen.
public class Search {
	//The origin airport
	private String OriginAirport;
	
	//the destination airport
	private String DestinationAirport;
	
	//the switch of either round trip or one way
	private String RoundTripOrOneWay;
	
	//the date leaving on
	private String LeavingOn;
	
	//the return date
	private String ReturningOn;
	
	//number of passengers
	private String AdultPassengers;
	
	//number of passengers
	private String ChildrenPassengers;

	public Search() {
	}

	public String getOriginAirport() {
		return OriginAirport;
	}

	public void setOriginAirport(String originAirport) {
		OriginAirport = originAirport;
	}

	public String getDestinationAirport() {
		return DestinationAirport;
	}

	public void setDestinationAirport(String destinationAirport) {
		DestinationAirport = destinationAirport;
	}

	public String getRoundTripOrOneWay() {
		return RoundTripOrOneWay;
	}

	public void setRoundTripOrOneWay(String roundTripOrOneWay) {
		RoundTripOrOneWay = roundTripOrOneWay;
	}

	public String getLeavingOn() {
		return LeavingOn;
	}

	public void setLeavingOn(String leavingOn) {
		LeavingOn = leavingOn;
	}

	public String getReturningOn() {
		return ReturningOn;
	}

	public void setReturningOn(String returningOn) {
		ReturningOn = returningOn;
	}

	public String getAdultPassengers() {
		return AdultPassengers;
	}

	public void setAdultPassengers(String adultPassengers) {
		AdultPassengers = adultPassengers;
	}

	public String getChildrenPassengers() {
		return ChildrenPassengers;
	}

	public void setChildrenPassengers(String childrenPassengers) {
		ChildrenPassengers = childrenPassengers;
	}
}
