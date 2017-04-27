----------------------------------------------------------
--������ 1 : �������� �������������
----------------------------------------------------------

DROP VIEW ViewCars1;

CREATE VIEW ViewCars1
WITH ENCRYPTION
AS 
SELECT cs.car_model, cs.car_type, cs.weight
FROM Cars cs
WHERE cs.weight > 12;

SELECT *
FROM ViewCars1;


-- �������� ���� �������������
sp_helptext ViewCars1;

----------------------------------------

DROP VIEW ViewCitiesCountries1;

CREATE VIEW ViewCitiesCountries1
WITH ENCRYPTION
AS 
SELECT cts.city_name, cs.country_name
FROM Cities cts CROSS JOIN Countries cs
WHERE SUBSTRING(cs.country_name, 1, 1) > '�'
WITH CHECK OPTION;

SELECT *
FROM ViewCitiesCountries1;


-- �������� ���� �������������
sp_helptext ViewCitiesCountries1;


----------------------------------------------------------
--������ 2 : �������� ������������ �������������
----------------------------------------------------------


DROP VIEW ViewCities1;

CREATE VIEW ViewCities1
WITH ENCRYPTION
AS 
SELECT cts.city_name, cts.country_id, cts.region_id
FROM Cities cts 
WHERE SUBSTRING(cts.city_name, 1, 1) > '�'
WITH CHECK OPTION;

SELECT *
FROM ViewCities1
ORDER BY city_name;


-- �������� ���� �������������
sp_helptext ViewCities1;


 
--SET IDENTITY_INSERT Cars ON
INSERT INTO ViewCities1
	(city_name, country_id, region_id)--city_id
VALUES
	('��������������', 1, 181);

INSERT INTO ViewCities1
	(city_name, country_id, region_id)--city_id
VALUES
	('�����������', 1, 181);
--SET IDENTITY_INSERT Cars OFF

SELECT * 
FROM Cities cs
WHERE cs.city_name = '��������������';

DELETE Cities
WHERE city_name = '��������������';

SELECT * 
FROM Cities cs
WHERE cs.city_name = '�����������';

DELETE Cities
WHERE city_name = '�����������';


--------------------------------------------
SELECT COUNT(*)
FROM Cities;

SELECT TOP 5 ctrs.country_id, ctrs.country_name
FROM Countries ctrs;

SELECT rs.region_name
FROM Regions rs
WHERE rs.region_id = 181;

----------------------------------------------------------
--������ 3 : �������� ���������������� �������������
----------------------------------------------------------

--��������� ��� ��������� ��������������� �������������
SET NUMERIC_ROUNDABORT OFF;
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON;

-- ������� ������������� � ��������� � ����� (��������� ����� WITH SCHEMABINDING)
DROP View IndexedViewCities1;

CREATE VIEW IndexedViewCities1
WITH SCHEMABINDING, ENCRYPTION
AS
SELECT --DISTINCT
	cts.city_id, cts.city_name, rs.region_id, rs.country_id
FROM dbo.Cities AS cts --WITH (NOEXPAND) 
JOIN dbo.Regions AS rs --WITH (NOEXPAND)
	ON cts.region_id = rs.region_id
WHERE SUBSTRING(cts.city_name, 1, 1) > '�';

-- �������� ���� �������������
sp_helptext IndexedViewCities1;

------------------------------------------------

SELECT ivc.city_name, COUNT(*) AS cnt
FROM dbo.IndexedViewCities1 AS ivc --WITH (NOEXPAND) -- ���� ������� � � ���
--WHERE ivc.city_name = '����������'
GROUP BY ivc.city_name
ORDER BY cnt DESC;

SELECT *
FROM IndexedViewCities1 ivc --WITH (NOEXPAND) 
--WHERE ivc.city_name = '��������'
--ORDER BY ivc.city_name;

---������ ������������� IndexedViewCities1
SELECT --DISTINCT
	cts.city_id, cts.city_name, rs.region_id, rs.country_id
FROM dbo.Cities AS cts --WITH (NOEXPAND) 
JOIN dbo.Regions AS rs --WITH (NOEXPAND)
	ON cts.region_id = rs.region_id
WHERE SUBSTRING(cts.city_name, 1, 1) > '�';


----------------------------------------------------
-- �������� ����������� ������� ��� �������������

DROP INDEX IndexedViewCities1_ClusteredIndex ON IndexedViewCities1;

CREATE UNIQUE CLUSTERED INDEX IndexedViewCities1_ClusteredIndex
ON IndexedViewCities1(city_id, city_name, region_id, country_id);

