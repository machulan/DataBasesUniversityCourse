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
	ds.first_name + ' ' + ds.last_name AS ФИО,
	ISNULL(ds.first_name, 'Неизвестное имя') + ' ' + ISNULL(NULL, 'Неизвестная фамилия'),
	CONCAT(ds.driver_licence_category, ' ', ds.driver_licence_number), 
	ds.experience AS 'Опыт (лет)',
	CAST(ds.experience AS float) / 100 AS 'Опыт (десятилетий)',
	ds.experience * 12. AS 'Опыт (месяцев)',
	ZZ=CONVERT(float, ds.driver_licence_number) / 1.43553 
FROM Drivers AS ds


--COALESCE (expr1, expr2, ..., exprn) - Возвращает первое не NULL значение из списка значений.

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
WHERE NOT (cs.gender='Женский' OR cs.client_id<=2)


-- BETWEEN

SELECT Countries.country_id, Countries.country_name 
FROM Countries 
WHERE Countries.country_name BETWEEN 'Германия' AND 'Италия'


SELECT Countries.country_id, Countries.country_name 
FROM Countries 
WHERE Countries.country_id NOT BETWEEN 3 AND 7

-- IN

SELECT Countries.country_id, Countries.country_name 
FROM Countries 
WHERE Countries.country_id NOT IN (1, 3, 5, 6, 7, 10)


-- LIKE : проверяемая_строка [NOT] LIKE строка_шаблон(_%) [ESCAPE отменяющий_символ]

SELECT Countries.country_name
FROM Countries
WHERE Countries.country_name LIKE '%та%'
	OR Countries.country_name LIKE '%А'

SELECT Countries.country_name
FROM Countries
WHERE Countries.country_name LIKE '%та__я'

-- LOWER UPPER

SELECT LOWER(country_name)
FROM Countries cs
WHERE UPPER(country_name) LIKE 'италия'


SELECT UPPER(country_name) 'Страна'
FROM Countries cs
WHERE LOWER(country_name) LIKE '%я'


SELECT
  CONVERT(date,'12.03.2015',104),
  CONVERT(datetime,'2014-11-30 17:20:15',120)

--DATEFROMPARTS

SELECT *
FROM Trips ts
WHERE ts.start_time BETWEEN DATEFROMPARTS(2016,3,20) AND DATEFROMPARTS(2017,3,3)
ORDER BY ts.distance

-- DATEPART

SELECT DATEPART(month,ts.start_time) 'Месяц', DATEPART(weekday,ts.start_time) 'День недели',
	   DATEPART(dayofyear,ts.start_time) 'День в году', DATEPART(year,ts.start_time) 
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

SELECT ds.experience 'Опыт (лет)',--ds.first_name, ds.last_name, ds.experience,
	CASE 
		WHEN ds.experience > 1 THEN 'Опыт больше года'
		WHEN ds.experience > 0 THEN 'Опыт до года'
		ELSE 'Нет опыта'
	END	'Характеристика'
FROM Drivers ds

--IIF(условие, true_значение, false_значение)
--CASE WHEN условие THEN true_значение ELSE false_значение END

SELECT ds.ship_from_country_id, ds.destination_country_id,
	CASE
		WHEN ds.duty_value = 0 THEN 'Беспошлинная торговля'
		ELSE 'Ненулевая пошлина'
	END,
	IIF(ds.duty_value=0, 'Беспошлинная торговля', IIF(ds.duty_value > 70, 'Большая пошлина', 'Небольшая пошлина'))
FROM Dues ds




-- Агрегатные функции COUNT, COUNT(DISTINCT), COUNT(COLUMN), SUM(column, expression), AVG, MIN, MAX

SELECT 
	COUNT(*) [Общее количество записей],
	COUNT(ds.destination_country_id) [Общее количество различных стран-получателей],
	COUNT(DISTINCT ds.destination_country_id) [Количество различных стран-получателей],
	MAX(ds.duty_value) [Максимальный размер пошлины],
	MIN(ds.duty_value) [Минимальный размер пошлины],
	SUM(ds.duty_value) [Сумма пошлин],
	SUM(ds.duty_value) / COUNT(*) [Средняя пошлина],
	AVG(ds.duty_value) [Средняя пошлина]
FROM Dues ds
WHERE ds.duty_value >= 29


SELECT 
	COUNT(*) [Общее количество записей],
	COUNT(ds.destination_country_id) [Общее количество различных стран-получателей],
	COUNT(DISTINCT ds.destination_country_id) [Количество различных стран-получателей],
	ISNULL(MAX(ds.duty_value), 0) [Максимальный размер пошлины],
	ISNULL(MIN(ds.duty_value), 0) [Минимальный размер пошлины],
	ISNULL(SUM(ds.duty_value), 0) [Сумма пошлин],
	ISNULL(SUM(ds.duty_value) / COUNT(*), 0) [Средняя пошлина],
	ISNULL(AVG(ds.duty_value), 0) [Средняя пошлина]
FROM Dues ds
WHERE ds.destination_country_id = 100

-- NULLIF (expr1, expr2) возвращает NULL типа expr1, если expr1=expr2, иначе возвращает expr1

SELECT gs.goods_id, gs.name, gs.type,
	ISNULL(NULLIF(gs.type, 'хрупкий'), 123) [NULL, если хрупкий]
FROM Goods gs


--CHOOSE ( index, val_1, val_2 [, val_n ] )  Возвращает val[index] (val_index) (1-индексация) 

SELECT cs.car_model, ISNULL(CHOOSE(cs.car_id, 'Самый тяжелый', 'Почти самый тяжелый'), 'Не найти слов...')
FROM Cars cs
ORDER BY cs.weight DESC


--REPLACE ( string_expression , string_pattern , string_replacement ) 

SELECT REPLACE ('abacaba', 'a', 'c')

SELECT country_name, REPLACE(country_name, 'та', 'ТА'), REPLACE(country_name, 'И', '')
FROM Countries

--SUBSTRING ( expression, start, length ) 

SELECT cs.city_name AS [Город], cs.region_id AS [Регион], cs.country_id [Страна], SUBSTRING(cs.city_name, 1, 3) [Первые три буквы]
FROM Cities cs


--STUFF ( character_expression, start, length, replaceWith_expression )  Заменяет подстроку строки character_expression длины length, начинающуюся с символа под номером start, на строку replaceWith_expression 

SELECT rs.region_name, STUFF(rs.region_name, 4, 5, '***')
FROM Regions rs



--STR ( float_expression [ , length [ , decimal ] ] ) 

SELECT CONVERT(nvarchar, STR(123.4567, 5, 2))

SELECT STR(SUM(CONVERT(float, os.profit * 1.3456789)) / CONVERT(float, COUNT(os.profit)), 10, 3)
FROM Orders os


--UNICODE ( 'ncharacter_expression' )  Возвращает целочисленное значение, соответствующее стандарту Юникод, для первого символа входного выражения.
SELECT cs.country_name Страна, SUBSTRING(cs.country_name, 1, 1) [Первый символ], UNICODE(cs.country_name)
FROM Countries cs


--GROUP BY
--Из основного, стоит отметить, что в случае группировки (GROUP BY), в перечне колонок в блоке SELECT:
--Мы можем использовать только колонки, перечисленные в блоке GROUP BY
--Можно использовать выражения с полями из блока GROUP BY
--Можно использовать константы, т.к. они не влияют на результат группировки
--Все остальные поля (не перечисленные в блоке GROUP BY) можно использовать только с агрегатными функциями (COUNT, SUM, MIN, MAX, …)
--Не обязательно перечислять все колонки из блока GROUP BY в списке колонок SELECT


SELECT 
	ds.destination_country_id [Страна-получатель], SUM(ds.duty_value) [Сумма]
FROM Dues ds
GROUP BY ds.destination_country_id


SELECT cs.gender [Пол], 
	AVG(cs.age) [Средний возраст заказчика], 
	MIN(cs.age) [Минимальный возраст заказчика], 
	MAX(cs.age) [Максимальный возраст заказчика]
FROM Clients cs
GROUP BY cs.gender
ORDER BY MAX(cs.age) DESC


--HAVING – наложение условия выборки к сгруппированным данным

SELECT 
	ogp.goods_id [Товар],
	SUM(ogp.amount) [Общее количество товара]
FROM OrderGoodsPair ogp
GROUP BY ogp.goods_id
HAVING SUM(ogp.amount) > 10 OR COUNT(*) > 1



--JOIN-соединения – операции горизонтального соединения данных
--ТИПЫ:
--JOIN – левая_таблица JOIN правая_таблица ON условия_соединения			| только те строки, для которых выполняются условия_соединения (1)
--LEFT JOIN – левая_таблица LEFT JOIN правая_таблица ON условия_соединения	| (1) + все строки левой таблицы, для недостающих данных из правой NULL
--RIGHT JOIN – левая_таблица RIGHT JOIN правая_таблица ON условия_соединения| (1) + все строки правой таблицы, для недостающих данных из левой NULL
--FULL JOIN – левая_таблица FULL JOIN правая_таблица ON условия_соединения	| (1) + все строки из левой и правой таблиц (недостающие данные = NULL)
--CROSS JOIN – левая_таблица CROSS JOIN правая_таблица						| декартово произведение таблиц
--несколько JOIN выполняются последовательно сверху вниз



SELECT
	CONCAT('Заказ № ', os1.order_id) [Номер заказа],
	os1.order_status [Статус заказа], 
	CONCAT('Заказ № ', os2.order_id) [Номер предыдущего заказа], 
	os2.order_status [Статус заказа]
FROM Orders os1
LEFT OUTER JOIN Orders os2 ON os1.order_id = os2.order_id + 1
WHERE os2.order_id IS NOT NULL



SELECT 
	cts.city_name 'Город',
	rs.region_name 'Регион',
	ctrs.country_name 'Страна'
FROM 
	Cities cts
	INNER JOIN Regions rs ON cts.region_id = rs.region_id
	INNER JOIN Countries ctrs ON rs.country_id = ctrs.country_id


SELECT 
	cts1.city_name [Пункт отправления], --rs1.region_name, ctrs1.country_name, ctrs1.country_id, ds1.ship_from_country_id,
 	cts2.city_name [Пункт назначения], --rs2.region_name, ctrs2.country_name, ctrs2.country_id, ds1.destination_country_id, ds1.duty_value--, ds2.ship_from_country_id, ds2.destination_country_id
	CASE 
		WHEN ds.duty_value IS NOT NULL THEN ds.duty_value
		WHEN ctrs1.country_id = ctrs2.country_id THEN 0
		--ELSE 0
	END [Пошлина]
FROM 
	Cities cts1
	CROSS JOIN Cities cts2
	LEFT OUTER JOIN Regions rs1 ON cts1.region_id = rs1.region_id
	LEFT OUTER JOIN Regions rs2 ON cts2.region_id = rs2.region_id
	LEFT OUTER JOIN Countries ctrs1 ON rs1.country_id = ctrs1.country_id
	LEFT OUTER JOIN Countries ctrs2 ON rs2.country_id = ctrs2.country_id
	LEFT OUTER JOIN Dues ds ON ctrs1.country_id = ds.ship_from_country_id AND ctrs2.country_id = ds.destination_country_id
ORDER BY ISNULL(ds.duty_value, -1) DESC, [Пункт отправления], [Пункт назначения]




-- ВЕРТИКАЛЬНОЕ ОБЪЕДИНЕНИЕ : UNION ALL (A + B), UNION (DISTINCT (A + B)), EXCEPT (A - B), INTERSECT (DISTINCT (A & B)) | можно использовать скобки для группировки
-- WITH : WITH q1 AS(SELECT ... [query1]), q2 AS([query2]) SELECT ... FROM q1 JOIN q2 ON q1.id1 = q2.id2 | часть кода использовать повторно
-- CTE (Common Table Expressions) (Общие табличные выражения)
--сделать среднюю пошлину при вывозе из страны и при ввозе в страну


--EXISTS возвращает True, если подзапрос возвращает хотя бы одну строку, и False, если подзапрос не возвращает строк.

SELECT *
FROM Countries ctrs
WHERE EXISTS (SELECT * FROM Cities cts WHERE cts.country_id = ctrs.country_id)


--IN можно использовать с подзапросом, который возвращает перечень значений | NULL опасны

SELECT *
FROM Clients cs
WHERE cs.client_id NOT IN (SELECT DISTINCT os.client_id FROM Orders os WHERE os.client_id IS NOT NULL)



-- Операции группового сравнения ALL и ANY

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

--ПОРЯДОК ВЫПОЛНЕНИЯ : FROM => WHERE => GROUP BY => HAVING => SELECT => ORDER BY => (DISTINCT?, TOP?)








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








-- Порядок выполнения: WHERE => DISTINCT => ORDER BY => TOP


--SELECT 100/99.1, SYSDATETIME()

/*
SELECT [DISTINCT] список_столбцов или *
FROM источник
WHERE фильтр
ORDER BY выражение_сортировки	
*/

