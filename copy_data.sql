COPY markers (ip_prefixes, Hostname, Continent, Country, Capital, State, City_Location, Postal, Area, Metro, ISP, Organization, AS_Number, Time_zone, Local_Time, Continent_LatLon, Country_LatLon, Nameservers, Net_Range, CIDR, lat, lng, Date_, Time_,type ) FROM '/home/swatesh/Thesis/database/data_old.csv' delimiter',' csv ;

select time_, date_, ip_prefixes, type from markers;
