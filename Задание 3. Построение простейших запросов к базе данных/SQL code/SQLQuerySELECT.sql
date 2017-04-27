--/*
SELECT * 
FROM Dues

SELECT * 
FROM OrderGoodsPair

SELECT ds.first_name, ds.last_name 
FROM Drivers AS ds

SELECT DISTINCT cs.gender
FROM Clients AS cs

SELECT DISTINCT os.ship_from_city_id, os.destination_city_id
FROM Orders os

-- ISNULL CONCAT CONVERT CAST AS

SELECT 
	ds.first_name + ' ' + ds.last_name AS ���,
	ISNULL(ds.first_name, '����������� ���') + ' ' + ISNULL(NULL, '����������� �������'),
	CONCAT(ds.driver_licence_category, ' ', ds.driver_licence_number), 
	ds.experience AS '���� (���)',
	CAST(ds.experience AS float) / 100 AS '���� (�����������)',
	ds.experience * 12. AS '���� (�������)',
	ZZ=CONVERT(float, ds.driver_licence_number) / 1.43553 
FROM Drivers AS ds


--COALESCE (expr1, expr2, ..., exprn) - ���������� ������ �� NULL �������� �� ������ ��������.

SELECT COALESCE (p1, p2, p3, p4)	
FROM (SELECT null p1, null p2, duty_value p3, ship_from_country_id p4 FROM Dues WHERE Dues.destination_country_id=1) q

--PERCENT

SELECT TOP 50 PERCENT gs.name, gs.type, gs.transportation_cost_per_unit_weight
FROM Goods AS gs
ORDER BY gs.decription DESC, gs.type ASC


SELECT DISTINCT TOP 3 ogp.goods_id
FROM OrderGoodsPair	ogp


SELECT cs.first_name, cs.age / 2
FROM Clients cs
WHERE NOT (cs.gender='�������' OR cs.client_id<=2)


-- BETWEEN

SELECT Countries.country_id, Countries.country_name 
FROM Countries 
WHERE Countries.country_name BETWEEN '��������' AND '������'


SELECT Countries.country_id, Countries.country_name 
FROM Countries 
WHERE Countries.country_id NOT BETWEEN 3 AND 7

-- IN

SELECT Countries.country_id, Countries.country_name 
FROM Countries 
WHERE Countries.country_id NOT IN (1, 3, 5, 6, 7, 10)


-- LIKE : �����������_������ [NOT] LIKE ������_������(_%) [ESCAPE ����������_������]

SELECT Countries.country_name
FROM Countries
WHERE Countries.country_name LIKE '%��%'
	OR Countries.country_name LIKE '%�'

SELECT Countries.country_name
FROM Countries
WHERE Countries.country_name LIKE '%��__�'

-- LOWER UPPER

SELECT LOWER(country_name)
FROM Countries cs
WHERE UPPER(country_name) LIKE '������'


SELECT UPPER(country_name) '������'
FROM Countries cs
WHERE LOWER(country_name) LIKE '%�'


SELECT
  CONVERT(date,'12.03.2015',104),
  CONVERT(datetime,'2014-11-30 17:20:15',120)

--DATEFROMPARTS

SELECT *
FROM Trips ts
WHERE ts.start_time BETWEEN DATEFROMPARTS(2016,3,20) AND DATEFROMPARTS(2017,3,3)
ORDER BY ts.distance

-- DATEPART

SELECT DATEPART(month,ts.start_time) '�����', DATEPART(weekday,ts.start_time) '���� ������',
	   DATEPART(dayofyear,ts.start_time) '���� � ����', DATEPART(year,ts.start_time) 
FROM Trips ts

-- DATEADD

SELECT DATEADD(day, 3, ts.end_time)--'2007-01-01 13:10:10.1111111')
FROM Trips ts
WHERE DATEPART(year, ts.end_time) <> 9999

-- DATEDIFF

SELECT DATEDIFF(day, ts.start_time, ts.end_time)
FROM Trips ts

-- GETDATE(), SYSDATETIMEOFFSET(), GETUTCDATE()
SELECT CONVERT(time, GETDATE()), CONVERT(time, SYSDATETIMEOFFSET()), GETUTCDATE()

-- CASE

SELECT ds.experience '���� (���)',--ds.first_name, ds.last_name, ds.experience,
	CASE 
		WHEN ds.experience > 1 THEN '���� ������ ����'
		WHEN ds.experience > 0 THEN '���� �� ����'
		ELSE '��� �����'
	END	'��������������'
FROM Drivers ds

--IIF(�������, true_��������, false_��������)
--CASE WHEN ������� THEN true_�������� ELSE false_�������� END

SELECT ds.ship_from_country_id, ds.destination_country_id,
	CASE
		WHEN ds.duty_value = 0 THEN '������������ ��������'
		ELSE '��������� �������'
	END,
	IIF(ds.duty_value=0, '������������ ��������', IIF(ds.duty_value > 70, '������� �������', '��������� �������'))
FROM Dues ds




-- ���������� ������� COUNT, COUNT(DISTINCT), COUNT(COLUMN), SUM(column, expression), AVG, MIN, MAX

SELECT 
	COUNT(*) [����� ���������� �������],
	COUNT(ds.destination_country_id) [����� ���������� ��������� �����-�����������],
	COUNT(DISTINCT ds.destination_country_id) [���������� ��������� �����-�����������],
	MAX(ds.duty_value) [������������ ������ �������],
	MIN(ds.duty_value) [����������� ������ �������],
	SUM(ds.duty_value) [����� ������],
	SUM(ds.duty_value) / COUNT(*) [������� �������],
	AVG(ds.duty_value) [������� �������]
FROM Dues ds
WHERE ds.duty_value >= 29


SELECT 
	COUNT(*) [����� ���������� �������],
	COUNT(ds.destination_country_id) [����� ���������� ��������� �����-�����������],
	COUNT(DISTINCT ds.destination_country_id) [���������� ��������� �����-�����������],
	ISNULL(MAX(ds.duty_value), 0) [������������ ������ �������],
	ISNULL(MIN(ds.duty_value), 0) [����������� ������ �������],
	ISNULL(SUM(ds.duty_value), 0) [����� ������],
	ISNULL(SUM(ds.duty_value) / COUNT(*), 0) [������� �������],
	ISNULL(AVG(ds.duty_value), 0) [������� �������]
FROM Dues ds
WHERE ds.destination_country_id = 100

-- NULLIF (expr1, expr2) ���������� NULL ���� expr1, ���� expr1=expr2, ����� ���������� expr1

SELECT gs.goods_id, gs.name, gs.type,
	ISNULL(NULLIF(gs.type, '�������'), 123) [NULL, ���� �������]
FROM Goods gs


--CHOOSE ( index, val_1, val_2 [, val_n ] )  ���������� val[index] (val_index) (1-����������) 

SELECT cs.car_model, ISNULL(CHOOSE(cs.car_id, '����� �������', '����� ����� �������'), '�� ����� ����...')
FROM Cars cs
ORDER BY cs.weight DESC


--REPLACE ( string_expression , string_pattern , string_replacement ) 

SELECT REPLACE ('abacaba', 'a', 'c')

SELECT country_name, REPLACE(country_name, '��', '��'), REPLACE(country_name, '�', '')
FROM Countries

--SUBSTRING ( expression, start, length ) 

SELECT cs.city_name AS [�����], cs.region_id AS [������], cs.country_id [������], SUBSTRING(cs.city_name, 1, 3) [������ ��� �����]
FROM Cities cs


--STUFF ( character_expression, start, length, replaceWith_expression )  �������� ��������� ������ character_expression ����� length, ������������ � ������� ��� ������� start, �� ������ replaceWith_expression 

SELECT rs.region_name, STUFF(rs.region_name, 4, 5, '***')
FROM Regions rs



--STR ( float_expression [ , length [ , decimal ] ] ) 

SELECT CONVERT(nvarchar, STR(123.4567, 5, 2))

SELECT STR(SUM(CONVERT(float, os.profit * 1.3456789)) / CONVERT(float, COUNT(os.profit)), 10, 3)
FROM Orders os


--UNICODE ( 'ncharacter_expression' )  ���������� ������������� ��������, ��������������� ��������� ������, ��� ������� ������� �������� ���������.
SELECT cs.country_name ������, SUBSTRING(cs.country_name, 1, 1) [������ ������], UNICODE(cs.country_name)
FROM Countries cs


--GROUP BY
--�� ���������, ����� ��������, ��� � ������ ����������� (GROUP BY), � ������� ������� � ����� SELECT:
--�� ����� ������������ ������ �������, ������������� � ����� GROUP BY
--����� ������������ ��������� � ������ �� ����� GROUP BY
--����� ������������ ���������, �.�. ��� �� ������ �� ��������� �����������
--��� ��������� ���� (�� ������������� � ����� GROUP BY) ����� ������������ ������ � ����������� ��������� (COUNT, SUM, MIN, MAX, �)
--�� ����������� ����������� ��� ������� �� ����� GROUP BY � ������ ������� SELECT


SELECT 
	ds.destination_country_id [������-����������], SUM(ds.duty_value) [�����]
FROM Dues ds
GROUP BY ds.destination_country_id


SELECT cs.gender [���], 
	AVG(cs.age) [������� ������� ���������], 
	MIN(cs.age) [����������� ������� ���������], 
	MAX(cs.age) [������������ ������� ���������]
FROM Clients cs
GROUP BY cs.gender
ORDER BY MAX(cs.age) DESC


--HAVING � ��������� ������� ������� � ��������������� ������

SELECT 
	ogp.goods_id [�����],
	SUM(ogp.amount) [����� ���������� ������]
FROM OrderGoodsPair ogp
GROUP BY ogp.goods_id
HAVING SUM(ogp.amount) > 10 OR COUNT(*) > 1



--JOIN-���������� � �������� ��������������� ���������� ������
--����:
--JOIN � �����_������� JOIN ������_������� ON �������_����������			| ������ �� ������, ��� ������� ����������� �������_���������� (1)
--LEFT JOIN � �����_������� LEFT JOIN ������_������� ON �������_����������	| (1) + ��� ������ ����� �������, ��� ����������� ������ �� ������ NULL
--RIGHT JOIN � �����_������� RIGHT JOIN ������_������� ON �������_����������| (1) + ��� ������ ������ �������, ��� ����������� ������ �� ����� NULL
--FULL JOIN � �����_������� FULL JOIN ������_������� ON �������_����������	| (1) + ��� ������ �� ����� � ������ ������ (����������� ������ = NULL)
--CROSS JOIN � �����_������� CROSS JOIN ������_�������						| ��������� ������������ ������
--��������� JOIN ����������� ��������������� ������ ����



SELECT
	CONCAT('����� � ', os1.order_id) [����� ������],
	os1.order_status [������ ������], 
	CONCAT('����� � ', os2.order_id) [����� ����������� ������], 
	os2.order_status [������ ������]
FROM Orders os1
LEFT OUTER JOIN Orders os2 ON os1.order_id = os2.order_id + 1
WHERE os2.order_id IS NOT NULL



SELECT 
	cts.city_name '�����',
	rs.region_name '������',
	ctrs.country_name '������'
FROM 
	Cities cts
	INNER JOIN Regions rs ON cts.region_id = rs.region_id
	INNER JOIN Countries ctrs ON rs.country_id = ctrs.country_id


SELECT 
	cts1.city_name [����� �����������], --rs1.region_name, ctrs1.country_name, ctrs1.country_id, ds1.ship_from_country_id,
 	cts2.city_name [����� ����������], --rs2.region_name, ctrs2.country_name, ctrs2.country_id, ds1.destination_country_id, ds1.duty_value--, ds2.ship_from_country_id, ds2.destination_country_id
	CASE 
		WHEN ds.duty_value IS NOT NULL THEN ds.duty_value
		WHEN ctrs1.country_id = ctrs2.country_id THEN 0
		--ELSE 0
	END [�������]
FROM 
	Cities cts1
	CROSS JOIN Cities cts2
	LEFT OUTER JOIN Regions rs1 ON cts1.region_id = rs1.region_id
	LEFT OUTER JOIN Regions rs2 ON cts2.region_id = rs2.region_id
	LEFT OUTER JOIN Countries ctrs1 ON rs1.country_id = ctrs1.country_id
	LEFT OUTER JOIN Countries ctrs2 ON rs2.country_id = ctrs2.country_id
	LEFT OUTER JOIN Dues ds ON ctrs1.country_id = ds.ship_from_country_id AND ctrs2.country_id = ds.destination_country_id
ORDER BY ISNULL(ds.duty_value, -1) DESC, [����� �����������], [����� ����������]




-- ������������ ����������� : UNION ALL (A + B), UNION (DISTINCT (A + B)), EXCEPT (A - B), INTERSECT (DISTINCT (A & B)) | ����� ������������ ������ ��� �����������
-- WITH : WITH q1 AS(SELECT ... [query1]), q2 AS([query2]) SELECT ... FROM q1 JOIN q2 ON q1.id1 = q2.id2 | ����� ���� ������������ ��������
-- CTE (Common Table Expressions) (����� ��������� ���������)
--������� ������� ������� ��� ������ �� ������ � ��� ����� � ������


--EXISTS ���������� True, ���� ��������� ���������� ���� �� ���� ������, � False, ���� ��������� �� ���������� �����.

SELECT *
FROM Countries ctrs
WHERE EXISTS (SELECT * FROM Cities cts WHERE cts.country_id = ctrs.country_id)


--IN ����� ������������ � �����������, ������� ���������� �������� �������� | NULL ������

SELECT *
FROM Clients cs
WHERE cs.client_id NOT IN (SELECT DISTINCT os.client_id FROM Orders os WHERE os.client_id IS NOT NULL)



-- �������� ���������� ��������� ALL � ANY

SELECT ogp1.order_id, ogp1.goods_id, ogp1.amount, ogp1.weight
FROM OrderGoodsPair ogp1
WHERE ogp1.amount > ALL(
						SELECT ogp2.amount
						FROM OrderGoodsPair ogp2
						WHERE ogp2.goods_id = ogp1.goods_id
							AND ogp1.order_id <> ogp2.order_id
						)

SELECT ogp1.order_id, ogp1.goods_id, ogp1.amount, ogp1.weight
FROM OrderGoodsPair ogp1
WHERE ogp1.amount > ANY(
						SELECT ogp2.amount
						FROM OrderGoodsPair ogp2
						WHERE ogp2.goods_id = ogp1.goods_id
							AND ogp1.order_id <> ogp2.order_id
						)




--CREATE VIEW view_name AS SELECT ... 

--������� ���������� : FROM => WHERE => GROUP BY => HAVING => SELECT => ORDER BY => (DISTINCT?, TOP?)








/*
AND		TRUE	FALSE	NULL
TRUE	TRUE	FALSE	NULL
FALSE	FALSE	FALSE	FALSE	
NULL	NULL	FALSE	NULL
 
OR		TRUE	FALSE	NULL
TRUE	TRUE	TRUE	TRUE
FALSE	TRUE	FALSE	NULL
NULL	TRUE	NULL	NULL

NOT		TRUE	FALSE	NULL
-		FALSE	TRUE	NULL
*/








-- ������� ����������: WHERE => DISTINCT => ORDER BY => TOP


--SELECT 100/99.1, SYSDATETIME()

/*
SELECT [DISTINCT] ������_�������� ��� *
FROM ��������
WHERE ������
ORDER BY ���������_����������	
*/

