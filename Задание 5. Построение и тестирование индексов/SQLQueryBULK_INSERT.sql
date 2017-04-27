--DELETE FROM OrderTripPair;--2000

--DELETE FROM Trips;--5000
--DELETE FROM Drivers;--2000
--DELETE FROM Cars;--2000

--DELETE FROM OrderGoodsPair;--5000

--DELETE FROM Goods;--2000
--DELETE FROM Orders;--2000

--DELETE FROM Clients;--1000
--DELETE FROM Cities;--10000
--DELETE FROM Regions;--760

--DELETE FROM Dues;--8742
--DELETE FROM Countries;--94


/*SET IDENTITY_INSERT Cars ON;
SET IDENTITY_INSERT Drivers ON;
SET IDENTITY_INSERT Countries ON;
SET IDENTITY_INSERT Regions ON;
SET IDENTITY_INSERT Cities ON;
SET IDENTITY_INSERT Clients ON;
SET IDENTITY_INSERT Orders ON;
SET IDENTITY_INSERT Goods ON;
SET IDENTITY_INSERT Trips ON;*/

/*SET IDENTITY_INSERT Cars OFF;
SET IDENTITY_INSERT Drivers OFF;
SET IDENTITY_INSERT Countries OFF;
SET IDENTITY_INSERT Regions OFF;
SET IDENTITY_INSERT Cities OFF;
SET IDENTITY_INSERT Clients OFF;
SET IDENTITY_INSERT Orders OFF;
SET IDENTITY_INSERT Goods OFF;
SET IDENTITY_INSERT Trips OFF;*/

/*DBCC CHECKIDENT (Countries, RESEED, 0);
DBCC CHECKIDENT (Regions, RESEED, 0);
DBCC CHECKIDENT (Cities, RESEED, 0);
DBCC CHECKIDENT (Clients, RESEED, 0);
DBCC CHECKIDENT (Orders, RESEED, 0);
DBCC CHECKIDENT (Goods, RESEED, 0);
DBCC CHECKIDENT (Cars, RESEED, 0);
DBCC CHECKIDENT (Drivers, RESEED, 0);
DBCC CHECKIDENT (Trips, RESEED, 0);*/


--SET IDENTITY_INSERT Cars ON
/*BULK INSERT Cars
FROM 'D:\Универ\Базы данных\Практика\Задание 5. Построение и тестирование индексов\Данные для BULK INSERT\cars.txt'
WITH
(
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n'
);*/
--SET IDENTITY_INSERT Cars OFF


--SET IDENTITY_INSERT Drivers ON
/*BULK INSERT Drivers
FROM 'D:\Универ\Базы данных\Практика\Задание 5. Построение и тестирование индексов\Данные для BULK INSERT\drivers.txt'
WITH
(
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n'
);*/
--SET IDENTITY_INSERT Drivers OFF

/*BULK INSERT Countries
FROM 'D:\Универ\Базы данных\Практика\Задание 5. Построение и тестирование индексов\Данные для BULK INSERT\countries.txt'
WITH
(
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n'
);*/


/*BULK INSERT Dues
FROM 'D:\Универ\Базы данных\Практика\Задание 5. Построение и тестирование индексов\Данные для BULK INSERT\dues.txt'
WITH
(
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n'
);*/

/*BULK INSERT Regions
FROM 'D:\Универ\Базы данных\Практика\Задание 5. Построение и тестирование индексов\Данные для BULK INSERT\regions.txt'
WITH
(
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n'
);*/

/*
BULK INSERT Cities
FROM 'D:\Универ\Базы данных\Практика\Задание 5. Построение и тестирование индексов\Данные для BULK INSERT\cities.txt'
WITH
(
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n'
);*/

/*BULK INSERT Clients
FROM 'D:\Универ\Базы данных\Практика\Задание 5. Построение и тестирование индексов\Данные для BULK INSERT\clients.txt'
WITH
(
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n'
);*/
/*
BULK INSERT Orders
FROM 'D:\Универ\Базы данных\Практика\Задание 5. Построение и тестирование индексов\Данные для BULK INSERT\orders.txt'
WITH
(
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n'
);*/

/*BULK INSERT Goods
FROM 'D:\Универ\Базы данных\Практика\Задание 5. Построение и тестирование индексов\Данные для BULK INSERT\goods.txt'
WITH
(
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n'
);*/

/*
BULK INSERT OrderGoodsPair
FROM 'D:\Универ\Базы данных\Практика\Задание 5. Построение и тестирование индексов\Данные для BULK INSERT\orderGoodsPair.txt'
WITH
(
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n'
);
*/

/*
BULK INSERT Trips
FROM 'D:\Универ\Базы данных\Практика\Задание 5. Построение и тестирование индексов\Данные для BULK INSERT\trips.txt'
WITH
(
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n'
);*/

/*
BULK INSERT OrderTripPair
FROM 'D:\Универ\Базы данных\Практика\Задание 5. Построение и тестирование индексов\Данные для BULK INSERT\orderTripPair.txt'
WITH
(
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n'
);*/