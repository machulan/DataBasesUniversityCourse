/*DROP Table Countries; GO
DROP Table Dues; GO
DROP Table Regions; GO
DROP Table Cities; GO
DROP Table Clients; GO
DROP Table Orders; GO
DROP Table Goods; GO
DROP Table OrderGoodsPair; GO
DROP Table Cars; GO
DROP Table Drivers; GO
DROP Table Trips; GO
DROP Table OrderTripPair; GO*/

CREATE TABLE Countries (
	country_id bigint IDENTITY(1,1) NOT NULL CONSTRAINT PK_Countries PRIMARY KEY,
	country_name nvarchar(255) NOT NULL
)
GO

CREATE TABLE Dues (
	destination_country_id bigint NOT NULL CONSTRAINT FK_Dues_destination_country_id FOREIGN KEY (destination_country_id) REFERENCES Countries(country_id),
	ship_from_country_id bigint NOT NULL CONSTRAINT FK_Dues_ship_from_country_id FOREIGN KEY (ship_from_country_id) REFERENCES Countries(country_id),
	duty_value float NOT NULL,
	CONSTRAINT PK_Dues PRIMARY KEY CLUSTERED (destination_country_id, ship_from_country_id)
	--(car_id, car_model) ASC
	--WITH (IGNORE_DUP_KEY = OFF)
	--CONSTRAINT [FK_Dues] FOREIGN KEY (destination_country_id, ship_from_country_id) REFERENCES [Countries]([country_id])

	--ship_from_country_id bigint NOT NULL FOREIGN KEY REFERENCES [Countries]([country_id]),
	--CONSTRAINT FK_Dues FOREIGN KEY (destination_country_id) REFERENCES Countries(country_id),

	--FOREIGN KEY (destination_country_id, ship_from_country_id) REFERENCES [Countries]([country_id, country_id])
	-- IDENTITY(1,1) NOT NULL CONSTRAINT PK_Dues PRIMARY KEY,
)
GO

CREATE TABLE Regions (
	--country_id bigint NOT NULL FOREIGN KEY REFERENCES Countries (country_id),
	country_id bigint NOT NULL CONSTRAINT FK_Regions_country_id FOREIGN KEY (country_id) REFERENCES Countries (country_id),
	region_id bigint IDENTITY(1,1) NOT NULL CONSTRAINT PK_Regions PRIMARY KEY,
	region_name nvarchar(255) NOT NULL
)
GO

CREATE TABLE Cities (	
	city_name nvarchar(255) NOT NULL,
	region_id bigint NOT NULL CONSTRAINT FK_Cities_region_id FOREIGN KEY (region_id) REFERENCES Regions (region_id),
	country_id bigint NOT NULL CONSTRAINT FK_Cities_country_id FOREIGN KEY (country_id) REFERENCES Countries (country_id),
	city_id bigint IDENTITY(1,1) NOT NULL CONSTRAINT PK_Cities PRIMARY KEY
)
GO

CREATE TABLE Clients (
	address bigint NOT NULL CONSTRAINT FK_Clients_address FOREIGN KEY (address) REFERENCES Cities(city_id),
	first_name nvarchar(255) NOT NULL,
	last_name nvarchar(255) NOT NULL,
	age bigint NOT NULL,
	gender nvarchar(255) NOT NULL,
	client_id bigint IDENTITY(1,1) NOT NULL CONSTRAINT PK_Clients PRIMARY KEY
)
GO

CREATE TABLE Orders (
	destination_city_id bigint NOT NULL CONSTRAINT FK_Orders_destination_city_id FOREIGN KEY (destination_city_id) REFERENCES Cities (city_id),
	ship_from_city_id bigint NOT NULL CONSTRAINT FK_Orders_ship_from_city_id FOREIGN KEY (ship_from_city_id) REFERENCES Cities (city_id),
	order_id bigint IDENTITY(1,1) NOT NULL CONSTRAINT PK_Orders PRIMARY KEY,
	order_status nvarchar(255) NOT NULL,
	profit float NOT NULL,
	client_id bigint NOT NULL CONSTRAINT FK_Orders_client_id FOREIGN KEY (client_id) REFERENCES Clients (client_id),
	--FOREIGN KEY ([destination_city_id, ship_from_city_id]) REFERENCES [Cities]([city_id])
)
GO

CREATE TABLE Goods (
	goods_id bigint IDENTITY(1,1) NOT NULL CONSTRAINT PK_Goods PRIMARY KEY,
	name nvarchar(255) NOT NULL,
	decription nvarchar(255) NOT NULL,
	transportation_cost_per_unit_weight float NOT NULL,
	type nvarchar(255) NOT NULL
)
GO

CREATE TABLE OrderGoodsPair (
	order_id bigint NOT NULL CONSTRAINT FK_OrderGoodsPair_order_id FOREIGN KEY (order_id) REFERENCES Orders (order_id),-- int IDENTITY(1,1) NOT NULL CONSTRAINT PK_OrderGoodsPair PRIMARY KEY,
	weight float NOT NULL,
	amount bigint NOT NULL,
	goods_id bigint NOT NULL CONSTRAINT FK_OrderGoodsPair_goods_id FOREIGN KEY (goods_id) REFERENCES Goods (goods_id),

	CONSTRAINT PK_OrderGoodsPair PRIMARY KEY CLUSTERED (order_id, goods_id) 
	--(car_id, car_model) ASC
	--WITH (IGNORE_DUP_KEY = OFF)
)
GO

CREATE TABLE Cars (
	car_id bigint IDENTITY(1,1) NOT NULL CONSTRAINT PK_Cars PRIMARY KEY, -- int IDENTITY(1,1) NOT NULL
	car_model nvarchar(255) NOT NULL,
	color nvarchar(255) NOT NULL,
	car_type nvarchar(255) NOT NULL,
	weight float NOT NULL,
	transportation_coefficient float NOT NULL,
	travel_costs_per_kilometre float NOT NULL,
	total_run float NOT NULL,

	--CONSTRAINT [PK_CARS] PRIMARY KEY CLUSTERED
	--(
	--	car_id, car_model--(car_id, car_model) ASC
	--) --WITH (IGNORE_DUP_KEY = OFF)
)
GO
CREATE TABLE Drivers (
	driver_id bigint IDENTITY(1,1) NOT NULL CONSTRAINT PK_Drivers PRIMARY KEY,
	passport_number bigint NOT NULL,
	first_name nvarchar(255) NOT NULL,
	last_name nvarchar(255) NOT NULL,
	insurance_number bigint NOT NULL,
	experience bigint NOT NULL,
	driver_licence_number bigint NOT NULL,
	driver_licence_category nvarchar(255) NOT NULL
)
GO



CREATE TABLE Trips (
	trip_id bigint IDENTITY(1,1) NOT NULL CONSTRAINT PK_Trips PRIMARY KEY,
	driver_id bigint NOT NULL CONSTRAINT FK_Trips_driver_id FOREIGN KEY (driver_id) REFERENCES Drivers (driver_id),
	car_id bigint NOT NULL CONSTRAINT FK_Trips_car_id FOREIGN KEY (car_id) REFERENCES Cars (car_id),
	start_time date NOT NULL,
	end_time date NOT NULL,
	distance float NOT NULL
)
GO

CREATE TABLE OrderTripPair (
	trip_id bigint NOT NULL CONSTRAINT FK_OrderTripPair_trip_id FOREIGN KEY (trip_id) REFERENCES Trips (trip_id),-- IDENTITY(1,1) NOT NULL CONSTRAINT PK_OrderTripPair PRIMARY KEY,
	order_id bigint NOT NULL CONSTRAINT FK_OrderTripPair_order_id FOREIGN KEY (order_id) REFERENCES Orders(order_id),

	CONSTRAINT PK_OrderTripPair PRIMARY KEY CLUSTERED (trip_id, order_id) 
	--(car_id, car_model) ASC
	--WITH (IGNORE_DUP_KEY = OFF)
)
GO









/*
ALTER TABLE [Drivers] WITH CHECK ADD CONSTRAINT [Drivers_fk0] FOREIGN KEY ([passport_number]) REFERENCES []([])
ON UPDATE CASCADE
GO
ALTER TABLE [Drivers] CHECK CONSTRAINT [Drivers_fk0]
GO

ALTER TABLE [Clients] WITH CHECK ADD CONSTRAINT [Clients_fk0] FOREIGN KEY ([address]) REFERENCES [Cities]([city_id])
ON UPDATE CASCADE
GO
ALTER TABLE [Clients] CHECK CONSTRAINT [Clients_fk0]
GO


ALTER TABLE [Orders] WITH CHECK ADD CONSTRAINT [Orders_fk0] FOREIGN KEY ([destination_city_id]) REFERENCES [Cities]([city_id])
ON UPDATE CASCADE
GO
ALTER TABLE [Orders] CHECK CONSTRAINT [Orders_fk0]
GO
ALTER TABLE [Orders] WITH CHECK ADD CONSTRAINT [Orders_fk1] FOREIGN KEY ([ship_from_city_id]) REFERENCES [Cities]([city_id])
ON UPDATE CASCADE
GO
ALTER TABLE [Orders] CHECK CONSTRAINT [Orders_fk1]
GO
ALTER TABLE [Orders] WITH CHECK ADD CONSTRAINT [Orders_fk2] FOREIGN KEY ([client_id]) REFERENCES [Clients]([client_id])
ON UPDATE CASCADE
GO
ALTER TABLE [Orders] CHECK CONSTRAINT [Orders_fk2]
GO

ALTER TABLE [Trips] WITH CHECK ADD CONSTRAINT [Trips_fk0] FOREIGN KEY ([driver_id]) REFERENCES [Drivers]([driver_id])
ON UPDATE CASCADE
GO
ALTER TABLE [Trips] CHECK CONSTRAINT [Trips_fk0]
GO
ALTER TABLE [Trips] WITH CHECK ADD CONSTRAINT [Trips_fk1] FOREIGN KEY ([car_id]) REFERENCES [Cars]([car_id])
ON UPDATE CASCADE
GO
ALTER TABLE [Trips] CHECK CONSTRAINT [Trips_fk1]
GO*/

/*ALTER TABLE [OrderGoodsPair] WITH CHECK ADD CONSTRAINT [OrderGoodsPair_fk0] FOREIGN KEY ([order_id]) REFERENCES [Orders]([order_id])
ON UPDATE CASCADE
GO
ALTER TABLE [OrderGoodsPair] CHECK CONSTRAINT [OrderGoodsPair_fk0]
GO*/
/*ALTER TABLE [OrderGoodsPair] WITH CHECK ADD CONSTRAINT [OrderGoodsPair_fk1] FOREIGN KEY ([goods_id]) REFERENCES [Goods]([goods_id])
ON UPDATE CASCADE
GO
ALTER TABLE [OrderGoodsPair] CHECK CONSTRAINT [OrderGoodsPair_fk1]
GO*/

/*
ALTER TABLE [Dues] WITH CHECK ADD CONSTRAINT [Dues_fk0] FOREIGN KEY ([destination_country_id]) REFERENCES [Countries]([country_id])
ON UPDATE CASCADE
GO
ALTER TABLE [Dues] CHECK CONSTRAINT [Dues_fk0]
GO
ALTER TABLE [Dues] WITH CHECK ADD CONSTRAINT [Dues_fk1] FOREIGN KEY ([ship_from_country_id]) REFERENCES [Countries]([country_id])
ON UPDATE CASCADE
GO
ALTER TABLE [Dues] CHECK CONSTRAINT [Dues_fk1]
GO

ALTER TABLE [Cities] WITH CHECK ADD CONSTRAINT [Cities_fk0] FOREIGN KEY ([region_id]) REFERENCES [Regions]([region_id])
ON UPDATE CASCADE
GO
ALTER TABLE [Cities] CHECK CONSTRAINT [Cities_fk0]
GO
ALTER TABLE [Cities] WITH CHECK ADD CONSTRAINT [Cities_fk1] FOREIGN KEY ([country_id]) REFERENCES [Countries]([country_id])
ON UPDATE CASCADE
GO
ALTER TABLE [Cities] CHECK CONSTRAINT [Cities_fk1]
GO

ALTER TABLE [Regions] WITH CHECK ADD CONSTRAINT [Regions_fk0] FOREIGN KEY ([country_id]) REFERENCES [Countries]([country_id])
ON UPDATE CASCADE
GO
ALTER TABLE [Regions] CHECK CONSTRAINT [Regions_fk0]
GO

ALTER TABLE [OrderTripPair] WITH CHECK ADD CONSTRAINT [OrderTripPair_fk0] FOREIGN KEY ([trip_id]) REFERENCES [Trips]([trip_id])
ON UPDATE CASCADE
GO
ALTER TABLE [OrderTripPair] CHECK CONSTRAINT [OrderTripPair_fk0]
GO
ALTER TABLE [OrderTripPair] WITH CHECK ADD CONSTRAINT [OrderTripPair_fk1] FOREIGN KEY ([order_id]) REFERENCES [Orders]([order_id])
ON UPDATE CASCADE
GO
ALTER TABLE [OrderTripPair] CHECK CONSTRAINT [OrderTripPair_fk1]
GO*/
