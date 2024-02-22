DELIMITER //
CREATE PROCEDURE CheckBooking(IN booked_date DATE, IN table_num INT)
BEGIN
    DECLARE bookedTab INT DEFAULT 0;
	 SELECT COUNT(bookedTab)
        INTO bookedTab
        FROM Bookings WHERE BookingDate = booked_date AND TableNumber = table_num;
	    IF bookedTab > 0 THEN
          SELECT CONCAT("Table ", table_num, " is already booked") AS "Booking Status";
		  ELSE
		  SELECT CONCAT("Table ", table_num, " is not booked") AS "Booking Status";
	    END IF;
END //
DELIMITER ;

CALL CheckBooking("2022-11-12", 3);