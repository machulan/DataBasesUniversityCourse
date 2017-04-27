/*
CREATE TRIGGER trigger_name ON table_name
WITH ENCRYPTION
{
	FOR 
}

-- @@ROWCOUNT
-- ROLLBACK TRANSACTION для прерывания выполнения триггера и отмены всех изменений, которые пытался выполнить пользователь
-- COLUMN_UPDATED() получение списка столбцов, измененных при выполнении команд INSERT или UPDATE, 
-- вызвавших выполнение триггера (возвращает двоичное число, 1 - столбец был изменен)

--DROP TRIGGER {имя	триггера} [,...n] | удаление триггера

*/

/*
<Определение_триггера>::=
{CREATE | ALTER} TRIGGER имя_триггера
ON {имя_таблицы | имя_представления }
[WITH ENCRYPTION ]
{
{ { FOR | AFTER | INSTEAD OF }
{ [ DELETE] [,] [ INSERT] [,] [ UPDATE] }
[ WITH APPEND ]
[ NOT FOR REPLICATION ]
AS
   sql_оператор[...n]
} |
{ {FOR | AFTER | INSTEAD OF } { [INSERT] [,]
  [UPDATE] }
[ WITH APPEND]
[ NOT FOR REPLICATION]
AS
{ IF UPDATE(имя_столбца)
[ {AND | OR} UPDATE(имя_столбца)] [...n]
|
IF (COLUMNS_UPDATES(){оператор_бит_обработки}
  бит_маска_изменения)
{оператор_бит_сравнения }бит_маска [...n]}
sql_оператор [...n]
}
}
*/

/*
RAISERROR(<выражение_integer>|<’текст сообщения об ошибке’>, [уровень серьезности ошибки] [, номер состояния ошибки])
*/


--Триггер на вставку новых городов

--DROP TRIGGER citiesInsertTrigger

/*CREATE TRIGGER citiesInsertTrigger
ON Cities INSTEAD OF INSERT 
AS
IF @@ROWCOUNT=1
BEGIN
	DECLARE @region_id bigint, @country_id bigint, @city_id bigint, @city_name nvarchar(255)
	SELECT @region_id = inserted.region_id FROM inserted 
	SELECT @country_id = inserted.country_id FROM inserted 
	SELECT @city_id = inserted.city_id FROM inserted
	SELECT @city_name = inserted.city_name FROM inserted
	IF NOT EXISTS 
	(
		SELECT * FROM Regions WHERE Regions.region_id = @region_id
	)
		BEGIN
			ROLLBACK TRANSACTION
			--PRINT 'Какой-то ткст'
			RAISERROR('Попытка добавить город, регион которого отсутствует в базе данных',16,10)
		END
	ELSE 
		BEGIN 
			IF NOT EXISTS
			(
				SELECT * FROM Countries WHERE Countries.country_id = @country_id
			)
				BEGIN
					ROLLBACK TRANSACTION
					--PRINT 'Какой-то ткст'
					RAISERROR('Попытка добавить город, страна которого отсутствует в базе данных',16,10)
				END
			ELSE
				--вставка строки в таблицу
				BEGIN
					SET IDENTITY_INSERT Cities ON
					INSERT Cities
						(city_id, city_name, region_id, country_id)
					VALUES
						(@city_id, @city_name, @region_id, @country_id)
					SET IDENTITY_INSERT Cities OFF
				END
		END
END
*/


--Удалить все триггеры
/*
DROP TRIGGER citiesInsertTrigger --INSTEAD OF
DROP TRIGGER countriesDeleteTrigger --INSTEAD OF
DROP TRIGGER citiesDeleteTrigger --INSTEAD OF
DROP TRIGGER ordersDeleteTrigger --INSTEAD OF
DROP TRIGGER tripsInsertTrigger --AFTER, компенсирующий
DROP TRIGGER ordersUpdateTrigger --INSTEAD OF, компенсирующий
DROP TRIGGER tripsUpdateTrigger -- AFTER, компенсирующий
*/


--Триггер на вставку новых городов

--DROP TRIGGER citiesInsertTrigger

CREATE TRIGGER citiesInsertTrigger
ON Cities INSTEAD OF INSERT 
AS
--Объявление курсора
DECLARE CUR CURSOR FOR
	SELECT ins.city_id, ins.city_name, ins.country_id, ins.region_id FROM inserted ins
OPEN CUR
DECLARE @region_id bigint, @country_id bigint, @city_id bigint, @city_name nvarchar(255)
--обработка всех вставляемых значений
FETCH NEXT FROM CUR INTO @city_id, @city_name, @country_id, @region_id
WHILE @@FETCH_STATUS=0
BEGIN
	IF NOT EXISTS 
	(
		SELECT * FROM Regions WHERE Regions.region_id = @region_id
	)
		BEGIN
			ROLLBACK TRANSACTION
			--PRINT 'Какой-то ткст'
			RAISERROR('Попытка добавить город, регион которого отсутствует в базе данных',16,10)
		END
	ELSE 
		BEGIN 
			IF NOT EXISTS
			(
				SELECT * FROM Countries WHERE Countries.country_id = @country_id
			)
				BEGIN
					ROLLBACK TRANSACTION
					--PRINT 'Какой-то ткст'
					RAISERROR('Попытка добавить город, страна которого отсутствует в базе данных',16,10)
				END
			ELSE
				--вставка строки в таблицу
				BEGIN
					SET IDENTITY_INSERT Cities ON
					INSERT Cities
						(city_id, city_name, region_id, country_id)
					VALUES
						(@city_id, @city_name, @region_id, @country_id)
					SET IDENTITY_INSERT Cities OFF
				END
		END

	FETCH NEXT FROM CUR INTO @city_id, @city_name, @country_id, @region_id
END
CLOSE CUR
DEALLOCATE CUR

/*
SET IDENTITY_INSERT Cities ON
INSERT Cities
	(city_id, city_name, region_id, country_id)
VALUES
	(6, 'Лондон', 20, 10);
SET IDENTITY_INSERT Cities OFF
*/

/*
SET IDENTITY_INSERT Cities ON
INSERT Cities
	(city_id, city_name, region_id, country_id)
VALUES
	(7, 'Шанхай', 9, 10);
SET IDENTITY_INSERT Cities OFF
*/



--Триггер на удаление страны из базы данных

--DROP TRIGGER countriesDeleteTrigger

CREATE TRIGGER countriesDeleteTrigger
ON Countries INSTEAD OF DELETE 
AS 
DECLARE cur CURSOR FOR
	SELECT del.country_id, del.country_name FROM deleted del
OPEN cur
DECLARE @country_id bigint, @country_name nvarchar(255)
--DECLARE @destination_country_id bigint, @ship_from_country_id bigint

FETCH NEXT FROM cur INTO @country_id, @country_name
WHILE @@FETCH_STATUS=0
BEGIN
	DELETE Cities WHERE Cities.country_id = @country_id
	DELETE Regions WHERE Regions.country_id = @country_id
	DELETE Dues WHERE Dues.destination_country_id = @country_id
	DELETE Dues WHERE Dues.ship_from_country_id = @country_id	
	DELETE Countries WHERE Countries.country_id = @country_id

	FETCH NEXT FROM cur INTO @country_id, @country_name	
END
CLOSE cur
DEALLOCATE cur


/*
DELETE Countries WHERE Countries.country_id=1
*/


-- Триггер на удаление города

--DROP TRIGGER citiesDeleteTrigger

CREATE TRIGGER citiesDeleteTrigger
ON Cities INSTEAD OF DELETE
AS
DECLARE deleteCitiesCur CURSOR FOR
	SELECT del.city_id FROM deleted del
OPEN deleteCitiesCur
DECLARE @city_id bigint

FETCH NEXT FROM deleteCitiesCur INTO @city_id
WHILE @@FETCH_STATUS=0
BEGIN
	DELETE Orders WHERE Orders.destination_city_id = @city_id
	DELETE Orders WHERE Orders.ship_from_city_id = @city_id
	DELETE Clients WHERE Clients.address = @city_id
	DELETE Cities WHERE Cities.city_id = @city_id

	FETCH NEXT FROM deleteCitiesCur INTO @city_id
END
CLOSE deleteCitiesCur
DEALLOCATE deleteCitiesCur

/*
DELETE Cities WHERE Cities.city_id=3
*/


-- Триггер на удаление заказа

--DROP TRIGGER ordersDeleteTrigger

CREATE TRIGGER ordersDeleteTrigger
ON Orders INSTEAD OF DELETE
AS
DECLARE delOrdersCur CURSOR FOR
	SELECT del.order_id FROM deleted del
OPEN delOrdersCur
DECLARE @order_id bigint

FETCH NEXT FROM delOrdersCur INTO @order_id
WHILE @@FETCH_STATUS=0
BEGIN
	DELETE OrderGoodsPair WHERE OrderGoodsPair.order_id = @order_id
	DELETE OrderTripPair WHERE OrderTripPair.order_id = @order_id
	DELETE Orders WHERE Orders.order_id = @order_id

	FETCH NEXT FROM delOrdersCur INTO @order_id
END
CLOSE delOrdersCur
DEALLOCATE delOrdersCur

/*
DELETE Countries WHERE Countries.country_id=1
*/


--Триггер на вставку новых рейсов

--DROP TRIGGER tripsInsertTrigger

CREATE TRIGGER tripsInsertTrigger
ON Trips AFTER INSERT  
AS
--Объявление курсора
DECLARE insTripsCur CURSOR FOR
	SELECT ins.trip_id, ins.distance, ins.car_id FROM inserted ins
OPEN insTripsCur
DECLARE @trip_id bigint, @distance float, @car_id bigint
--обработка всех вставляемых значений
FETCH NEXT FROM insTripsCur INTO @trip_id, @distance, @car_id
WHILE @@FETCH_STATUS=0
BEGIN
	--DECLARE @
	IF NOT EXISTS 
	(
		SELECT * FROM Cars WHERE Cars.car_id = @car_id
	)
		BEGIN
			ROLLBACK TRANSACTION
			RAISERROR('Попытка добавить рейс, совершаемый на машине, отсутствующей в базе данных',16,10)
		END
	ELSE 
		BEGIN 
			UPDATE Cars SET Cars.total_run = Cars.total_run + @distance WHERE Cars.car_id = @car_id
		END

	FETCH NEXT FROM insTripsCur INTO @trip_id, @distance, @car_id
END
CLOSE insTripsCur
DEALLOCATE insTripsCur

/*
SET IDENTITY_INSERT Trips ON
INSERT Trips
	(trip_id, driver_id, car_id, start_time, end_time, distance)
VALUES
	(6, 1, 3, '2017-03-15', '2017-04-20', 777);
SET IDENTITY_INSERT Trips OFF


SET IDENTITY_INSERT Trips ON
INSERT Trips
	(trip_id, driver_id, car_id, start_time, end_time, distance)
VALUES
	(9, 2, 2, '2017-03-15', '2017-04-01', 2500);
SET IDENTITY_INSERT Trips OFF
*/


--Триггер на обновление (статуса) заказа 
--количество выполненных заказов соответствующих водителей увеличивается на 1

--DROP TRIGGER ordersUpdateTrigger

CREATE TRIGGER ordersUpdateTrigger
ON Orders INSTEAD OF UPDATE 
AS
--Объявление курсора inserted
DECLARE updOrdersCurInserted CURSOR FOR
	SELECT ins.order_id, ins.order_status FROM inserted ins
--Объявление курсора deleted
DECLARE updOrdersCurDeleted CURSOR FOR
	SELECT del.order_id, del.order_status FROM deleted del
OPEN updOrdersCurInserted
OPEN updOrdersCurDeleted
--объявление вспомогательных переменных
DECLARE @order_id bigint, @order_status nvarchar(255), @order_id_old bigint, @order_status_old nvarchar(255)
--обработка всех обновляемых значений
FETCH NEXT FROM updOrdersCurInserted INTO @order_id, @order_status
FETCH NEXT FROM updOrdersCurDeleted INTO @order_id_old, @order_status_old
WHILE @@FETCH_STATUS=0
BEGIN
	IF (@order_status<>@order_status_old AND @order_status='исполнен')
	BEGIN
		--UPDATE Cars SET Cars.total_run = Cars.total_run + @distance WHERE Cars.car_id = @car_id
		DECLARE chosenDriversCur CURSOR FOR 	
			SELECT Trips.driver_id 
			FROM 
				Trips
				INNER JOIN (SELECT otp.trip_id AS t_id FROM OrderTripPair otp WHERE otp.order_id = @order_id_old) AS chosen_trips
				ON Trips.trip_id = chosen_trips.t_id

		OPEN chosenDriversCur

		DECLARE @chosen_driver_id bigint

		--цикл
		FETCH NEXT FROM chosenDriversCur INTO @chosen_driver_id
		WHILE @@FETCH_STATUS=0
		BEGIN
			UPDATE Drivers
			SET Drivers.experience = Drivers.experience + 1
			WHERE Drivers.driver_id = @chosen_driver_id

			FETCH NEXT FROM chosenDriversCur INTO @chosen_driver_id
		END
		--освобождение курсора
		CLOSE chosenDriversCur
		DEALLOCATE chosenDriversCur
	END

	FETCH NEXT FROM updOrdersCurInserted INTO @order_id, @order_status
	FETCH NEXT FROM updOrdersCurDeleted INTO @order_id_old, @order_status_old
END
CLOSE updOrdersCurInserted
CLOSE updOrdersCurDeleted
DEALLOCATE updOrdersCurInserted
DEALLOCATE updOrdersCurDeleted

/*
UPDATE Orders SET Orders.order_status = 'исполнен' WHERE Orders.order_id = 1
*/




--Триггер на обновление (протяженности, км) рейса
--пробег автомобиля, занятого в рейсе, увеличивается на разность текущего и предыдущего значений

--DROP TRIGGER tripsUpdateTrigger

CREATE TRIGGER tripsUpdateTrigger
ON Trips AFTER UPDATE 
AS
--Объявление курсора inserted
DECLARE updTripsCurInserted CURSOR FOR
	SELECT ins.trip_id, ins.distance, ins.car_id FROM inserted ins
--Объявление курсора deleted
DECLARE updTripsCurDeleted CURSOR FOR
	SELECT del.trip_id, del.distance, del.car_id FROM deleted del
OPEN updTripsCurInserted
OPEN updTripsCurDeleted
--объявление вспомогательных переменных
DECLARE @trip_id bigint, @distance float, @car_id bigint, @trip_id_old bigint, @distance_old float, @car_id_old bigint
--обработка всех вставляемых значений
FETCH NEXT FROM updTripsCurInserted INTO @trip_id, @distance, @car_id
FETCH NEXT FROM updTripsCurDeleted INTO @trip_id_old, @distance_old, @car_id_old
WHILE @@FETCH_STATUS=0
BEGIN
	IF NOT EXISTS 
	(
		SELECT * FROM Cars WHERE Cars.car_id = @car_id
	) 
		BEGIN
			ROLLBACK TRANSACTION
			RAISERROR('Попытка добавить рейс, совершаемый на машине, отсутствующей в базе данных',16,10)
		END
	ELSE 
		BEGIN 
			IF (@distance < 0)
				BEGIN
					ROLLBACK TRANSACTION
					RAISERROR('Расстояние не может быть отрицательным',16,10)
				END
			ELSE
				BEGIN
					IF (@car_id = @car_id_old)
						BEGIN 
							UPDATE Cars SET Cars.total_run = Cars.total_run + @distance - @distance_old WHERE Cars.car_id = @car_id
						END
					ELSE
						BEGIN
							UPDATE Cars SET Cars.total_run = Cars.total_run - @distance_old WHERE Cars.car_id = @car_id_old
							UPDATE Cars SET Cars.total_run = Cars.total_run + @distance WHERE Cars.car_id = @car_id
						END
				END
		END

	FETCH NEXT FROM updTripsCurInserted INTO @trip_id, @distance, @car_id
	FETCH NEXT FROM updTripsCurDeleted INTO @trip_id_old, @distance_old, @car_id_old
END
CLOSE updTripsCurInserted 
CLOSE updTripsCurDeleted
DEALLOCATE updTripsCurInserted 
DEALLOCATE updTripsCurDeleted


/*
UPDATE Trips SET Trips.distance = 3 WHERE Trips.trip_id = 2
*/




