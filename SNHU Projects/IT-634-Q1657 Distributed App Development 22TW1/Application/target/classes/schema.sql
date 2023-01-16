Create Table IF NOT EXISTS dbo.Airport(
	ID int not null auto_increment primary key,
    Code varchar(5) not null,
    Code2 varchar(5) not null,
    Name varchar(100) not null,
    Country varchar(100) not null
);

Create Table If Not Exists dbo.Flight (
	ID int not null auto_increment primary key,
    OriginAirportCode varchar(10) not null,
    DestinationAirportCode varchar(10) not null,
    DepartureTime varchar(10) not null,
    ArrivalTime varchar(10) not null,
    EconomyPrice varchar(10) not null,
    PremiumEconomyPrice varchar(10) not null,
    BusinessClassPrice varchar(10) not null
);
