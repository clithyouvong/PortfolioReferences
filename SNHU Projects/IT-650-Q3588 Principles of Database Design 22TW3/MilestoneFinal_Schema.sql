Create Table Company (
	CompanyID int not null IDENTITY(1,1),
	CompanyName varchar(100) not null,
	SysStartTime DATETIME2(0) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
	SysEndTime DATETIME2(0) GENERATED ALWAYS AS ROW END HIDDEN NOT NULL,
	PERIOD FOR SYSTEM_TIME (SysStartTime,SysEndTime),
	Constraint [PK_Company] primary key (CompanyID)
)WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.CompanyHistory));
Go

Create Table PricingType (
	PricingTypeID int not null IDENTITY(1,1),
	PricingType varchar(100) not null,
	SysStartTime DATETIME2(0) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
	SysEndTime DATETIME2(0) GENERATED ALWAYS AS ROW END HIDDEN NOT NULL,
	PERIOD FOR SYSTEM_TIME (SysStartTime,SysEndTime),
	Constraint [PK_PricingType] primary key (PricingTypeID)
)WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.PricingTypeHistory));
Go

Create Table License (
	LicenseID int not null IDENTITY(1,1),
	PricingTypeID int not null,
	LicenseName varchar(100) not null,
	StartDate date not null,
	EndDate date not null,
	Terms varchar(500) not null,
	Units int null Default 0,
	Pricing decimal(18,2) not null,
	SysStartTime DATETIME2(0) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
	SysEndTime DATETIME2(0) GENERATED ALWAYS AS ROW END HIDDEN NOT NULL,
	PERIOD FOR SYSTEM_TIME (SysStartTime,SysEndTime),
	Constraint [PK_License] primary key (LicenseID),
	Constraint [FK_License_PricingTypeID] foreign key (PricingTypeID) references dbo.PricingType(PricingTypeID),
	Constraint [CK_License_Pricing] check (Pricing >= 0)
)WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.LicenseHistory));
Go

Create Table Software (
	SoftwareID int not null IDENTITY(1,1),
	CompanyID int not null,
	LicenseID int not null,
	SoftwareName varchar(100) not null,
	SoftwareVersion varchar(50) not null,
	IsInstallableOnNetwork bit null default 0,
	IsInstallableOnClient bit null default 0,
	SysStartTime DATETIME2(0) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
	SysEndTime DATETIME2(0) GENERATED ALWAYS AS ROW END HIDDEN NOT NULL,
	PERIOD FOR SYSTEM_TIME (SysStartTime,SysEndTime),
	Constraint [PK_Software] primary key (SoftwareID),
	Constraint [FK_Software_CompanyID] foreign key (CompanyID) references dbo.Company(CompanyID),
	Constraint [FK_Software_LicenseID] foreign key (LicenseID) references dbo.License(LicenseID)
)WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.SoftwareHistory));
Go

Create Table [User] (
	UserID int not null IDENTITY(1,1),
	Username varchar(100) not null,
	SysStartTime DATETIME2(0) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
	SysEndTime DATETIME2(0) GENERATED ALWAYS AS ROW END HIDDEN NOT NULL,
	PERIOD FOR SYSTEM_TIME (SysStartTime,SysEndTime),
	Constraint [PK_User] primary key (UserID)
)WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.UserHistory));
Go

Create Table [Location] (
	LocationID int not null IDENTITY(1,1),
	[Location] varchar(100) not null,
	SysStartTime DATETIME2(0) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
	SysEndTime DATETIME2(0) GENERATED ALWAYS AS ROW END HIDDEN NOT NULL,
	PERIOD FOR SYSTEM_TIME (SysStartTime,SysEndTime),
	Constraint [PK_Location] primary key (LocationID)
)WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.LocationHistory));
Go

Create Table [RequestStatus] (
	RequestStatusID int not null IDENTITY(1,1),
	RequestStatus varchar(50) not null,
	SysStartTime DATETIME2(0) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
	SysEndTime DATETIME2(0) GENERATED ALWAYS AS ROW END HIDDEN NOT NULL,
	PERIOD FOR SYSTEM_TIME (SysStartTime,SysEndTime),
	Constraint [PK_RequestStatus] primary key (RequestStatusID)
)WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.RequestStatusHistory));
Go

Create Table [Request] (
	RequestID int not null IDENTITY(1,1),
	RequestStatusID int not null,
	UserID int not null,
	SoftwareID int not null,
	Request varchar(max) not null,
	Response varchar(max) not null,
	SysStartTime DATETIME2(0) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
	SysEndTime DATETIME2(0) GENERATED ALWAYS AS ROW END HIDDEN NOT NULL,
	PERIOD FOR SYSTEM_TIME (SysStartTime,SysEndTime),
	Constraint [PK_Request] primary key (RequestID),
	Constraint [FK_Request_UserID] foreign key (UserID) references dbo.[User](UserID),
	Constraint [FK_Request_SoftwareID] foreign key (SoftwareID) references dbo.Software(SoftwareID),
	Constraint [FK_Request_RequestStatusID] foreign key (RequestStatusID) references dbo.RequestStatus(RequestStatusID)
)WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.RequestHistory));
Go

Create Table [Installation] (
	InstallationID int not null IDENTITY(1,1),
	RequestID int not null,
	LocationID int not null,
	UserID int not null,
	SoftwareID int not null,
	DateInstalled datetime not null,
	DateRemoved datetime null,
	SysStartTime DATETIME2(0) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
	SysEndTime DATETIME2(0) GENERATED ALWAYS AS ROW END HIDDEN NOT NULL,
	PERIOD FOR SYSTEM_TIME (SysStartTime,SysEndTime),
	Constraint [PK_Installation] primary key (InstallationID),
	Constraint [FK_Installation_UserID] foreign key (UserID) references dbo.[User](UserID),
	Constraint [FK_Installation_SoftwareID] foreign key (SoftwareID) references dbo.Software(SoftwareID),
	Constraint [FK_Installation_RequestID] foreign key (RequestID) references dbo.Request(RequestID),
	Constraint [FK_Installation_LocationID] foreign key (LocationID) references dbo.[Location](LocationID),
)WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.InstallationHistory));
Go