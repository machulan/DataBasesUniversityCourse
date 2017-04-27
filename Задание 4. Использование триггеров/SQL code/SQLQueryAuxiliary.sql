SELECT * FROM Cities

--SELECT rs.region_id FROM Regions rs

SELECT rs.region_id, rs.region_name, rs.country_id FROM Regions rs



SET IDENTITY_INSERT Countries ON
INSERT Countries
	(country_id, country_name)
VALUES
	(1, 'Россия'), (2, 'США'), (3, 'Германия'), (4, 'Великобритания'), (5, 'Китай'), 
	(6, 'Испания'), (7, 'Италия'), (8, 'Казахстан'), (9, 'Беларусь'), (10, 'Армения');
SET IDENTITY_INSERT Countries OFF	

SET IDENTITY_INSERT Regions ON
INSERT Regions
	(region_id, country_id, region_name)
VALUES
	(1, 1, 'Саратовская область'), (2, 1, 'Московская область'), (3, 1, 'Москва'), (4, 1, 'Санкт-Петербург'), 
	(5, 2, 'Орегон'), (6, 2, 'Вермонт'), (7, 4, 'Кент'), (8, 5, 'Сычуань'), (9, 7, 'Лацио'), (10, 7, 'Неаполь'), (11, 6, 'Каталония');
SET IDENTITY_INSERT Regions OFF


SET IDENTITY_INSERT Cities ON
INSERT Cities
	(city_id, city_name, region_id, country_id)
VALUES
	(6, 'Калькутта', 6, 2);
SET IDENTITY_INSERT Cities OFF

INSERT Cities
	(city_name, region_id, country_id)
VALUES
	('Лондон', 8, 10);

SET IDENTITY_INSERT Cities ON
INSERT Cities
	(city_id, city_name, region_id, country_id)
VALUES
	(7, 'Шанхай', 9, 10);
SET IDENTITY_INSERT Cities OFF