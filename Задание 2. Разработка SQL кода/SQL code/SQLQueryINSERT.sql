-- Standard syntax  
/*INSERT dbo.Products (ProductID, ProductName, Price, ProductDescription)  
    VALUES (1, 'Clamp', 12.48, 'Workbench clamp')  
GO */

/*INSERT INTO MyUniqueTable(Characters) VALUES ('abc') 
INSERT INTO MyUniqueTable VALUES (NEWID(), 'def') GO*/

DELETE FROM OrderTripPair;

DELETE FROM Trips;
DELETE FROM Drivers;
DELETE FROM Cars;

DELETE FROM OrderGoodsPair;

DELETE FROM Goods;
DELETE FROM Orders;

DELETE FROM Clients;
DELETE FROM Cities;
DELETE FROM Regions;

DELETE FROM Dues;
DELETE FROM Countries;


SET IDENTITY_INSERT Cars OFF;
SET IDENTITY_INSERT Drivers OFF;
SET IDENTITY_INSERT Countries OFF;
SET IDENTITY_INSERT Regions OFF;
SET IDENTITY_INSERT Cities OFF;
SET IDENTITY_INSERT Clients OFF;
SET IDENTITY_INSERT Orders OFF;
SET IDENTITY_INSERT Goods OFF;
SET IDENTITY_INSERT Trips OFF;


--TRUNCATE TABLE Cars;

SET IDENTITY_INSERT Cars ON
INSERT Cars
	(car_id, car_model, color, car_type, weight, transportation_coefficient, travel_costs_per_kilometre, total_run)
VALUES
	(1, 'МАН', 'желтый', 'грузовик', 15.1, 7.98, 321.5, 1000.4),
	(2, 'КамАЗ', 'оранжевый', 'грузовик', 9.8, 5.501, 356.6, 9999.99),
	(3, 'Merida', 'красный', 'велосипед', 0.030, 1, 20.2, 0);
SET IDENTITY_INSERT Cars OFF


SET IDENTITY_INSERT Drivers ON
INSERT Drivers
	(driver_id, passport_number, first_name, last_name, insurance_number, experience, driver_licence_number, driver_licence_category)
VALUES
	(1, 1310111111, 'Иван', 'Иванов', 123456789, 30, 1876543210, 'C1E'),
	(2, 1310777777, 'Равшан', 'Гость-из-Средней-Азии', 000000000, 0, 0000000000, 'A'),
	(3, 1116233334533, 'Максим', 'Ш', 111111111, 1, 0000000001, 'B, C, D');
SET IDENTITY_INSERT Drivers OFF


SET IDENTITY_INSERT Countries ON
INSERT Countries
	(country_id, country_name)
VALUES
	(1, 'Россия'), (2, 'США'), (3, 'Германия'), (4, 'Великобритания'), (5, 'Китай'), 
	(6, 'Испания'), (7, 'Италия'), (8, 'Казахстан'), (9, 'Беларусь'), (10, 'Армения');
SET IDENTITY_INSERT Countries OFF


INSERT Dues
VALUES
	(1, 2, 101), (1, 3, 50), (3, 4, 0), (4, 3, 0), (3, 6, 0), 
	(6, 3, 0), (4, 6, 0), (6, 4, 0), (2, 7, 10), (1, 4, 90), 
	(4, 1, 70), (1, 7, 40), (1, 6, 55), (7, 1, 40), (6, 1, 55);
	

SET IDENTITY_INSERT Regions ON
INSERT Regions
	(region_id, country_id, region_name)
VALUES
	(1, 1, 'Саратовская область'), (2, 1, 'Московская область'), (3, 1, 'Москва'), (4, 1, 'Санкт-Петербург'), 
	(5, 2, 'Орегон'), (6, 2, 'Вермонт'), (7, 4, 'Кент'), (8, 5, 'Сычуань'), (9, 7, 'Лацио'), (10, 7, 'Неаполь'), (11, 6, 'Каталония');
SET IDENTITY_INSERT Regions OFF


SET IDENTITY_INSERT Cities ON
INSERT Cities
	(city_id, city_name, region_id, country_id)
VALUES
	(1, 'Москва', 3, 1), (2, 'Саратов', 1, 1), (3, 'Санкт-Петербург', 4, 1), (4, 'Рим', 9, 7), (5, 'Барселона', 11, 6);
SET IDENTITY_INSERT Cities OFF


SET IDENTITY_INSERT Clients ON
INSERT Clients
	(client_id, first_name, last_name, address, gender, age)
VALUES
	(1, 'Вася', 'Пупкин', 1, 'Мужской', 35),
	(2, 'Петр','Первый', 3, 'Мужской', 344),
	(3, 'Лионель','Месси', 5, 'Мужской', 29),
	(4, 'Михаил', 'Мирзаянов', 2, 'Мужской', 34),
	(5, 'Сидорова','Виолетта', 2,'Женский', 25);
SET IDENTITY_INSERT Clients OFF


SET IDENTITY_INSERT Orders ON
INSERT Orders
	(order_id, client_id, destination_city_id, ship_from_city_id, order_status, profit)
VALUES
	(1, 1, 2, 1, 'выполняется', 1000),
	(2, 2, 3, 1, 'исполнен', 12345),
	(3, 3, 5, 4, 'выполняется', 505050),
	(4, 4, 2, 1, 'исполнен', 1500),
	(5, 4, 2, 3, 'выполняется', 2400);
SET IDENTITY_INSERT Orders OFF


SET IDENTITY_INSERT Goods ON
INSERT Goods
	(goods_id, name, decription, transportation_cost_per_unit_weight, type)
VALUES
	(1, 'Kingston KVR16S11S8/4', 'Модуль памяти', 1.95, 'Хрупкий'), 
	(2, 'Беговая дорожка Kettler Track 3', 'Беговая дорожка', 63.9, 'Хрупкий'),
	(3, 'Царь-пушка', 'Пушка', 456, 'Опасный'),
	(4, 'Кубок чемпиона', 'Кубок', 77, 'Особо опасный'),
	(5, 'Sony PlayStation 4', 'Игровая приставка', 12, 'Хрупкий');
SET IDENTITY_INSERT Goods OFF


INSERT OrderGoodsPair
	(order_id, goods_id, amount, weight)
VALUES
	(1, 5, 18, 50.4),
	(2, 3, 1, 39.31),
	(3, 4, 1, 9.6),
	(4, 1, 100, 20),
	(5, 1, 33, 6.6);


SET IDENTITY_INSERT Trips ON
INSERT Trips
	(trip_id, driver_id, car_id, start_time, end_time, distance)
VALUES
	(1, 3, 2, '2016-12-04', '9999-12-31', 1000),
	(2, 1, 2, '1704-07-17', '1705-05-09', 700),
	(3, 2, 3, '2016-02-28', '9999-12-31', 10000.72),
	(4, 1, 3, '2017-03-01', '2017-03-03', 990),
	(5, 3, 1, '2017-03-07', '9999-12-31', 3100);
SET IDENTITY_INSERT Trips OFF


INSERT OrderTripPair
	(trip_id, order_id)
VALUES
	(1, 1), (2, 2), (3, 3), (4, 4), (5, 5);