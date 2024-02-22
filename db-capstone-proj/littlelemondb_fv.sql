-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema littlelemondb_fv
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema littlelemondb_fv
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `littlelemondb_fv` DEFAULT CHARACTER SET utf8mb3 ;
USE `littlelemondb_fv` ;

-- -----------------------------------------------------
-- Table `littlelemondb_fv`.`customer_details`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `littlelemondb_fv`.`customer_details` (
  `CustomerID` INT NOT NULL,
  `FullName` VARCHAR(255) NOT NULL,
  `Email` VARCHAR(225) NOT NULL,
  PRIMARY KEY (`CustomerID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `littlelemondb_fv`.`bookings`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `littlelemondb_fv`.`bookings` (
  `BookingID` INT NOT NULL,
  `BookingDate` DATE NOT NULL,
  `TableNumber` INT NOT NULL,
  `CustomerID` INT NOT NULL,
  PRIMARY KEY (`BookingID`),
  INDEX `Customer_id_fk_idx` (`CustomerID` ASC) VISIBLE,
  CONSTRAINT `Customer_id_fk`
    FOREIGN KEY (`CustomerID`)
    REFERENCES `littlelemondb_fv`.`customer_details` (`CustomerID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `littlelemondb_fv`.`menu_items`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `littlelemondb_fv`.`menu_items` (
  `MenuItemsID` INT NOT NULL,
  `CourseName` VARCHAR(255) NOT NULL,
  `StarterName` VARCHAR(255) NOT NULL,
  `DessertName` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`MenuItemsID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `littlelemondb_fv`.`menu`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `littlelemondb_fv`.`menu` (
  `MenuID` INT NOT NULL,
  `MenuName` VARCHAR(225) NOT NULL,
  `Cuisine` VARCHAR(225) NOT NULL,
  `MenuItemsID` INT NOT NULL,
  PRIMARY KEY (`MenuID`),
  INDEX `fk_MenuItemsID_idx` (`MenuItemsID` ASC) VISIBLE,
  CONSTRAINT `fk_MenuItemsID`
    FOREIGN KEY (`MenuItemsID`)
    REFERENCES `littlelemondb_fv`.`menu_items` (`MenuItemsID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `littlelemondb_fv`.`order_delivery_status`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `littlelemondb_fv`.`order_delivery_status` (
  `DeliveryID` INT NOT NULL,
  `Date` DATE NOT NULL,
  `Status` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`DeliveryID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `littlelemondb_fv`.`orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `littlelemondb_fv`.`orders` (
  `OrderID` INT NOT NULL,
  `Date` DATE NOT NULL,
  `Quantity` INT NOT NULL,
  `TotalCost` DECIMAL(8,2) NOT NULL,
  `BookingID` INT NOT NULL,
  `CustomerID` INT NOT NULL,
  `MenuID` INT NOT NULL,
  `DeliveryID` INT NOT NULL,
  PRIMARY KEY (`OrderID`),
  INDEX `fk_CustomerID_idx` (`CustomerID` ASC) VISIBLE,
  INDEX `FK_BookingID_idx` (`BookingID` ASC) VISIBLE,
  INDEX `fk_MenuID_idx` (`MenuID` ASC) VISIBLE,
  INDEX `fk_DeliveryID_idx` (`DeliveryID` ASC) INVISIBLE,
  CONSTRAINT `fk_BookingID`
    FOREIGN KEY (`BookingID`)
    REFERENCES `littlelemondb_fv`.`bookings` (`BookingID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_CustomerID`
    FOREIGN KEY (`CustomerID`)
    REFERENCES `littlelemondb_fv`.`customer_details` (`CustomerID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_DeliveryID`
    FOREIGN KEY (`DeliveryID`)
    REFERENCES `littlelemondb_fv`.`order_delivery_status` (`DeliveryID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_MenuID`
    FOREIGN KEY (`MenuID`)
    REFERENCES `littlelemondb_fv`.`menu` (`MenuID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `littlelemondb_fv`.`staff_info`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `littlelemondb_fv`.`staff_info` (
  `StaffID` INT NOT NULL,
  `FullName` VARCHAR(255) NOT NULL,
  `Email` VARCHAR(225) NOT NULL,
  `Role` VARCHAR(45) NOT NULL,
  `Salary` DECIMAL(8,2) NOT NULL,
  `CustomerID` INT NOT NULL,
  PRIMARY KEY (`StaffID`),
  INDEX `fk2_CustomerID_idx` (`CustomerID` ASC) VISIBLE,
  CONSTRAINT `fk2_CustomerID`
    FOREIGN KEY (`CustomerID`)
    REFERENCES `littlelemondb_fv`.`customer_details` (`CustomerID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

USE `littlelemondb_fv` ;

-- -----------------------------------------------------
-- Placeholder table for view `littlelemondb_fv`.`ordersview`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `littlelemondb_fv`.`ordersview` (`OrderID` INT, `Quantity` INT, `TotalCost` INT);

-- -----------------------------------------------------
-- procedure AddBooking
-- -----------------------------------------------------

DELIMITER $$
USE `littlelemondb_fv`$$
CREATE DEFINER=`admin1`@`%` PROCEDURE `AddBooking`(IN book_id INT, IN book_date DATETIME, IN table_num INT, IN cust_id INT)
BEGIN
	INSERT INTO Bookings(BookingID, BookingDate, TableNumber, CustomerID) VALUES
    (book_id, book_date, table_num, cust_id);
    SELECT "New booking added" AS "Confirmation";
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure AddValidBooking
-- -----------------------------------------------------

DELIMITER $$
USE `littlelemondb_fv`$$
CREATE DEFINER=`admin1`@`%` PROCEDURE `AddValidBooking`( IN booked_date DATE, IN table_num INT, IN cust_id INT, IN booking_id INT)
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
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure CancelBooking
-- -----------------------------------------------------

DELIMITER $$
USE `littlelemondb_fv`$$
CREATE DEFINER=`admin1`@`%` PROCEDURE `CancelBooking`(IN book_id INT)
BEGIN
    DELETE FROM Bookings WHERE BookingID = book_id;
    SELECT CONCAT("Booking ", book_id, " cancelled") AS "Confirmation";
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure CancelOrder
-- -----------------------------------------------------

DELIMITER $$
USE `littlelemondb_fv`$$
CREATE DEFINER=`admin1`@`%` PROCEDURE `CancelOrder`(IN inputOrderID INT)
BEGIN
    DELETE FROM Orders WHERE OrderID = inputOrderID;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure CheckBooking
-- -----------------------------------------------------

DELIMITER $$
USE `littlelemondb_fv`$$
CREATE DEFINER=`admin1`@`%` PROCEDURE `CheckBooking`(IN booked_date DATE, IN table_num INT)
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
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure GetMaxQuantity
-- -----------------------------------------------------

DELIMITER $$
USE `littlelemondb_fv`$$
CREATE DEFINER=`admin1`@`%` PROCEDURE `GetMaxQuantity`()
SELECT MAX(Quantity) AS "Max Quantity in Order"
FROM Orders$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure UpdateBooking
-- -----------------------------------------------------

DELIMITER $$
USE `littlelemondb_fv`$$
CREATE DEFINER=`admin1`@`%` PROCEDURE `UpdateBooking`(IN book_id INT, IN book_date DATE)
BEGIN
UPDATE Bookings SET BookingDate = book_date
WHERE BookingID = book_id;
SELECT CONCAT("Booking ", book_id, " updated") AS "Confirmation";
END$$

DELIMITER ;

-- -----------------------------------------------------
-- View `littlelemondb_fv`.`ordersview`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `littlelemondb_fv`.`ordersview`;
USE `littlelemondb_fv`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`admin1`@`%` SQL SECURITY DEFINER VIEW `littlelemondb_fv`.`ordersview` AS select `littlelemondb_fv`.`orders`.`OrderID` AS `OrderID`,`littlelemondb_fv`.`orders`.`Quantity` AS `Quantity`,`littlelemondb_fv`.`orders`.`TotalCost` AS `TotalCost` from `littlelemondb_fv`.`orders` where (`littlelemondb_fv`.`orders`.`Quantity` > 2);

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
