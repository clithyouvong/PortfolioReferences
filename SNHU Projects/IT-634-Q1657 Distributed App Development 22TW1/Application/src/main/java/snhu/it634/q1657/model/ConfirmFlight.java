package snhu.it634.q1657.model;

/*
Colby Lithyouvong
IT-634-Q1657 Distributed App Development 22TW1
Final Project Part I Submission: Web Application With Annotated Code
*/

public class ConfirmFlight {
	private String originAirport;
	private String destinationAirport;
	private String roundTripOrOneWay;
	private String leavingOn;
	private String returningOn;
	private String adultPassengers;
	private String childrenPassengers;
	private String selectedFlight;

	public ConfirmFlight() {
	}

	public String getOriginAirport() {
		return originAirport;
	}

	public void setOriginAirport(String originAirport) {
		this.originAirport = originAirport;
	}

	public String getDestinationAirport() {
		return destinationAirport;
	}

	public void setDestinationAirport(String destinationAirport) {
		this.destinationAirport = destinationAirport;
	}

	public String getRoundTripOrOneWay() {
		return roundTripOrOneWay;
	}

	public void setRoundTripOrOneWay(String roundTripOrOneWay) {
		this.roundTripOrOneWay = roundTripOrOneWay;
	}

	public String getLeavingOn() {
		return leavingOn;
	}

	public void setLeavingOn(String leavingOn) {
		this.leavingOn = leavingOn;
	}

	public String getReturningOn() {
		return returningOn;
	}

	public void setReturningOn(String returningOn) {
		this.returningOn = returningOn;
	}

	public String getAdultPassengers() {
		return adultPassengers;
	}

	public void setAdultPassengers(String adultPassengers) {
		this.adultPassengers = adultPassengers;
	}

	public String getChildrenPassengers() {
		return childrenPassengers;
	}

	public void setChildrenPassengers(String childrenPassengers) {
		this.childrenPassengers = childrenPassengers;
	}

	public String getSelectedFlight() {
		return selectedFlight;
	}

	public void setSelectedFlight(String selectedFlight) {
		this.selectedFlight = selectedFlight;
	}
	
	
}
