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











--TRUNCATE TABLE Cars;

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
	(1310111111, 'Иван', 'Иванов', 123456789, 30, 1876543210, 'C1E'),
	(1310777777, 'Равшан', 'Гость-из-Средней-Азии', 000000000, 0, 0000000000, 'A'),
	(1233334533, 'Максим', 'Ш', 111111111, 1, 0000000000, 'A');
	

INSERT Countries
	(country_name)
VALUES
	('Россия'), ('США'), ('Германия'), ('Великобритания'), ('Китай'), 
	('Испания'), ('Италия'), ('Казахстан'), ('Беларусь'), ('Армения');

INSERT Dues
VALUES
	(1, 2, 101), (1, 3, 50), (3, 4, 0), (4, 3, 0), (3, 6, 0), (6, 3, 0), (4, 6, 0), (6, 4, 0), (2, 7, 10), (1, 4, 90), (4, 1, 70);
	
INSERT Regions
	(country_id, region_name)--(country_id, region_id, region_name)
VALUES
	(1, 'Саратовская область'), (1, 'Московская область'), (1, 'Москва'), (1, 'Санкт-Петербург'), 
	(2, 'Орегон'), (2, 'Вермонт'), (4, 'Кент'), (5, 'Сычуань'), (7, 'Лацио'), (7, 'Неаполь'), (6, 'Каталония');

INSERT Cities
	(city_name, region_id, country_id)
VALUES
	('Москва', 3, 1), ('Саратов', 1, 1), ('Санкт-Петербург', 4, 1), ('Рим', 9, 7), ('Барселона', 11, 6);

INSERT Clients
	(first_name, last_name, address, gender, age)
VALUES
	('Вася', 'Пупкин', 1, 'Мужской', 35),
	('Петр','Первый', 3, 'Мужской', 344),
	('Лионель','Месси', 5, 'Мужской', 29),
	('Михаил', 'Мирзаянов', 2, 'Мужской', 34),
	('Сидорова','Виолетта', 2,'Женский', 25);

INSERT Orders
	(client_id, destination_city_id, ship_from_city_id, order_status, profit)
VALUES
	(1, 2, 1, 'выполняется', 1000),
	(2, 3, 1, 'исполнен', 12345),
	(3, 5, 4, 'выполняется', 505050),
	(4, 2, 2, 'исполнен', 1500),
	(4, 2, 3, 'выполняется', 2400);

INSERT Goods
	(name, decription, transportation_cost_per_unit_weight, type)
VALUES
	('фывв', 'Модуль памяти', 1.95, 'Хрупкий');/*, -- Kingston KVR16S11S8/4
	('Беговая дорожка Kettler Track 3', 'Беговая дорожка', 63.9, 'Хрупкий'),
	('Царь-пушка', 'Пушка', 456, 'Опасный груз'),
	('Кубок чемпиона', 'Кубок', 77, 'Особо опасный груз');*/

--INSERT OrderGoodsPair





	
	



/*
INSERT Trips
	(driver_id, car_id, start_time, end_time, distance)
VALUES
	(1, 1, '2016-02-28','2017-02-28',10000.72);*/