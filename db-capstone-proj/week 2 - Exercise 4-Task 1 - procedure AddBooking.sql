DELIMITER //
CREATE PROCEDURE AddBooking(IN book_id INT, IN book_date DATETIME, IN table_num INT, IN cust_id INT)
BEGIN
	INSERT INTO Bookings(BookingID, BookingDate, TableNumber, CustomerID) VALUES
    (book_id, book_date, table_num, cust_id);
    SELECT "New booking added" AS "Confirmation";
END //
DELIMITER ;

CALL AddBooking(7, "2022-12-30", 1, 3529063);