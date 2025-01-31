show databases;
create database carparkingmanagement_systementr;
use carparkingmanagementsystementr;
CREATE TABLE Customer (
CustomerID INT PRIMARY KEY AUTO_INCREMENT,
mName VARCHAR(100) NOT NULL,
Phone VARCHAR(15)  NULL,
Email VARCHAR(100)  NOT NULL,
Address VARCHAR(255) NOT NULL);
select*from Customer;
CREATE TABLE Car (
CarID INT PRIMARY KEY AUTO_INCREMENT,
Make VARCHAR(50) NOT NULL,
Model VARCHAR(50) NOT NULL,
Price  int);
alter table car
add column mstatus varchar(50);
select*from  Car;

alter table students
add column fees varchar(50);
drop table car;
CREATE TABLE Rental (
RentalID INT PRIMARY KEY AUTO_INCREMENT,
CustomerID INT NOT NULL,
CarID INT NOT NULL,
StartDate DATE NOT NULL,
EndDate DATE NOT NULL,
FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
FOREIGN KEY (CarID) REFERENCES Car(CarID));
show tables;

insert into Customer values
(1,'medard','0786666666a6','medard@gmail.com','kabona'),
(2,'okel','078886666a6','okel@gmail.com','kabona'),
(3,'medard','0786666666a6','medard@gmail.com','kabona');
select*from Customer;
desc car;

insert into car values
(001,'toyota','nsubish',10.2,'Available','dd'),
(002,'daihatsu','yunday',29.4,'Rented','ff'),
(003,'mbenz','hyhblide',45.4,'Sold','gg');
select*from Car;

desc rental;
insert into rental values
(1,3,002,'2024-02-23','2024-02-28'),
(2,1,001,'2023-02-1','2024-03-4'),
(3,2,003,'2025-01-3','2025-02-1');
select *from rental;

-- Insert a new customer
insert into customer values
(4,'manishimwe', '9876543210', 'john@example.com', 'gahinga');
select*from customer;
-- update customer
update customer
set address=" butare"
where customerid =3;
select*from customer;

-- Delete a  customer
delete from customer where customerid =1;
select*from customer;

-- insert new car

insert into car values
(005,'mubazi','hyhblide',45.4,'Sold','gg');
select*from car;

update car
set make="jagwal"
where carid =3;
select*from Car;

-- Delete a  car

delete from Car where CarID=001;

-- insert into rental

insert into rental values
(4,3,3,'2024-03-25','2024-04-30');
select*from rental;

-- update rental

update rental
set startdate="2025-04-16"
where rentalid=3;
select*from rental;

delete from rental where rentalid=001;
select*from rental;

-- Count total cars
SELECT COUNT(*) AS TotalCars FROM Car;

-- Count available parking slots
SELECT COUNT(*) AS AvailableSlots FROM Parking WHERE Status = 'Available';
-- Average rental amount paid
SELECT AVG(AmountPaid) AS AvgRentalAmount FROM Rental;

-- Total revenue from rentals
SELECT SUM(AmountPaid) AS TotalRevenue FROM Rental;
-- Find the most frequent customer (highest rentals)
SELECT CustomerID, COUNT(*) AS RentalCount 
FROM Rental 
GROUP BY CustomerID 
ORDER BY RentalCount DESC 
LIMIT 1;

-- Find the latest rental transaction
SELECT * FROM Rental ORDER BY EntryTime DESC LIMIT 1
-- 1. Procedure to Add a New Customer
DELIMITER //
CREATE PROCEDURE AddCustomer(
    IN mName VARCHAR(100), 
    IN Phone VARCHAR(15), 
    IN Email VARCHAR(100), 
    IN Address VARCHAR(255)
)
BEGIN
    INSERT INTO Customer(mName, Phone, Email, Address) 
    VALUES (mName, Phone, Email, Address);
END //
DELIMITER ;

-- 2. Procedure to Update a Customer's Address
DELIMITER //
CREATE PROCEDURE UpdateCustomerAddress(
    IN CustID INT, 
    IN NewAddress VARCHAR(255)
)
BEGIN
    UPDATE Customer 
    SET Address = NewAddress 
    WHERE CustomerID = CustID;
END //
DELIMITER ;

-- 3. Trigger to Prevent Duplicate Phone Numbers in Customers
DELIMITER //
CREATE TRIGGER PreventDuplicatePhone BEFORE INSERT ON Customer
FOR EACH ROW
BEGIN
    IF (SELECT COUNT(*) FROM Customer WHERE Phone = NEW.Phone) > 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Duplicate phone numbers are not allowed';
    END IF;
END //
DELIMITER ;

-- 4. Trigger to Automatically Update Car Status when Inserted in Rental
DELIMITER //
CREATE TRIGGER UpdateCarStatusAfterRental AFTER INSERT ON Rental
FOR EACH ROW
BEGIN
    UPDATE Car SET mstatus = 'Rented' WHERE CarID = NEW.CarID;
END //
DELIMITER ;

-- 5. Procedure to Retrieve All Rentals within a Date Range
DELIMITER //
CREATE PROCEDURE GetRentalsByDate(
    IN StartDate DATE, 
    IN EndDate DATE
)
BEGIN
    SELECT * FROM Rental WHERE StartDate BETWEEN StartDate AND EndDate;
END //
DELIMITER ;

-- 6. Trigger to Prevent Rentals with Invalid Dates
DELIMITER //
CREATE TRIGGER ValidateRentalDates BEFORE INSERT ON Rental
FOR EACH ROW
BEGIN
    IF NEW.StartDate > NEW.EndDate THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Start date cannot be after end date';
    END IF;
END //
DELIMITER ;

-- call procedures

CALL UpdateCustomerAddress(1, '456 Oak Avenue');

CALL GetRentalsByDate('2024-03-01', '2024-03-31');


create user '1234567'@'127.0.0.1' identified by '1234567';
grant all privileges on carparkingmanagement_systementr. *to '123456'@'127.0.0.1';

