/*
-------- Drop all procedures
at the beginning of the file!
*/

DROP PROCEDURE IF EXISTS addYear;
DROP PROCEDURE IF EXISTS addDay;
DROP PROCEDURE IF EXISTS addDestination;
DROP PROCEDURE IF EXISTS addRoute;
DROP PROCEDURE IF EXISTS addFlight;



/*
-------- Exercise 3 --------
*/


/*
--------Exercise 3 a)
*/

delimiter //
CREATE PROCEDURE addYear(IN year INTEGER, IN factor DOUBLE)
BEGIN
INSERT INTO bryear(year, profitfactor)
VALUES (year, factor);
END;
//
delimiter ;


/*
--------Exercise 3 b)
*/

delimiter //
CREATE PROCEDURE addDay(IN year INTEGER,IN day VARCHAR(10), IN factor DOUBLE)
BEGIN
INSERT INTO brweekday(year, day, weekdayfactor)
VALUES (year, day, factor);
END
//
delimiter ;

/*
--------Exercise 3 c)
*/

delimiter //
CREATE PROCEDURE addDestination(IN airport_code VARCHAR(3),IN name VARCHAR(30), IN country VARCHAR(30))
BEGIN
INSERT INTO brairport(airport_code, airport_name, country)
VALUES (airport_code, name, country);
END
//
delimiter ;

/*
--------Exercise 3 d)
*/

delimiter //
CREATE PROCEDURE addRoute(IN departure_airport_code VARCHAR(3), IN arrival_airport_code VARCHAR(3), IN year INTEGER, IN  routeprice DOUBLE)

BEGIN

SET @de := departure_airport_code;
SET @ar := arrival_airport_code;

IF 
	(SELECT COUNT(*) FROM brroute AS b 
	WHERE b.departure_airport_code = @de AND b.arrival_airport_code=@ar)=0
THEN
	INSERT INTO brroute(departure_airport_code, arrival_airport_code)
	VALUES (@de, @ar);
END IF;

SET @ri = (SELECT route_id FROM brroute AS brt 
WHERE brt.departure_airport_code = @de 
AND brt.arrival_airport_code  = @ar);

INSERT INTO brdepends(year, route, routeprice)
VALUES(year, @ri, routeprice);

END
//
delimiter ;

/*
--------Exercise 3 e)
*/


delimiter //
CREATE PROCEDURE addFlight(IN departure_airport_code VARCHAR(3), IN arrival_airport_code VARCHAR(3), 
							IN year INTEGER, IN day VARCHAR(10), IN departure_time TIME)
BEGIN

SET @de := departure_airport_code;
SET @ar := arrival_airport_code;
SET @year := year;
SET @day := day;
SET @dtime = departure_time;

SET @ri = (SELECT route_id FROM brroute AS brt 
WHERE brt.departure_airport_code = @de 
AND brt.arrival_airport_code  = @ar);

INSERT INTO brweekly_schedule(year, weekday, departure_time, route)
VALUES (@year, @day, @dtime, @ri);

SET @ws = (SELECT weekly_schedule_id FROM brweekly_schedule AS bws
WHERE bws.route = @ri
AND bws.year = @year
AND bws.weekday = @day
AND bws.departure_time = @dtime);

SET @week_Nr = 1;
WHILE @week_Nr <= 52 DO
    INSERT INTO brflight(weekly_schedule, week)
    VALUES (@ws, @week_Nr);
	SET @week_Nr = @week_Nr + 1;
end WHILE;

END
//
delimiter ;


/*
CALL addYear(2010, 2.3);
CALL addYear(2011, 2.5);
CALL addDay(2010,"Monday",1);
CALL addDay(2010,"Tuesday",1.5);
CALL addDay(2011,"Saturday",2);
CALL addDay(2011,"Sunday",2.5);
CALL addDestination("MIT","Minas Tirith","Mordor");
CALL addDestination("HOB","Hobbiton","The Shire");
CALL addRoute("MIT","HOB",2010,2000);
CALL addRoute("HOB","MIT",2010,1600);
CALL addRoute("MIT","HOB",2011,2100);
CALL addRoute("HOB","MIT",2011,1500);
CALL addFlight("MIT","HOB", 2010, "Monday", "09:00:00");
CALL addFlight("HOB","MIT", 2010, "Tuesday", "10:00:00");
CALL addFlight("MIT","HOB", 2011, "Sunday", "11:00:00");
CALL addFlight("HOB","MIT", 2011, "Sunday", "12:00:00");
*/
 


