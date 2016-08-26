
CREATE TABLE markers (

ID SERIAL PRIMARY KEY ,
ip_prefixes varchar(25),
Hostname varchar(255),
Continent varchar(255),
Country varchar(255),
Capital varchar(255),
State varchar (255),
City_Location varchar(255),
Postal varchar(10),
Area varchar(10),
Metro varchar(10),
ISP text,
Organization text,
AS_Number text,
Time_zone varchar(255),
Local_Time varchar(255),
Continent_LatLon varchar(255),
Country_LatLon varchar(255),
Nameservers text,
Net_Range varchar(255),
CIDR text,
lat varchar (255),
lng varchar (255),
Date_ date,
Time_ time,
type varchar(15)

);

