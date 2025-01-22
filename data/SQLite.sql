CREATE TABLE Insurance (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    insurance_type INTEGER NOT NULL CHECK (insurance_type IN (0, 1))
);

CREATE TABLE Airlines (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name_airline TEXT NOT NULL
);

CREATE TABLE Flights (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    airlines_id INTEGER NOT NULL,
    flight_number TEXT NOT NULL,
    departure_time TEXT NOT NULL,
    arrival_time TEXT NOT NULL CHECK (arrival_time > departure_time)
);

CREATE TABLE Countries (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name_country TEXT NOT NULL
);

CREATE TABLE Cities (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name_city TEXT NOT NULL,
    countries_id INTEGER NOT NULL
);

CREATE TABLE Hotels (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name_hotel TEXT NOT NULL,
    child_menu INTEGER NOT NULL DEFAULT 0,
    have_nanny INTEGER NOT NULL DEFAULT 0,
    child_program INTEGER NOT NULL DEFAULT 0,
    cities_id INTEGER NOT NULL,
    hotel_address TEXT NOT NULL,
    geo_coordinates TEXT
);

CREATE TABLE Organizations (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name_organization TEXT NOT NULL
);

CREATE TABLE Excursions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name_excursion TEXT NOT NULL,
    night_transfer INTEGER NOT NULL DEFAULT 0,
    danger_level INTEGER NOT NULL DEFAULT 0,
    child_friendly INTEGER NOT NULL DEFAULT 0,
    duration INTEGER NOT NULL,
    cities_id INTEGER NOT NULL,
    organizations_id INTEGER NOT NULL,
    tours_id INTEGER
);

CREATE TABLE Managers (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    phone TEXT NOT NULL,
    email TEXT NOT NULL CHECK (email LIKE '%@%.%')
);

CREATE TABLE Clients (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    patronymic TEXT,
    phone TEXT NOT NULL,
    email TEXT NOT NULL CHECK (email LIKE '%@%.%'),
    passport_number TEXT NOT NULL,
    mark_for_deletion INTEGER NOT NULL DEFAULT 0,
    not_active INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE Tours (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name_tour TEXT NOT NULL,
    insurance_id INTEGER NOT NULL,
    flights_id INTEGER NOT NULL,
    cities_id INTEGER NOT NULL,
    hotels_id INTEGER NOT NULL,
    mark_for_deletion INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE ClientCities (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name_client_city TEXT NOT NULL,
    clients_id INTEGER
);

CREATE TABLE Contracts (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    contract_number TEXT UNIQUE NOT NULL,
    clients_id INTEGER NOT NULL,
    managers_id INTEGER NOT NULL,
    tours_id INTEGER NOT NULL
);

CREATE TABLE PaymentMethods (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    method_name TEXT UNIQUE NOT NULL
);

CREATE TABLE Payments (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    contracts_id INTEGER NOT NULL,
    payment_date TEXT NOT NULL,
    amount REAL NOT NULL,
    status_id INTEGER NOT NULL,
    payment_method_id INTEGER NOT NULL
);


CREATE TABLE PaymentStatuses (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    status_name TEXT UNIQUE NOT NULL
);



CREATE INDEX idx_countries_name ON Countries(name_country);

