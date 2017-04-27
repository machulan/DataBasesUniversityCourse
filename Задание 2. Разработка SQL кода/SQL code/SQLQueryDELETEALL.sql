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

DBCC CHECKIDENT (Countries, RESEED, 0);
DBCC CHECKIDENT (Regions, RESEED, 0);
DBCC CHECKIDENT (Cities, RESEED, 0);
DBCC CHECKIDENT (Clients, RESEED, 0);
DBCC CHECKIDENT (Orders, RESEED, 0);
DBCC CHECKIDENT (Goods, RESEED, 0);
DBCC CHECKIDENT (Cars, RESEED, 0);
DBCC CHECKIDENT (Drivers, RESEED, 0);
DBCC CHECKIDENT (Trips, RESEED, 0);

