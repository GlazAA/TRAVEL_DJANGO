CREATE TABLE Insurance (
    id INT IDENTITY(1, 1) PRIMARY KEY,
    insurance_type BIT NOT NULL,
    CONSTRAINT CK_InsuranceType CHECK (insurance_type IN (0, 1))
);

CREATE TABLE Airlines (
    id INT IDENTITY(1, 1) PRIMARY KEY,
    name_airline NVARCHAR(100) NOT NULL
);

CREATE TABLE Flights (
    id INT IDENTITY(1, 1) PRIMARY KEY,
    airlines_id INT NOT NULL,
    flight_number NVARCHAR(100) NOT NULL,
    departure_time DATETIME NOT NULL,
    arrival_time DATETIME NOT NULL,
    FOREIGN KEY (airlines_id) REFERENCES Airlines(id),
    CHECK (arrival_time > departure_time)
);

CREATE TABLE Countries (
    id INT IDENTITY(1, 1) PRIMARY KEY,
    name_country NVARCHAR(100) NOT NULL
);

CREATE TABLE Cities (
    id INT IDENTITY(1, 1) PRIMARY KEY,
    name_city NVARCHAR(100) NOT NULL,
    countries_id INT NOT NULL,
    FOREIGN KEY (countries_id) REFERENCES Countries(id)
);

CREATE TABLE Hotels (
    id INT IDENTITY(1, 1) PRIMARY KEY,
    name_hotel NVARCHAR(50) NOT NULL,
    child_menu BIT NOT NULL DEFAULT 0,
    have_nanny BIT NOT NULL DEFAULT 0,
    child_program BIT NOT NULL DEFAULT 0,
    cities_id INT NOT NULL,
    address NVARCHAR(255) NOT NULL,
    geo_coordinates NVARCHAR(30),
    FOREIGN KEY (cities_id) REFERENCES Cities(id)
);

CREATE TABLE Organizations (
    id INT IDENTITY(1, 1) PRIMARY KEY,
    name_organization NVARCHAR(255) NOT NULL
);

CREATE TABLE Excursions (
    id INT IDENTITY(1, 1) PRIMARY KEY,
    name_excursion NVARCHAR(150) NOT NULL,
    night_transfer BIT NOT NULL DEFAULT 0,
    danger_level BIT NOT NULL DEFAULT 0,
    child_friendly BIT NOT NULL DEFAULT 0,
    duration INT NOT NULL,
    cities_id INT NOT NULL,
    organizations_id INT NOT NULL,
    FOREIGN KEY (cities_id) REFERENCES Cities(id),
    FOREIGN KEY (organizations_id) REFERENCES Organizations(id)
);

CREATE TABLE Managers (
    id INT IDENTITY(1, 1) PRIMARY KEY,
    first_name NVARCHAR(50) NOT NULL,
    last_name NVARCHAR(50) NOT NULL,
    phone NVARCHAR(20) NOT NULL,
    email NVARCHAR(50) NOT NULL,
    CHECK (email LIKE '%@%.%')
);

CREATE TABLE Clients (
    id INT IDENTITY(1, 1) PRIMARY KEY,
    first_name NVARCHAR(50) NOT NULL,
    last_name NVARCHAR(50) NOT NULL,
    patronymic NVARCHAR(255),
    phone NVARCHAR(20) NOT NULL,
    email NVARCHAR(50) NOT NULL,
    passport_number NVARCHAR(50) NOT NULL,
    mark_for_deletion BIT NOT NULL DEFAULT 0,
    inactive_client BIT NOT NULL DEFAULT 0,
    CHECK (email LIKE '%@%.%')
);

CREATE TABLE Tours (
    id INT IDENTITY(1, 1) PRIMARY KEY,
    name_tour NVARCHAR(150) NOT NULL,
    insurance_id INT NOT NULL,
    flights_id INT NOT NULL,
    cities_id INT NOT NULL,
    hotels_id INT NOT NULL,
    mark_for_deletion BIT NOT NULL DEFAULT 0,
    FOREIGN KEY (flights_id) REFERENCES Flights(id),
    FOREIGN KEY (cities_id) REFERENCES Cities(id),
    FOREIGN KEY (hotels_id) REFERENCES Hotels(id)
);

CREATE TABLE ClientCities (
    id INT IDENTITY(1, 1) PRIMARY KEY,
    name_client_city NVARCHAR(255) NOT NULL,
	
);

CREATE TABLE Contracts (
    id INT IDENTITY(1, 1) PRIMARY KEY,
    contract_number NVARCHAR(9) UNIQUE NOT NULL,
    clients_id INT NOT NULL,
    managers_id INT NOT NULL,
    tours_id INT NOT NULL,
    FOREIGN KEY (clients_id) REFERENCES Clients(id),
    FOREIGN KEY (managers_id) REFERENCES Managers(id),
    FOREIGN KEY (tours_id) REFERENCES Tours(id)
);

CREATE TABLE Payments (
    id INT IDENTITY(1, 1) PRIMARY KEY,
    contracts_id INT NOT NULL,
    payment_type INT NOT NULL,
    CONSTRAINT CK_PaymentType CHECK (payment_type IN (1, 2, 3, 4)),
    payment_in_parts BIT NOT NULL DEFAULT 0,
    account_number NVARCHAR(20),
    amount_all DECIMAL(18, 2) NOT NULL,
    amount DECIMAL(18, 2) NOT NULL DEFAULT 0,
    amount_status NVARCHAR(20),
    CONSTRAINT CK_PaymentStatus CHECK (amount_status IN ('оплачено', 'не оплачено')),
    FOREIGN KEY (contracts_id) REFERENCES Contracts(id)
);




ALTER TABLE Excursions
ADD tours_id INT;

ALTER TABLE Excursions
ADD CONSTRAINT FK_Excursions_Tours FOREIGN KEY (tours_id) REFERENCES Tours(id);

ALTER TABLE ClientCities
ADD clients_id INT;

ALTER TABLE ClientCities
ADD CONSTRAINT FK_Cities_Client FOREIGN KEY (clients_id) REFERENCES Clients(id);
