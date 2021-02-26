/*
-------- Drop all tables
at the beginning of the file!
*/

/*
DROP TABLE IF EXISTS brcity;
DROP TABLE IF EXISTS brairport;
DROP TABLE IF EXISTS brroute;
DROP TABLE IF EXISTS bryear;
DROP TABLE IF EXISTS brweekday;
DROP TABLE IF EXISTS brdepends;
DROP TABLE IF EXISTS brweekly_schedule;
DROP TABLE IF EXISTS brplane;
DROP TABLE IF EXISTS brflight;
DROP TABLE IF EXISTS brpassenger;
DROP TABLE IF EXISTS brcontact_person;
DROP TABLE IF EXISTS brreservation;
DROP TABLE IF EXISTS brcard;
DROP TABLE IF EXISTS brbooking;
DROP TABLE IF EXISTS brhas_ticket;



------ Create the database ------ 
*/
DROP DATABASE IF EXISTS br;
CREATE DATABASE br;
USE br;


/*
------ Create the table airport ------ 
*/
CREATE TABLE brairport(
airport_code VARCHAR(3) PRIMARY KEY,
airport_name VARCHAR(30), 
country VARCHAR(30)
);

/*
------ Create the table route ------ 
*/
CREATE TABLE brroute(
route_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
departure_airport_code VARCHAR(3),
arrival_airport_code VARCHAR(3),
FOREIGN KEY (departure_airport_code) REFERENCES brairport(airport_code),
FOREIGN KEY (arrival_airport_code) REFERENCES brairport(airport_code)
);

/*
------ Create the table year ------ 
*/
CREATE TABLE bryear(

year INTEGER NOT NULL, 
profitfactor DOUBLE,

PRIMARY KEY (year)
);

/*
------ Create the table weekday ------ 
*/
CREATE TABLE brweekday(

day VARCHAR(10) NOT NULL, 
year INTEGER NOT NULL,
weekdayfactor DOUBLE,

PRIMARY KEY (day),
FOREIGN KEY (year) REFERENCES bryear(year)
);

/*
------  Create the table depends ------ 
*/
CREATE TABLE brdepends(

year INTEGER NOT NULL,
route INTEGER NOT NULL,
routeprice DOUBLE,

PRIMARY KEY (year, route),
FOREIGN KEY (year) REFERENCES bryear(year),
FOREIGN KEY (route) REFERENCES brroute(route_id)
);

/*
------  Create the table weekly schedule ------ 
*/
CREATE TABLE brweekly_schedule(
weekly_schedule_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
year INT,
weekday VARCHAR(10),
departure_time TIME,
route INT,
FOREIGN KEY (year) REFERENCES bryear(year),
FOREIGN KEY (weekday) REFERENCES brweekday(day),
FOREIGN KEY (route) REFERENCES brroute(route_id)
);

/*
------ Create the table flight ------ 
*/
CREATE TABLE brflight(

flightnumber INTEGER AUTO_INCREMENT,
weekly_schedule INTEGER NOT NULL,
week INTEGER NOT NULL CHECK (week<=52 and week>=1),

PRIMARY KEY (flightnumber),
FOREIGN KEY (weekly_schedule) REFERENCES brweekly_schedule(weekly_schedule_id)

);

/*
------ Create the table passenger ------ 
*/
CREATE TABLE brpassenger(

passport_number INTEGER NOT NULL,
name VARCHAR(30),

PRIMARY KEY (passport_number)

);


/*
------ Create the table contact person ------ 
*/
CREATE TABLE brcontact_person(

passport_number INTEGER NOT NULL,
phone_number BIGINT,
email VARCHAR(30),

PRIMARY KEY (passport_number),
FOREIGN KEY (passport_number) REFERENCES brpassenger(passport_number)

);


/*
------ Create the table reservation ------ 
*/
CREATE TABLE brreservation(
reservation_number INT PRIMARY KEY,
total_price DOUBLE NOT NULL,
flight INT NOT NULL,
number_of_passengers INT NOT NULL DEFAULT 1 CHECK (number_of_passengers<=40),
passport_number INT,
FOREIGN KEY (flight) REFERENCES brflight(flightnumber),
FOREIGN KEY (passport_number) REFERENCES brcontact_person(passport_number)
);

/*
------ Create the table card ------ 
*/
CREATE TABLE brcard(
creditcard_number BIGINT NOT NULL PRIMARY KEY,
card_holder VARCHAR(30)
);

/*
------ Create the table booking ------ 
*/
CREATE TABLE brbooking(
booking_id INT PRIMARY KEY,
creditcard_number BIGINT,
FOREIGN KEY (booking_id) REFERENCES brreservation(reservation_number),
FOREIGN KEY (creditcard_number) REFERENCES brcard(creditcard_number)
);

/*
------ Create the table has ticket ------ 
*/
CREATE TABLE brhas_ticket(

ticket_NR INTEGER NOT NULL,
passport_number INTEGER NOT NULL,
booking_id INTEGER NOT NULL,

PRIMARY KEY (passport_number, booking_id),
FOREIGN KEY (passport_number) REFERENCES brpassenger(passport_number),
FOREIGN KEY (booking_id) REFERENCES brbooking(booking_id)

);
