/*
-------- Exercise 4 --------
*/


/*
-------- Drop all functions
at the beginning of the file!
*/

DROP FUNCTION IF EXISTS calculateFreeSeats;
DROP FUNCTION IF EXISTS calculatePrice;

/*
-------- Exercise 4 -------- a)
*/

delimiter //
CREATE FUNCTION calculateFreeSeats(flightnumber INTEGER)
RETURNS INTEGER
BEGIN
	SET @fnumber = flightnumber;
	SET @seats = (SELECT COUNT(bp.passport_number) FROM brhas_ticket AS ht, brreservation AS res,
														brpassenger AS bp, brbooking AS bb
		WHERE res.flight = @fnumber
		AND bb.creditcard_number IS NOT NULL
		AND ht.booking_id = bb.booking_id
		AND bb.booking_id = res.reservation_number
		AND ht.passport_number = bp.passport_number);
	SET @seats = IFNULL(@seats, 0);  # if no booking alreadly
	RETURN (40 - @seats);
END//
delimiter ;



/*
-------- Exercise 4 -------- b)
*/

DELIMITER //
CREATE FUNCTION calculatePrice(flightnumber INTEGER)
RETURNS INTEGER
BEGIN
	SET @fnumber = flightnumber;


	SET @profitfactor = (
		SELECT profitfactor 
		FROM bryear AS y, brweekly_schedule AS ws, brflight AS fl
		WHERE y.year = ws.year
		AND ws.weekly_schedule_id = fl.weekly_schedule
		AND fl.flightnumber = @fnumber);

	SET @routeprice = (
		SELECT routeprice
		FROM brdepends AS dep, bryear AS y, brweekly_schedule AS ws, brflight AS fl
		WHERE dep.year = y.year
		AND y.year = ws.year
		AND dep.route = ws.route
		AND ws.weekly_schedule_id = fl.weekly_schedule
		AND fl.flightnumber = @fnumber);

	SET @BookedPassangers = 40 - calculateFreeSeats(@fnumber);

	SET @weekdfactor = (
		SELECT weekdayfactor
		FROM brweekday as wd, brweekly_schedule as ws, brflight as fl
		WHERE wd.day = ws.weekday
		AND ws.weekly_schedule_id = fl.weekly_schedule
		AND fl.flightnumber = @fnumber);

	SET @TotalPrice = @routeprice * 
						@weekdfactor * 
						@profitfactor * 
						(@BookedPassangers+1)/40;
	RETURN (@TotalPrice);

END//
DELIMITER ;



# SELECT calculateFreeSeats(1);
# SELECT calculatePrice(1);

