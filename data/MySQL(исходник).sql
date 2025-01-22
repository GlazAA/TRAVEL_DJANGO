drop database if exists TourNow;


create database TourNow;
use TourNow;



CREATE TABLE Insurance (
    id INT AUTO_INCREMENT PRIMARY KEY,
    insurance_type TINYINT(1) NOT NULL,
    CONSTRAINT CK_InsuranceType CHECK (insurance_type IN (0, 1))
);

CREATE TABLE Airlines (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name_airline VARCHAR(100) NOT NULL
);

CREATE TABLE Flights (
    id INT AUTO_INCREMENT PRIMARY KEY,
    airlines_id INT NOT NULL,
    flight_number VARCHAR(100) NOT NULL,
    departure_time DATETIME NOT NULL,
    arrival_time DATETIME NOT NULL,
    FOREIGN KEY (airlines_id) REFERENCES Airlines(id),
    CHECK (arrival_time > departure_time)
);

CREATE TABLE Countries (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name_country VARCHAR(100) NOT NULL
);

CREATE TABLE Cities (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name_city VARCHAR(100) NOT NULL,
    countries_id INT NOT NULL,
    FOREIGN KEY (countries_id) REFERENCES Countries(id)
);

CREATE TABLE Hotels (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name_hotel VARCHAR(50) NOT NULL,
    child_menu TINYINT(1) NOT NULL DEFAULT 0,
    have_nanny TINYINT(1) NOT NULL DEFAULT 0,
    child_program TINYINT(1) NOT NULL DEFAULT 0,
    cities_id INT NOT NULL,
    hotel_address VARCHAR(255) NOT NULL,
    geo_coordinates VARCHAR(30),
    FOREIGN KEY (cities_id) REFERENCES Cities(id)
);

CREATE TABLE Organizations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name_organization VARCHAR(255) NOT NULL
);

CREATE TABLE Excursions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name_excursion VARCHAR(150) NOT NULL,
    night_transfer TINYINT(1) NOT NULL DEFAULT 0,
    danger_level TINYINT(1) NOT NULL DEFAULT 0,
    child_friendly TINYINT(1) NOT NULL DEFAULT 0,
    duration INT NOT NULL,
    cities_id INT NOT NULL,
    organizations_id INT NOT NULL,
    FOREIGN KEY (cities_id) REFERENCES Cities(id),
    FOREIGN KEY (organizations_id) REFERENCES Organizations(id)
);

CREATE TABLE Managers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(50) NOT NULL,
    CHECK (email LIKE '%@%.%')
);

CREATE TABLE Clients (
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    patronymic VARCHAR(255),
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(50) NOT NULL,
    passport_number VARCHAR(50) NOT NULL,
    mark_for_deletion TINYINT(1) NOT NULL DEFAULT 0,
    not_active TINYINT(1) NOT NULL DEFAULT 0,
    CHECK (email LIKE '%@%.%')
);

CREATE TABLE Tours (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name_tour VARCHAR(150) NOT NULL,
    insurance_id INT NOT NULL,
    flights_id INT NOT NULL,
    cities_id INT NOT NULL,
    hotels_id INT NOT NULL,
    mark_for_deletion TINYINT(1) NOT NULL DEFAULT 0,
    FOREIGN KEY (flights_id) REFERENCES Flights(id),
    FOREIGN KEY (cities_id) REFERENCES Cities(id),
    FOREIGN KEY (hotels_id) REFERENCES Hotels(id)
);

CREATE TABLE ClientCities (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name_client_city VARCHAR(255) NOT NULL
);

CREATE TABLE Contracts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    contract_number VARCHAR(9) UNIQUE NOT NULL,
    clients_id INT NOT NULL,
    managers_id INT NOT NULL,
    tours_id INT NOT NULL,
    FOREIGN KEY (clients_id) REFERENCES Clients(id),
    FOREIGN KEY (managers_id) REFERENCES Managers(id),
    FOREIGN KEY (tours_id) REFERENCES Tours(id)
);


CREATE TABLE Payments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    contracts_id INT NOT NULL,
    payment_type ENUM('наличные', 'карта', 'счет', 'рассрочка') NOT NULL,
    payment_in_parts TINYINT(1) NOT NULL DEFAULT 0,
    account_number VARCHAR(20),
    amount_all DECIMAL(18, 2) NOT NULL,
    amount DECIMAL(18, 2) NOT NULL DEFAULT 0,
    amount_status ENUM('оплачено', 'не оплачено') NOT NULL,
    FOREIGN KEY (contracts_id) REFERENCES Contracts(id)
);


ALTER TABLE Excursions
ADD COLUMN tours_id INT,
ADD CONSTRAINT FK_Excursions_Tours FOREIGN KEY (tours_id) REFERENCES Tours(id);

ALTER TABLE ClientCities
ADD COLUMN clients_id INT,
ADD CONSTRAINT FK_Cities_Client FOREIGN KEY (clients_id) REFERENCES Clients(id);
