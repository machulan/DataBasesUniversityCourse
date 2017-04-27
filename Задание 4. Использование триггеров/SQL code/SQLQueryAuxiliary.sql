SELECT * FROM Cities

--SELECT rs.region_id FROM Regions rs

SELECT rs.region_id, rs.region_name, rs.country_id FROM Regions rs



SET IDENTITY_INSERT Countries ON
INSERT Countries
	(country_id, country_name)
VALUES
	(1, '������'), (2, '���'), (3, '��������'), (4, '��������������'), (5, '�����'), 
	(6, '�������'), (7, '������'), (8, '���������'), (9, '��������'), (10, '�������');
SET IDENTITY_INSERT Countries OFF	

SET IDENTITY_INSERT Regions ON
INSERT Regions
	(region_id, country_id, region_name)
VALUES
	(1, 1, '����������� �������'), (2, 1, '���������� �������'), (3, 1, '������'), (4, 1, '�����-���������'), 
	(5, 2, '������'), (6, 2, '�������'), (7, 4, '����'), (8, 5, '�������'), (9, 7, '�����'), (10, 7, '�������'), (11, 6, '���������');
SET IDENTITY_INSERT Regions OFF


SET IDENTITY_INSERT Cities ON
INSERT Cities
	(city_id, city_name, region_id, country_id)
VALUES
	(6, '���������', 6, 2);
SET IDENTITY_INSERT Cities OFF

INSERT Cities
	(city_name, region_id, country_id)
VALUES
	('������', 8, 10);

SET IDENTITY_INSERT Cities ON
INSERT Cities
	(city_id, city_name, region_id, country_id)
VALUES
	(7, '������', 9, 10);
SET IDENTITY_INSERT Cities OFF