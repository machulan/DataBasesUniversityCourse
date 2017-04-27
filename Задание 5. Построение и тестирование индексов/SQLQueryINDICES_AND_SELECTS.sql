SET STATISTICS IO ON 
SET STATISTICS TIME ON


/*SELECT ds.duty_value
FROM Dues ds
WHERE ds.destination_country_id = 45

CREATE NONCLUSTERED INDEX IX_Dues
ON Dues(duty_value)*/

--DROP INDEX IX_Dues ON Dues


--��������� ������

--1

SELECT ogp.goods_id, ogp.amount
FROM OrderGoodsPair ogp
WHERE ogp.amount < 1000

CREATE NONCLUSTERED INDEX NoCL_OrderGoodsPair
ON OrderGoodsPair(goods_id, amount)

DROP INDEX NoCL_OrderGoodsPair ON OrderGoodsPair

--2

SELECT 
	cts.city_name '�����',
	rs.region_name '������'
FROM 
	Cities cts
	INNER JOIN Regions rs ON cts.region_id = rs.region_id
WHERE SUBSTRING(cts.city_name, 1, 1) > '�'

CREATE NONCLUSTERED INDEX NoCL_Cities
ON Cities(region_id, city_name)

DROP INDEX NoCL_Cities ON Cities


--����������� ������

SELECT *
FROM Clients cls
WHERE cls.first_name = '���������'

CREATE NONCLUSTERED INDEX IX_Clients
ON Clients(last_name)
INCLUDE(address, first_name, age, gender, client_id)

DROP INDEX IX_Clients ON Clients


--���������� ������

SELECT ds.driver_licence_number
FROM Drivers ds
WHERE ds.driver_licence_number > 5555555555


CREATE UNIQUE INDEX IX_Drivers
ON Drivers(passport_number, insurance_number, driver_licence_number)

DROP INDEX IX_Drivers ON Drivers


--������ � ����������� ���������

SELECT start_time, end_time, distance
FROM Trips ts
WHERE ts.start_time > '2010-10-08'

CREATE NONCLUSTERED INDEX IX_Trips
ON Trips(start_time, end_time)
INCLUDE(distance)

DROP INDEX IX_Trips ON Trips

--������������� ������

SELECT os.order_id
FROM Orders os
WHERE destination_city_id > 50 AND order_status = '��������'

CREATE NONCLUSTERED INDEX IX_Orders
ON Orders(order_status, destination_city_id, ship_from_city_id)
WHERE destination_city_id > 2

DROP INDEX IX_Orders ON Orders





SELECT 
	cts.city_name '�����',
	rs.region_name '������',
	ctrs.country_name '������'
FROM 
	Cities cts
	INNER JOIN Regions rs ON cts.region_id = rs.region_id
	INNER JOIN Countries ctrs ON rs.country_id = ctrs.country_id
WHERE SUBSTRING(cts.city_name, 1, 1) > '�'

SELECT
	IIF(SUBSTRING('����', 1, 1) <> '�', '������', '������')

CREATE NONCLUSTERED INDEX NoCL_Regions
ON Regions(region_id, country_id)

DROP INDEX NoCL_Regions ON Regions

CREATE NONCLUSTERED INDEX NoCL_Cities
ON Cities(region_id, country_id)

DROP INDEX NoCL_Cities ON Cities

--����������� ������

CREATE NONCLUSTERED INDEX IX_exams
ON Exams (GroupID)
INCLUDE (SubjectID, TeacherID, ExamDate, Classroom)


--���������� ������
CREATE UNIQUE INDEX IX_name
ON TableName (col1, col2)



SELECT 
	cts.city_name '�����',
	rs.region_name '������',
	ctrs.country_name '������'
FROM 
	Cities cts
	INNER JOIN Regions rs ON cts.region_id = rs.region_id
	INNER JOIN Countries ctrs ON rs.country_id = ctrs.country_id
WHERE SUBSTRING(ctrs.country_name, 1, 1) > '�'

CREATE NONCLUSTERED INDEX Unique_Cities
ON Cities(city_id, region_id, country_id)

DROP INDEX Unique_Cities ON Cities


CREATE UNIQUE INDEX NoCL_Regions
ON Regions(region_id, region_name)

DROP INDEX NoCL_Regions ON Regions