DELIMITER //

CREATE PROCEDURE AddValidBooking( IN booked_date DATE, IN table_num INT, IN cust_id INT, IN booking_id INT)
BEGIN
    DECLARE bookingCount INT DEFAULT 0;
    
    START TRANSACTION;

    SELECT COUNT(*) INTO bookingCount
    FROM Bookings
    WHERE BookingDate = booked_date AND TableNumber = table_num;

    IF bookingCount > 0 THEN
        ROLLBACK;
        SELECT CONCAT('Table ', table_num, ' is already booked - booking cancelled') AS "Booking Status";
    ELSE
        INSERT INTO Bookings (BookingID, BookingDate, TableNumber, CustomerID)
        VALUES (booking_id, booked_date, table_num, cust_id);
        COMMIT;
        SELECT 'Booking successful' AS "Booking Status";
    END IF;
END//

DELIMITER ;


