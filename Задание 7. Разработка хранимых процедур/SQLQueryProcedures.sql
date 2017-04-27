/*
{CREATE | ALTER } PROC[EDURE] им€_процедуры [;номер]
[{@им€_параметра тип_данных } [VARYING ] [=DEFAULT][OUTPUT] ][,...n]
[WITH { RECOMPILE | ENCRYPTION | RECOMPILE,
ENCRYPTION }]
[FOR REPLICATION]
AS
sql_оператор [...n]
*/
/*
ƒл€ выполнени€ хранимой процедуры используетс€ команда:
[[ EXEC [ UTE] им€_процедуры [;номер]
[[@им€_параметра=]{значение | @им€_переменной}
[OUTPUT ]|[DEFAULT ]][,...n]
*/
--DROP PROCEDURE {им€_процедуры} [,...n]
----------------------------------------------------------------
--процедура подсчета количества различных марок автомобилей
--процедура подсчета количества автомобилей заданной марки




--процедура подсчета количества различных марок автомобилей
CREATE PROCEDURE CountDifferentCars
AS
SELECT COUNT(DISTINCT cs.car_model)
FROM Cars AS cs;
--удаление
IF OBJECT_ID ( 'dbo.CountDifferentCars', 'P' ) IS NOT NULL
	DROP PROCEDURE CountDifferentCars;
--запуск
EXECUTE CountDifferentCars;


----------------------------------------------------------------
--процедура подсчета количества автомобилей заданной марки
CREATE PROCEDURE CountCarsOfBrand @CarBrand nvarchar(255)
AS
SELECT COUNT(cs.car_model) 
FROM Cars AS cs
WHERE cs.car_model = @CarBrand
--удаление
IF OBJECT_ID ( 'dbo.CountCarsOfBrand', 'P' ) IS NOT NULL
	DROP PROCEDURE CountCarsOfBrand;
--запуск
EXECUTE CountCarsOfBrand N'MAN TGX'


SELECT DISTINCT cs.car_model FROM Cars cs;

----------------------------------------------------------------
----------------------------------------------------------------
--процедура подсчета количества километров в пути (DriverID, Result OUTPUT)
--процедура, возвращающа€ множество четверок "id водител€, им€ водител€, фамили€ водител€, количество проезженных километров" (DriversCursor OUTPUT)
--процедура расчета прибыли за заданный период (begin, end, Result OUTPUT)
--процедура расчета затрат на развитие предпри€ти€ за период (begin, end, Cost OUTPUT)
--получение доходов предпри€ти€ по годам за все врем€ (ResultCurcor OUTPUT)
----------------------------------------------------------------
----------------------------------------------------------------
--процедура подсчета количества километров в пути
CREATE PROCEDURE NumberOfKilometersTraveled @DriverID BIGINT, @Result FLOAT OUTPUT
AS
IF (SELECT COUNT(*) FROM Drivers ds WHERE ds.driver_id = @DriverID) = 0
BEGIN
	SET @Result = 0
	RETURN
END
ELSE
BEGIN
	SELECT @Result = SUM(ts.distance)
	FROM Drivers ds
	INNER JOIN Trips ts ON ds.driver_id = ts.driver_id
	WHERE ds.driver_id = @DriverID
	--PRINT @Result
	RETURN 3
END;
--удаление
DROP PROCEDURE NumberOfKilometersTraveled;
--запуск
DECLARE @Number FLOAT
DECLARE @ReturnStatus INT
EXECUTE @ReturnStatus = NumberOfKilometersTraveled 1, @Result = @Number OUTPUT;
PRINT @Number;
--SELECT @Number, @ReturnStatus;

----------------------------------------------------------------
--процедура, возвращающа€ множество четверок "id водител€, им€ водител€, фамили€ водител€, количество проезженных километров"
CREATE PROCEDURE GetDriverPathLengthPairs @DriversCursor CURSOR VARYING OUTPUT
AS
SET NOCOUNT ON;
DECLARE @Number FLOAT
--EXECUTE NumberOfKilometersTraveled 1, @Result = @Number OUTPUT;
/*DECLARE @i INT = 0
WHILE(@i < 5)
BEGIN
	SELECT *
	EXECUTE NumberOfKilometersTraveled 1, @Result = @Number OUTPUT;
	SET @i = @i + 1
END*/
/*	SELECT SUM(ts.distance)
	FROM Drivers ds
	INNER JOIN Trips ts ON ds.driver_id = ts.driver_id
	WHERE ds.driver_id = @DriverID*/

SET @DriversCursor = CURSOR 
FORWARD_ONLY STATIC FOR
	--SELECT ds.driver_id, ds.first_name, ds.last_name, (NumberOfKilometersTraveled ds.driver_id)
	SELECT ds.driver_id, ds.first_name, ds.last_name, SUM(ts.distance)
	FROM 
	Drivers ds
	INNER JOIN Trips ts ON ds.driver_id = ts.driver_id
	GROUP BY ds.driver_id, ds.first_name, ds.last_name
OPEN @DriversCursor;

----TEMP
--SELECT ds.first_name, ds.last_name
--FROM Drivers ds
--WHERE ds.driver_id = 21
----



--удаление
DROP PROCEDURE GetDriverPathLengthPairs

--запуск
DECLARE @ResultCursor CURSOR;
EXECUTE GetDriverPathLengthPairs @DriversCursor = @ResultCursor OUTPUT;
DECLARE @driver_id bigint, @first_name nvarchar(255), @last_name nvarchar(255), @num FLOAT
FETCH NEXT FROM @ResultCursor INTO @driver_id, @first_name, @last_name, @num
WHILE (@@FETCH_STATUS = 0)
BEGIN
	PRINT CONCAT('ID: ', @driver_id, ', им€: ', @first_name, ', фамили€: ', @last_name, ', количество проезженных километров: ', @num)
	--PRINT 'AAAAAAAAAAAA'
	--PRINT @num
	--PRINT 'BBBBBBBBBBBBB'
	FETCH NEXT FROM @ResultCursor INTO @driver_id, @first_name, @last_name, @num
END
CLOSE @ResultCursor
DEALLOCATE @ResultCursor
GO


----------------------------------------------------------------
--процедура расчета прибыли за заданный период
CREATE PROCEDURE GetProfitOnPeriod @begin DATE, @end DATE, @Result FLOAT OUTPUT
AS
IF (SELECT COUNT(*)
	FROM 
	(SELECT os.order_id--, MAX(ts.end_time)
	FROM Orders os
	INNER JOIN OrderTripPair otp ON os.order_id = otp.order_id
	INNER JOIN Trips ts ON otp.trip_id = ts.trip_id
	GROUP BY os.order_id
	HAVING @begin <= MAX(ts.end_time) AND MAX(ts.end_time) <= @end) AS os2) = 0
BEGIN 
	SET @Result = 0
	PRINT 'Ќет заказов за этот период'
END
ELSE
BEGIN
	SELECT @Result = SUM(os3.profit)
	FROM 
		((SELECT os.order_id--, MAX(ts.end_time)
		FROM Orders os
		INNER JOIN OrderTripPair otp ON os.order_id = otp.order_id
		INNER JOIN Trips ts ON otp.trip_id = ts.trip_id
		GROUP BY os.order_id
		--HAVING CONVERT(date,'12.03.2015',104) <= MAX(ts.end_time) AND MAX(ts.end_time) <= CONVERT(date,'20.03.2015',104)) AS os2
		HAVING @begin <= MAX(ts.end_time) AND MAX(ts.end_time) <= @end) AS os2
		INNER JOIN Orders AS os3 ON os2.order_id = os3.order_id)
END

--удаление
DROP PROCEDURE GetProfitOnPeriod

--запуск
DECLARE @SumProfit FLOAT
DECLARE @ReturnStatus INT
DECLARE @Begin DATE = CONVERT(date,'12.03.2015',104)
DECLARE @End DATE = CONVERT(date,'12.04.2015',104)

EXECUTE @ReturnStatus = GetProfitOnPeriod @Begin, @End, @Result = @SumProfit OUTPUT;
PRINT @SumProfit;

----------------------------------------------------------------
--CREATE PROCEDURE GetDriverCharacteristics @

--процедура расчета затрат на развитие предпри€ти€ за период
CREATE PROCEDURE CountCostOnCompanyDevelopment @begin DATE, @end DATE, @Cost FLOAT OUTPUT
AS
DECLARE @SumProfit FLOAT
EXECUTE GetProfitOnPeriod @Begin, @End, @Result = @SumProfit OUTPUT
SELECT @Cost = @SumProfit * 0.2

--удаление
DROP PROCEDURE CountCostOnCompanyDevelopment

--запуск
DECLARE @CostOnCompanyDevelopment FLOAT;
DECLARE @Begin DATE = CONVERT(date,'12.03.2015',104);
DECLARE @End DATE = CONVERT(date,'13.03.2015',104);

EXECUTE CountCostOnCompanyDevelopment @Begin, @End, @Cost = @CostOnCompanyDevelopment OUTPUT;
PRINT @CostOnCompanyDevelopment;

----------------------------------------------------------------
--получение доходов предпри€ти€ по годам за все врем€

CREATE PROCEDURE YearProfitStatistics @ResultCursor CURSOR VARYING OUTPUT
AS
SET NOCOUNT ON;
SET @ResultCursor = CURSOR 
FORWARD_ONLY STATIC FOR
	SELECT DATEPART(year,ts.end_time), SUM(os.profit)
	FROM Orders os
	INNER JOIN OrderTripPair otp ON os.order_id = otp.order_id
	INNER JOIN Trips ts ON otp.trip_id = ts.trip_id
	GROUP BY DATEPART(year,ts.end_time)
	ORDER BY DATEPART(year,ts.end_time)
OPEN @ResultCursor;

--удаление процедуры
DROP PROCEDURE YearProfitStatistics;

--запуск
DECLARE @YearProfitStatisticsCursor CURSOR;
EXECUTE YearProfitStatistics @ResultCursor = @YearProfitStatisticsCursor OUTPUT;
DECLARE @year BIGINT, @profit FLOAT, @prev_profit FLOAT = 0
FETCH NEXT FROM @YearProfitStatisticsCursor INTO @year, @profit
WHILE (@@FETCH_STATUS = 0)
BEGIN
	PRINT CONCAT('√од: ', @year, ', ƒоход: ', CONVERT(bigint, @profit), 
	', јбсолютный рост: ', CONVERT(bigint, @profit) - CONVERT(bigint, @prev_profit), 
	', ќтносительный рост: ',  IIF(@prev_profit = 0, 100, (CONVERT(bigint, @profit) - CONVERT(bigint, @prev_profit)) / @prev_profit * 100), '%')
	SET @prev_profit = @profit
	FETCH NEXT FROM @YearProfitStatisticsCursor INTO @year, @profit
END
CLOSE @YearProfitStatisticsCursor
DEALLOCATE @YearProfitStatisticsCursor
GO


/*
SELECT DISTINCT DATEPART(year,ts.end_time)
FROM Trips ts
ORDER BY DATEPART(year,ts.end_time)
*/

----------------------------------------------------------------

/*DECLARE @i INT = 0
WHILE @i < 5
BEGIN
	PRINT @i
	SET @i = @i + 1
END*/

--SELECT ts.distance


SELECT SUM(ts.distance)
FROM Drivers ds
INNER JOIN Trips ts ON ds.driver_id = ts.driver_id
WHERE ds.driver_id = 1


SELECT COUNT(*)
FROM Drivers

SELECT DISTINCT ds.first_name
FROM Drivers ds

SELECT ds.last_name
FROM Drivers ds
--WHERE ds.first_name = 'Ќикита'
WHERE ds.driver_id = 1
