 BEGIN {FS=":";r=1;}
{
if ( $1 == "IP Address" ) {
	x[1,2]=$2;
} if ( $1 == "Hostname" ) {
	x[1,3]=$2
} if ( $1 == "Continent" ) {
	x[1,4]=$2
} if ( $1 == "Country" ) {
	x[1,5]=$2
} if ( $1 == "Capital" ) {
	x[1,6]=$2
} if ( $1 == "State" ) {
	x[1,7]=$2
} if ( $1 == "City Location" ) {
	x[1,8]=$2
} if ( $1 == "Postal" ) {
	x[1,9]=$2
} if ( $1 == "Area" ) {
	x[1,10]=$2
} if ( $1 == "Metro" ) {
	x[1,11]=$2
} if ( $1 == "ISP"  ) {
	x[1,12]=$2
} if ( $1 == "Organization" ) {
	x[1,13]=$2
} if ( $1 == "AS Number" ) {
	x[1,14]=$2
} if ( $1 == "Time Zone" ) {
	x[1,15]=$2
} if ( $1 == "Local Time" ) {
	x[1,16]=$2
} if ( $1 == "Continent Lat/Lon" ) {
	x[1,17]=$2
} if ( $1 == "Country Lat/Lon" ) {
	x[1,18]=$2
}  if ( $1 == "Nameservers" ) {
	x[1,19]=$2
} if ( $1 == "Net Range" ) {
	x[1,20]=$2
} if ( $1 == "CIDR" ) {
	x[1,21]=$2
} if ( $1 == "City Latitude" ) {
	x[1,22]=$2
}if ( $1 == "City Longitude" ) {
	x[1,23]=$2
}if ( $1 == "Time Stamp" ) {
	x[1,24]=$2
}
}
END {	
	for(c=2;c<=24;c++) {
	
	  printf "%s,",x[r,c]
   }


   } 

