
<?php                                                                      

ini_set('display_errors', 1);

        
function parseToXML($htmlStr)
{
$xmlStr=str_replace('<','&lt;',$htmlStr);
$xmlStr=str_replace('>','&gt;',$xmlStr);
$xmlStr=str_replace('"','&quot;',$xmlStr);
$xmlStr=str_replace("'",'&#39;',$xmlStr);
$xmlStr=str_replace("&",'&amp;',$xmlStr);
return $xmlStr;
}

$dbh = pg_connect("host=localhost port=5432 dbname=ip_database user=postgres password=Viewsonic20");
if (!$dbh) {
die("Error in connection: " . pg_last_error());
}

// execute query


if (isset($_GET['Submit1'])) {


$start=$_GET['startTime'];
$end=$_GET['endTime'];
$din=$_GET['date'];
$con=$_GET['continent'];
$ty=$_GET['type']; 


$sql = "SELECT ip_prefixes, city_location, lat, lng, isp, type FROM markers where date_='$din' AND time_ BETWEEN '$start' AND '$end' AND continent='$con' AND type='$ty'";
$result = pg_query($dbh, $sql);
if (!$result) {

die("Error in SQL query: " . pg_last_error());
}


header("Content-type: text/xml");

// Start XML file, echo parent node
echo '<markers>';

// Iterate through the rows, printing XML nodes for each
while ($row = pg_fetch_array($result)){
  // ADD TO XML DOCUMENT NODE
  echo '<marker ';
  echo 'ip_prefixes="' . parseToXML($row['ip_prefixes']) . '" ';                            
                                                                                         
  echo 'city_location="' . parseToXML($row['city_location']) . '" ';
  echo 'lat="' . $row['lat'] . '" ';
  echo 'lng="' . $row['lng'] . '" ';
  echo 'isp="' . parseToXML($row['isp']) . '" ';
  echo 'type="' . parseToXML($row['type']) . '" ';
  echo '/>';
}
// End XML file

echo '</markers>';

//header("Location:http://localhost/ip_maps.html?Submit1=HIT&IP=$ip");
} 
//header("Location:http://localhost/ip_maps.html");//Submit1=HIT&IP=$ip

                      
?>

