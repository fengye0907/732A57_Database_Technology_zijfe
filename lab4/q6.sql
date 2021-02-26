
DROP PROCEDURE IF EXISTS addReservation;
DROP PROCEDURE IF EXISTS addContact;

/*
-------- Exercise 6 -------- a)
*/

DELIMITER //
CREATE PROCEDURE addReservation(IN departure_airport_code VARCHAR(3), 
	IN arrival_airport_code VARCHAR(3), 
	IN year INTEGER, 
	IN week INTEGER, 
	IN day VARCHAR(10),
	IN time TIME,
	IN number_of_passengers INTEGER,
	IN output_reservation_nr INTEGER)
BEGIN

SET @de := departure_airport_code;
SET @ar := arrival_airport_code;
SET @year := year;
SET @week := week;
SET @day := day;
SET @dtime = time;
IF 
	output_reservation_nr IN (SELECT reservation_number FROM brreservation)
THEN
	SELECT 'The reservation number already EXISTS' AS 'Message';
ELSE
	SET @fnumber = (SELECT flightnumber FROM brflight AS bf, 
				brweekly_schedule AS bws,
				brroute AS br
	WHERE bf.weekly_schedule = bws.weekly_schedule_id
	AND bws.route = br.route_id
	AND br.departure_airport_code = @de
	AND br.arrival_airport_code = @ar
	AND bws.year = @year
	AND bf.week = @week
	AND bws.weekday = @day
	AND bws.departure_time = @dtime
	);

	IF (IFNULL(@fnumber,0))=0
	THEN
		SELECT  'There exist no flight for the given route, date and time' as "Message"; 
	ELSEIF 
		calculateFreeSeats(@fnumber) < number_of_passengers
	THEN
		SELECT "There are not enough seats available on the chosen flight" AS 'Message';
	ELSE
		SET @tprice = calculatePrice(@fnumber);
		INSERT INTO brreservation(reservation_number, flight, number_of_passengers, total_price)
		VALUES (output_reservation_nr, @fnumber, number_of_passengers, @tprice);
		SELECT output_reservation_nr AS 'Res. number returned';
	END IF;
END IF;
END
//
DELIMITER ;

/*
-------- Exercise 6 -------- b)
*/
DROP PROCEDURE IF EXISTS addPassenger;

DELIMITER //
CREATE PROCEDURE addPassenger(IN reservation_nr INT,
	IN passport_number INT,
	IN name VARCHAR(30))
BEGIN
SET @nm = name;
SET @pn = passport_number;
SET @rn = reservation_nr;
IF
	@rn NOT IN (SELECT brreservation.reservation_number FROM brreservation)
THEN 
	SELECT "The given reservation number does not exist" as "Message";
ELSEIF
	(SELECT b.creditcard_number FROM brbooking AS b, brreservation AS res
		WHERE res.reservation_number = b.booking_id
		AND res.reservation_number = @rn) IS NOT NULL
THEN
	SELECT "The booking has already been payed and no futher passengers can be added" as "Message";
ELSE
	IF 
		@pn NOT IN (SELECT brpassenger.passport_number FROM brpassenger)
	THEN
		INSERT INTO brpassenger(passport_number, name)
		VALUES(@pn, @nm);
		SELECT "passenger list UPDATE" AS "Add. Message";
	END IF;
	IF 
		@rn NOT IN (SELECT b.booking_id FROM brbooking AS b)
	THEN
		INSERT INTO brbooking(booking_id)
		VALUES(@rn);    # the reservation number is paid
	END IF;

	SET @tnumber = (SELECT floor(rand()*10000));
	WHILE (@tnumber IN (SELECT brhas_ticket.ticket_NR FROM brhas_ticket)) DO
		SET @tnumber = (SELECT floor(rand()*10000));
	END WHILE;

	INSERT INTO brhas_ticket(ticket_NR, passport_number, booking_id)
	VALUES(@tnumber, @pn, @rn);

	SELECT "Passenger added" AS "Message";
END IF;

END//
DELIMITER ;


/*
-------- Exercise 6 -------- c)
*/

DELIMITER //
CREATE PROCEDURE addContact(IN reservation_nr INT,
	IN passport_number INTEGER,
	IN email VARCHAR(30),
	IN phone BIGINT)
BEGIN
SET @rn = reservation_nr;
SET @pn = passport_number;

IF 
	NOT EXISTS (SELECT * FROM brreservation
				WHERE brreservation.reservation_number = @rn)
THEN
	SELECT "The given reservation number does not exist" as "Message";
ELSEIF 
	NOT EXISTS (SELECT * FROM brpassenger 
			WHERE brpassenger.passport_number = @pn)
THEN
	SELECT "The person is not a passenger of the reservation" as "Message";
ELSEIF 
	 (SELECT brreservation.passport_number FROM brreservation
		WHERE brreservation.reservation_number = @rn) = NULL
THEN	
	SELECT "The reservation already has contact" AS "Message";
ELSE
	INSERT INTO brcontact_person(passport_number, email, phone_number)
	VALUES(@pn, email, phone);
	SELECT "Contact added" AS "Message";

	UPDATE brreservation SET passport_number = @pn
	WHERE reservation_number = @rn;
END IF;
END//
DELIMITER ;

/*
-------- Exercise 6 -------- d)
*/

DROP PROCEDURE IF EXISTS addPayment;

DELIMITER //
CREATE PROCEDURE addPayment(IN reservation_nr INT,
	IN cardholder_name VARCHAR(30),
	IN credit_card_number BIGINT)
BEGIN
SET @rn = reservation_nr;
SET @fn = (SELECT f.flightnumber FROM brflight AS f, brreservation AS r 
			WHERE f.flightnumber = r.flight
			AND r.reservation_number = @rn);
IF 
	NOT EXISTS (SELECT * FROM brreservation
				WHERE brreservation.reservation_number = @rn)
THEN
	SELECT "The given reservation number does not exist" as "Message";
ELSEIF 
	(SELECT number_of_passengers FROM brreservation WHERE reservation_number = @rn) >
	calculateFreeSeats(@fn) OR calculateFreeSeats(@fn)<0
THEN
	DELETE brhas_ticket FROM brhas_ticket
	LEFT JOIN brbooking ON brhas_ticket.booking_id = brbooking.booking_id
	WHERE brbooking.booking_id = @rn;

	DELETE brbooking FROM brbooking WHERE brbooking.booking_id = @rn;

	DELETE brreservation FROM brreservation WHERE brreservation.reservation_number = @rn;
	
	SELECT "There are not enough seats available on the flight anymore, deleting reservation" as "Message";
ELSEIF
	(SELECT r.passport_number FROM brreservation  AS r
		WHERE r.reservation_number = @rn) IS NULL
THEN
	SELECT "The reservation has no contact yet" as "Message";
ELSE
	IF
		NOT EXISTS (SELECT * FROM brcard AS bc 
				WHERE bc.creditcard_number = credit_card_number
				AND bc.card_holder = cardholder_name)
	THEN
		INSERT INTO brcard(creditcard_number, card_holder)
		VALUES(credit_card_number, cardholder_name);
		SELECT "card list UPDATE" AS "Add. Message";
	END IF;
	UPDATE brbooking SET creditcard_number=credit_card_number
	WHERE booking_id=@rn;
	SELECT "Thank for payment" AS "Message";

END IF;
END//
DELIMITER ;



/*Fill the database with data */

/*
CALL addYear(2010, 2.3);
CALL addDay(2010,"Monday",1);
CALL addDestination("MIT","Minas Tirith","Mordor");
CALL addDestination("HOB","Hobbiton","The Shire");
CALL addRoute("MIT","HOB",2010,2000);
CALL addFlight("MIT","HOB", 2010, "Monday", "09:00:00");
CALL addFlight("MIT","HOB", 2010, "Monday", "21:00:00");

SELECT "Test 1: Adding a reservation, expected OK result" as "Message";
CALL addReservation("MIT","HOB",2010,1,"Monday","09:00:00",3,@a);
SELECT "Check that the reservation number is returned properly (any number will do):" AS "Message",@a AS "Res. number returned"; 

SELECT "Test 2: Adding a reservation with incorrect flightdetails. Expected answer: There exist no flight for the given route, date and time" as "Message";
CALL addReservation("MIT","HOB",2010,1,"Tuesday","21:00:00",3,@b); 

SELECT "Test 3: Adding a reservation when there are not enough seats. Expected answer: There are not enough seats available on the chosen flight" as "Message";
CALL addReservation("MIT","HOB",2010,1,"Monday","09:00:00",61,@c); 

SELECT "Test 4.1: Adding a passenger. Expected OK result" as "Message";
CALL addPassenger(@a,00000001,"Frodo Baggins");

SELECT "Test 4.2: Test whether the same passenger can be added to other reservations. For this test, first add another reservation" as "Message";
CALL addReservation("MIT","HOB",2010,1,"Monday","21:00:00",4,@e);
SELECT @e AS "Reservation number";

SELECT "Now testing. Expected OK result" as "Message";
CALL addPassenger(@e,00000001,"Frodo Baggins"); 

SELECT "Test 5: Adding a passenger with incorrect reservation number. Expected result: The given reservation number does not exist" as "Message";
CALL addPassenger(9999999,00000001,"Frodo Baggins"); 

SELECT "Test 6: Adding a contact. Expected OK result" as "Message";
CALL addContact(@a,00000001,"frodo@magic.mail",080667989); 

SELECT "Test 7: Adding a contact with incorrect reservation number. Expected result: The given reservation number does not exist" as "Message";
CALL addContact(99999,00000001,"frodo@magic.mail",080667989); 

SELECT "Test 8: Adding a contact that is not a passenger on the reservation. Expected result: The person is not a passenger of the reservation" as "Message";
CALL addContact(@a,00000099,"frodo@magic.mail",080667989); 



SELECT "Test 9: Making a payment. Expected OK result" as "Message";
CALL addPayment (@a, "Gandalf", 6767676767676767); 

SELECT "Test 10: Making a payment to a reservation with incorrect reservation number. Expected result: The given reservation number does not exist" as "Message";
CALL addPayment (999999, "Gandalf", 6767676767676767);

SELECT "Test 11: Making a payment to a reservation with no contact. First setting up reservation" as "Message";
CALL addReservation("MIT","HOB",2010,1,"Monday","09:00:00",1,@d); 
CALL addPassenger(@d,00000002,"Sam Gamgee"); 

SELECT "Now testing. Expected result: The reservation has no contact yet" as "Message";
CALL addPayment (@d, "Gandalf", 6767676767676767); 

SELECT "Test 12: Adding a passenger to an already payed reservation. Expected result: The booking has already been payed and no futher passengers can be added" as "Message";
CALL addPassenger(@a,00000003,"Merry Pippins"); 

*/