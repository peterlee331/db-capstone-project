DELIMITER //

CREATE PROCEDURE CancelBooking(IN book_id INT)
BEGIN
    DELETE FROM Bookings WHERE BookingID = book_id;
    SELECT CONCAT("Booking ", book_id, " cancelled") AS "Confirmation";
END //
DELIMITER ;

CALL CancelBooking(5);