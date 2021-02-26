
CREATE VIEW allflights AS
SELECT b.country AS departure_city_name,
c.country AS destination_city_name,
brweekly_schedule.departure_time AS departure_time,
brweekly_schedule.weekday AS departure_day,
brflight.week AS departure_week,
brweekly_schedule.year AS departure_year,
calculateFreeSeats(brflight.flightnumber) AS nr_of_free_seats,
calculatePrice(brflight.flightnumber) AS current_price_per_seat
FROM brflight
LEFT JOIN brweekly_schedule ON brflight.weekly_schedule = brweekly_schedule.weekly_schedule_id
LEFT JOIN brroute a ON brweekly_schedule.route = a.route_id
LEFT JOIN brairport b ON a.departure_airport_code = b.airport_code 
LEFT JOIN brairport c ON a.arrival_airport_code = c.airport_code;