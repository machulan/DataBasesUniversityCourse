-- Standard syntax  
/*INSERT dbo.Products (ProductID, ProductName, Price, ProductDescription)  
    VALUES (1, 'Clamp', 12.48, 'Workbench clamp')  
GO */

/*INSERT INTO MyUniqueTable(Characters) VALUES ('abc') 
INSERT INTO MyUniqueTable VALUES (NEWID(), 'def') GO*/

/*DELETE FROM OrderTripPair;
DELETE FROM Trips;
DELETE FROM OrderGoodsPair;
DELETE FROM Goods;
DELETE FROM Orders;
DELETE FROM Clients;
DELETE FROM Cities;
DELETE FROM Regions;

DELETE FROM Countries;
DELETE FROM Dues;

DELETE FROM Drivers;
DELETE FROM Cars;*/











--TRUNCATE Cars;

INSERT Cars
	(car_model, color, car_type, weight, transportation_coefficient, travel_costs_per_kilometre, total_run)
VALUES
	('МАН', 'желтый', 'грузовик', 15.1, 7.98, 321.5, 1000.4);

INSERT Cars
	(car_model, color, car_type, weight, transportation_coefficient, travel_costs_per_kilometre, total_run)
VALUES
	('КамАЗ', 'оранжевый', 'грузовик', 9.8, 5.501, 356.6, 9999.99);

INSERT Drivers
	(passport_number, first_name, last_name, insurance_number, experience, driver_licence_number, driver_licence_category)
VALUES
	(1310111111, 'Иван', 'Иванов', 123456789, 30, 1876543210, 'C1E');

INSERT Drivers
	(passport_number, first_name, last_name, insurance_number, experience, driver_licence_number, driver_licence_category)
VALUES
	(1310777777, 'Равшан', 'Гость-из-Средней-Азии', 000000000, 0, 0000000000, 'A');
	

INSERT Countries
	(country_name)
VALUES
	('Россия'), ('США'), ('Германия'), ('Великобритания'), ('Китай'), ('Испания'), ('Италия');

INSERT Dues
VALUES
	(1, 2, 101), (1, 3, 50), (3, 4, 0), (4, 3, 0), (3, 6, 0), (6, 3, 0), (4, 6, 0), (6, 4, 0), (2, 7, 10), (1, 4, 90), (4, 1, 70);
	
INSERT Regions
	--(region_id, country_id, region_name)--(country_id, region_id, region_name)
VALUES
	(1, 'Саратовская область');/*, (1, 2, 'Московская область'), (1, 3, 'Москва'), (1, 4, 'Санкт-Петербург'), 
	(2, 5, 'Орегон'), (2, 6, 'Вермонт'), (4, 7, 'Кент'), (5, 8, 'Сычуань'), (7, 9, 'Лацио'), (7, 10, 'Неаполь');*/
	
	



/*
INSERT Trips
	(driver_id, car_id, start_time, end_time, distance)
VALUES
	(1, 1, '2016-02-28','2017-02-28',10000.72);*/