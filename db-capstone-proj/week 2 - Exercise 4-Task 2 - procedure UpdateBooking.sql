DELIMITER //

CREATE PROCEDURE UpdateBooking(IN book_id INT, IN book_date DATE)
BEGIN
UPDATE Bookings SET BookingDate = book_date
WHERE BookingID = book_id;
SELECT CONCAT("Booking ", book_id, " updated") AS "Confirmation";
END //

DELIMITER ;