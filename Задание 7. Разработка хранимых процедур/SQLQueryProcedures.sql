/*
{CREATE | ALTER } PROC[EDURE] ���_��������� [;�����]
[{@���_��������� ���_������ } [VARYING ] [=DEFAULT][OUTPUT] ][,...n]
[WITH { RECOMPILE | ENCRYPTION | RECOMPILE,
ENCRYPTION }]
[FOR REPLICATION]
AS
sql_�������� [...n]
*/
/*
��� ���������� �������� ��������� ������������ �������:
[[ EXEC [ UTE] ���_��������� [;�����]
[[@���_���������=]{�������� | @���_����������}
[OUTPUT ]|[DEFAULT ]][,...n]
*/
--DROP PROCEDURE {���_���������} [,...n]
----------------------------------------------------------------
--��������� �������� ���������� ��������� ����� �����������
--��������� �������� ���������� ����������� �������� �����




--��������� �������� ���������� ��������� ����� �����������
CREATE PROCEDURE CountDifferentCars
AS
SELECT COUNT(DISTINCT cs.car_model)
FROM Cars AS cs;
--��������
IF OBJECT_ID ( 'dbo.CountDifferentCars', 'P' ) IS NOT NULL
	DROP PROCEDURE CountDifferentCars;
--������
EXECUTE CountDifferentCars;


----------------------------------------------------------------
--��������� �������� ���������� ����������� �������� �����
CREATE PROCEDURE CountCarsOfBrand @CarBrand nvarchar(255)
AS
SELECT COUNT(cs.car_model) 
FROM Cars AS cs
WHERE cs.car_model = @CarBrand
--��������
IF OBJECT_ID ( 'dbo.CountCarsOfBrand', 'P' ) IS NOT NULL
	DROP PROCEDURE CountCarsOfBrand;
--������
EXECUTE CountCarsOfBrand N'MAN TGX'


SELECT DISTINCT cs.car_model FROM Cars cs;

----------------------------------------------------------------
----------------------------------------------------------------
--��������� �������� ���������� ���������� � ���� (DriverID, Result OUTPUT)
--���������, ������������ ��������� �������� "id ��������, ��� ��������, ������� ��������, ���������� ����������� ����������" (DriversCursor OUTPUT)
--��������� ������� ������� �� �������� ������ (begin, end, Result OUTPUT)
--��������� ������� ������ �� �������� ����������� �� ������ (begin, end, Cost OUTPUT)
--��������� ������� ����������� �� ����� �� ��� ����� (ResultCurcor OUTPUT)
----------------------------------------------------------------
----------------------------------------------------------------
--��������� �������� ���������� ���������� � ����
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
--��������
DROP PROCEDURE NumberOfKilometersTraveled;
--������
DECLARE @Number FLOAT
DECLARE @ReturnStatus INT
EXECUTE @ReturnStatus = NumberOfKilometersTraveled 1, @Result = @Number OUTPUT;
PRINT @Number;
--SELECT @Number, @ReturnStatus;

----------------------------------------------------------------
--���������, ������������ ��������� �������� "id ��������, ��� ��������, ������� ��������, ���������� ����������� ����������"
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



--��������
DROP PROCEDURE GetDriverPathLengthPairs

--������
DECLARE @ResultCursor CURSOR;
EXECUTE GetDriverPathLengthPairs @DriversCursor = @ResultCursor OUTPUT;
DECLARE @driver_id bigint, @first_name nvarchar(255), @last_name nvarchar(255), @num FLOAT
FETCH NEXT FROM @ResultCursor INTO @driver_id, @first_name, @last_name, @num
WHILE (@@FETCH_STATUS = 0)
BEGIN
	PRINT CONCAT('ID: ', @driver_id, ', ���: ', @first_name, ', �������: ', @last_name, ', ���������� ����������� ����������: ', @num)
	--PRINT 'AAAAAAAAAAAA'
	--PRINT @num
	--PRINT 'BBBBBBBBBBBBB'
	FETCH NEXT FROM @ResultCursor INTO @driver_id, @first_name, @last_name, @num
END
CLOSE @ResultCursor
DEALLOCATE @ResultCursor
GO


----------------------------------------------------------------
--��������� ������� ������� �� �������� ������
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
	PRINT '��� ������� �� ���� ������'
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

--��������
DROP PROCEDURE GetProfitOnPeriod

--������
DECLARE @SumProfit FLOAT
DECLARE @ReturnStatus INT
DECLARE @Begin DATE = CONVERT(date,'12.03.2015',104)
DECLARE @End DATE = CONVERT(date,'12.04.2015',104)

EXECUTE @ReturnStatus = GetProfitOnPeriod @Begin, @End, @Result = @SumProfit OUTPUT;
PRINT @SumProfit;

----------------------------------------------------------------
--CREATE PROCEDURE GetDriverCharacteristics @

--��������� ������� ������ �� �������� ����������� �� ������
CREATE PROCEDURE CountCostOnCompanyDevelopment @begin DATE, @end DATE, @Cost FLOAT OUTPUT
AS
DECLARE @SumProfit FLOAT
EXECUTE GetProfitOnPeriod @Begin, @End, @Result = @SumProfit OUTPUT
SELECT @Cost = @SumProfit * 0.2

--��������
DROP PROCEDURE CountCostOnCompanyDevelopment

--������
DECLARE @CostOnCompanyDevelopment FLOAT;
DECLARE @Begin DATE = CONVERT(date,'12.03.2015',104);
DECLARE @End DATE = CONVERT(date,'13.03.2015',104);

EXECUTE CountCostOnCompanyDevelopment @Begin, @End, @Cost = @CostOnCompanyDevelopment OUTPUT;
PRINT @CostOnCompanyDevelopment;

----------------------------------------------------------------
--��������� ������� ����������� �� ����� �� ��� �����

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

--�������� ���������
DROP PROCEDURE YearProfitStatistics;

--������
DECLARE @YearProfitStatisticsCursor CURSOR;
EXECUTE YearProfitStatistics @ResultCursor = @YearProfitStatisticsCursor OUTPUT;
DECLARE @year BIGINT, @profit FLOAT, @prev_profit FLOAT = 0
FETCH NEXT FROM @YearProfitStatisticsCursor INTO @year, @profit
WHILE (@@FETCH_STATUS = 0)
BEGIN
	PRINT CONCAT('���: ', @year, ', �����: ', CONVERT(bigint, @profit), 
	', ���������� ����: ', CONVERT(bigint, @profit) - CONVERT(bigint, @prev_profit), 
	', ������������� ����: ',  IIF(@prev_profit = 0, 100, (CONVERT(bigint, @profit) - CONVERT(bigint, @prev_profit)) / @prev_profit * 100), '%')
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
--WHERE ds.first_name = '������'
WHERE ds.driver_id = 1
