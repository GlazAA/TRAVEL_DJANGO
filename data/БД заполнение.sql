Порядок заполнения таблиц:

Countries
Cities
Airlines
Insurance
Organizations
Hotels
Flights
Managers
Clients
ClientCities
Tours
PaymentMethods
PaymentStatuses
Contracts
Payments



INSERT INTO Countries (name_country) VALUES
('Россия'),
('Турция'),
('Египет');
2. Cities:

INSERT INTO Cities (name_city, countries_id) VALUES
('Москва', (SELECT id FROM Countries WHERE name_country = 'Россия')),
('Анталия', (SELECT id FROM Countries WHERE name_country = 'Турция')),
('Хургада', (SELECT id FROM Countries WHERE name_country = 'Египет'));
3. Airlines:

INSERT INTO Airlines (name_airline) VALUES
('Aeroflot'),
('Turkish Airlines'),
('EgyptAir');
4. Insurance:

INSERT INTO Insurance (insurance_type) VALUES
(1),
(0);
5. Organizations:

INSERT INTO Organizations (name_organization) VALUES
('TripAdvisor'),
('Local Guides');
6. Hotels:

INSERT INTO Hotels (name_hotel, child_menu, have_nanny, child_program, cities_id, hotel_address, geo_coordinates) VALUES
('Marriott Moscow', 1, 1, 1, (SELECT id FROM Cities WHERE name_city = 'Москва'), '123 Main St, Moscow', '55.7558, 37.6173'),
('Rixos Premium Belek', 1, 0, 1, (SELECT id FROM Cities WHERE name_city = 'Анталия'), 'Belek, Antalya', '36.7365, 30.7227'),
('Steigenberger Aqua Magic', 1, 1, 1, (SELECT id FROM Cities WHERE name_city = 'Хургада'), 'Hurghada, Egypt', '27.2423, 33.8204');
7. Flights:

INSERT INTO Flights (airlines_id, flight_number, departure_time, arrival_time) VALUES
((SELECT id FROM Airlines WHERE name_airline = 'Aeroflot'), 'SU123', '2024-03-15 10:00:00', '2024-03-15 12:00:00'),
((SELECT id FROM Airlines WHERE name_airline = 'Turkish Airlines'), 'TK456', '2024-03-15 14:00:00', '2024-03-15 16:00:00'),
((SELECT id FROM Airlines WHERE name_airline = 'EgyptAir'), 'MS789', '2024-03-15 18:00:00', '2024-03-15 20:00:00');
8. Managers:

INSERT INTO Managers (first_name, last_name, phone, email) VALUES
('Иван', 'Иванов', '+79123456789', 'ivan.ivanov@example.com'),
('Петр', 'Петров', '+79999999999', 'petr.petrov@example.com');
9. Clients:

INSERT INTO Clients (first_name, last_name, patronymic, phone, email, passport_number) VALUES
('Анна', 'Сидорова', 'Петровна', '+79001112222', 'anna.sidorova@example.com', '1234567890'),
('Мария', 'Смирнова', 'Ивановна', '+79012345678', 'maria.smirnova@example.com', '9876543210');
10. ClientCities:

INSERT INTO ClientCities (name_client_city, clients_id) VALUES
('Нижний Новгород', (SELECT id FROM Clients WHERE first_name = 'Анна')),
('Санкт-Петербург', (SELECT id FROM Clients WHERE first_name = 'Мария'));
11. Tours:

INSERT INTO Tours (name_tour, insurance_id, flights_id, cities_id, hotels_id, mark_for_deletion) VALUES
('Тур в Москву', (SELECT id FROM Insurance WHERE insurance_type = 1), (SELECT id FROM Flights WHERE flight_number = 'SU123'), (SELECT id FROM Cities WHERE name_city = 'Москва'), (SELECT id FROM Hotels WHERE name_hotel = 'Marriott Moscow'), 0),
('Тур в Анталию', (SELECT id FROM Insurance WHERE insurance_type = 1), (SELECT id FROM Flights WHERE flight_number = 'TK456'), (SELECT id FROM Cities WHERE name_city = 'Анталия'), (SELECT id FROM Hotels WHERE name_hotel = 'Rixos Premium Belek'), 0),
('Тур в Хургаду', (SELECT id FROM Insurance WHERE insurance_type = 0), (SELECT id FROM Flights WHERE flight_number = 'MS789'), (SELECT id FROM Cities WHERE name_city = 'Хургада'), (SELECT id FROM Hotels WHERE name_hotel = 'Steigenberger Aqua Magic'), 0);
12. PaymentMethods:

INSERT INTO PaymentMethods (method_name) VALUES
('наличные'),
('карта'),
('счет'),
('рассрочка');
13. PaymentStatuses:

INSERT INTO PaymentStatuses (status_name) VALUES
('оплачено'),
('не оплачено');
14. Contracts:

INSERT INTO Contracts (contract_number, clients_id, managers_id, tours_id) VALUES
('123456789', (SELECT id FROM Clients WHERE first_name = 'Анна'), (SELECT id FROM Managers WHERE first_name = 'Иван'), (SELECT id FROM Tours WHERE name_tour = 'Тур в Москву')),
('987654321', (SELECT id FROM Clients WHERE first_name = 'Мария'), (SELECT id FROM Managers WHERE first_name = 'Петр'), (SELECT id FROM Tours WHERE name_tour = 'Тур в Анталию'));
15. Payments:

INSERT INTO Payments (contracts_id, payment_date, amount, status_id, payment_method_id) VALUES
((SELECT id FROM Contracts WHERE contract_number = '123456789'), '2024-03-10', 1000.00, (SELECT id FROM PaymentStatuses WHERE status_name = 'оплачено'), (SELECT id FROM PaymentMethods WHERE method_name = 'карта')),
((SELECT id FROM Contracts WHERE contract_number = '987654321'), '2024-03-12', 1500.00, (SELECT id FROM PaymentStatuses WHERE status_name = 'оплачено'), (SELECT id FROM PaymentMethods WHERE method_name = 'счет'));
