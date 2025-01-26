BEGIN;
--
-- Create model Airlines
--
CREATE TABLE "bd_airlines" (
  "id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, 
  "name_airline" varchar(200) NOT NULL
);
--
-- Create model Clients
--
CREATE TABLE "bd_clients" (
  "id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, 
  "first_name" varchar(100) NOT NULL, 
  "last_name" varchar(100) NOT NULL, 
  "patronymic" varchar(100) NULL, 
  "phone" varchar(20) NOT NULL, 
  "email" varchar(254) NOT NULL, 
  "passport_number" varchar(50) NOT NULL, 
  "mark_for_deletion" bool NULL, 
  "not_active" bool NOT NULL DEFAULT 0
);
--
-- Create model Countries
--
CREATE TABLE "bd_countries" (
  "id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, 
  "name_country" varchar(100) NOT NULL
);
--
-- Create model Insurance
--
CREATE TABLE "bd_insurance" (
  "id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, 
  "insurance_type" integer NOT NULL
);
--
-- Create model Managers
--
CREATE TABLE "bd_managers" (
  "id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, 
  "first_name" varchar(100) NOT NULL, 
  "last_name" varchar(100) NOT NULL, 
  "phone" varchar(20) NOT NULL, 
  "email" varchar(254) NOT NULL
);
--
-- Create model Organizations
--
CREATE TABLE "bd_organizations" (
  "id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, 
  "name_organization" varchar(200) NOT NULL
);
--
-- Create model PaymentMethods
--
CREATE TABLE "bd_paymentmethods" (
  "id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, 
  "method_name" varchar(100) NOT NULL UNIQUE
);
--
-- Create model PaymentStatuses
--
CREATE TABLE "bd_paymentstatuses" (
  "id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, 
  "status_name" varchar(100) NOT NULL UNIQUE
);
--
-- Create model ClientCities
--
CREATE TABLE "bd_clientcities" (
  "id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, 
  "name_client_city" varchar(100) NOT NULL, 
  "clients_id" bigint NULL REFERENCES "bd_clients" ("id") DEFERRABLE INITIALLY DEFERRED
);
--
-- Create model Cities
--
CREATE TABLE "bd_cities" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, 
  "name_city" varchar(100) NOT NULL, 
  "countries_id" bigint NOT NULL REFERENCES "bd_countries" ("id") DEFERRABLE INITIALLY DEFERRED
);
--
-- Create model Flights
--
CREATE TABLE "bd_flights" (
  "id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, 
  "flight_number" varchar(50) NOT NULL, 
  "departure_time" datetime NOT NULL, 
  "arrival_time" datetime NOT NULL, 
  "airlines_id" bigint NOT NULL REFERENCES "bd_airlines" ("id") DEFERRABLE INITIALLY DEFERRED
);
--
-- Create model Hotels
--
CREATE TABLE "bd_hotels" (
  "id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, 
  "name_hotel" varchar(200) NOT NULL, 
  "child_menu" bool NOT NULL DEFAULT 0, 
  "have_nanny" bool NOT NULL DEFAULT 0, 
  "child_program" bool NOT NULL DEFAULT 0, 
  "hotel_address" text NOT NULL, 
  "geo_coordinates" varchar(100) NULL, 
  "cities_id" bigint NOT NULL REFERENCES "bd_cities" ("id") DEFERRABLE INITIALLY DEFERRED
);
--
-- Create model Contracts
--
CREATE TABLE "bd_contracts" (
  "id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, 
  "contract_number" varchar(50) NOT NULL UNIQUE, 
  "clients_id" bigint NOT NULL REFERENCES "bd_clients" ("id") DEFERRABLE INITIALLY DEFERRED, 
  "managers_id" bigint NOT NULL REFERENCES "bd_managers" ("id") DEFERRABLE INITIALLY DEFERRED
);
--
-- Create model Payments
--
CREATE TABLE "bd_payments" (
  "id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, 
  "payment_date" datetime NOT NULL, 
  "amount" decimal NOT NULL, 
  "contracts_id" bigint NOT NULL REFERENCES "bd_contracts" ("id") DEFERRABLE INITIALLY DEFERRED, 
  "payment_method_id" bigint NOT NULL REFERENCES "bd_paymentmethods" ("id") DEFERRABLE INITIALLY DEFERRED, 
  "status_id" bigint NOT NULL REFERENCES "bd_paymentstatuses" ("id") DEFERRABLE INITIALLY DEFERRED
);
--
-- Create model Tours
--
CREATE TABLE "bd_tours" (
  "id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, 
  "name_tour" varchar(200) NOT NULL, 
  "mark_for_deletion" bool NULL, 
  "cities_id" bigint NOT NULL REFERENCES "bd_cities" ("id") DEFERRABLE INITIALLY DEFERRED, 
  "flights_id" bigint NOT NULL REFERENCES "bd_flights" ("id") DEFERRABLE INITIALLY DEFERRED, 
  "hotels_id" bigint NOT NULL REFERENCES "bd_hotels" ("id") DEFERRABLE INITIALLY DEFERRED, 
  "insurance_id" bigint NOT NULL REFERENCES "bd_insurance" ("id") DEFERRABLE INITIALLY DEFERRED
);
--
-- Create model Excursions
--
CREATE TABLE "bd_excursions" (
  "id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, 
  "name_excursion" varchar(200) NOT NULL, 
  "night_transfer" bool NOT NULL DEFAULT 0, 
  "danger_level" integer NOT NULL DEFAULT 0, 
  "child_friendly" bool NOT NULL DEFAULT 0, 
  "duration" integer NOT NULL, 
  "cities_id" bigint NOT NULL REFERENCES "bd_cities" ("id") DEFERRABLE INITIALLY DEFERRED, 
  "organizations_id" bigint NOT NULL REFERENCES "bd_organizations" ("id") DEFERRABLE INITIALLY DEFERRED, 
  "tours_id" bigint NULL REFERENCES "bd_tours" ("id") DEFERRABLE INITIALLY DEFERRED
);
--
-- Add field tours to contracts
--
CREATE TABLE "new__bd_contracts" (
  "id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, 
  "contract_number" varchar(50) NOT NULL UNIQUE, 
  "clients_id" bigint NOT NULL REFERENCES "bd_clients" ("id") DEFERRABLE INITIALLY DEFERRED, 
  "managers_id" bigint NOT NULL REFERENCES "bd_managers" ("id") DEFERRABLE INITIALLY DEFERRED, 
  "tours_id" bigint NOT NULL REFERENCES "bd_tours" ("id") DEFERRABLE INITIALLY DEFERRED
);

INSERT INTO "new__bd_contracts" 
  ("id", "contract_number", "clients_id", "managers_id", "tours_id") 
SELECT 
  "id", "contract_number", "clients_id", "managers_id", NULL 
FROM 
  "bd_contracts"; 

DROP TABLE "bd_contracts";

ALTER TABLE "new__bd_contracts" RENAME TO "bd_contracts";

CREATE INDEX "bd_clientcities_clients_id_db2908f8" ON "bd_clientcities" ("clients_id");
CREATE INDEX "bd_cities_countries_id_bb3d7ff7" ON "bd_cities" ("countries_id");
CREATE INDEX "bd_flights_airlines_id_bb1abda9" ON "bd_flights" ("airlines_id");
CREATE INDEX "bd_hotels_cities_id_48c5f417" ON "bd_hotels" ("cities_id");
CREATE INDEX "bd_payments_contracts_id_d37927e6" ON "bd_payments" ("contracts_id");
CREATE INDEX "bd_payments_payment_method_id_adacb02f" ON "bd_payments" ("payment_method_id");
CREATE INDEX "bd_payments_status_id_473ba16d" ON "bd_payments" ("status_id");
CREATE INDEX "bd_tours_cities_id_776e8bf7" ON "bd_tours" ("cities_id");
CREATE INDEX "bd_tours_flights_id_541fcd29" ON "bd_tours" ("flights_id");
CREATE INDEX "bd_tours_hotels_id_0a1a85c5" ON "bd_tours" ("hotels_id");
CREATE INDEX "bd_tours_insurance_id_0962e7d0" ON "bd_tours" ("insurance_id");
CREATE INDEX "bd_excursions_cities_id_4a26d972" ON "bd_excursions" ("cities_id");
CREATE INDEX "bd_excursions_organizations_id_e51ad9d4" ON "bd_excursions" ("organizations_id");
CREATE INDEX "bd_excursions_tours_id_69de492b" ON "bd_excursions" ("tours_id");
CREATE INDEX "bd_contracts_clients_id_722f91a0" ON "bd_contracts" ("clients_id");
CREATE INDEX "bd_contracts_managers_id_1e888a85" ON "bd_contracts" ("managers_id");
CREATE INDEX "bd_contracts_tours_id_a785c4df" ON "bd_contracts" ("tours_id");

COMMIT;
