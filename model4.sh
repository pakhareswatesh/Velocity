date
STARTTIME=$(date +%s)
PARALLEL=-j0  # means maximum no. of cores will be used
export PARALLEL
sorting()         # its a function that extracts IP address, timestamp from test-data file
 { awk -f /home/swatesh/Final/timesort.awk 

}
export -f sorting

arin() {
    #to get network id from arin.net
    i="$@"
    set $i
    a=$(xidel http://whois.arin.net/rest/ip/$3 -e "//table/tbody/tr[3]/td[2] " |
    sed 's/\/[0-9]\{1,2\}/\n/g' | head -1)
    echo $1 $2 $a $4
}
export -f arin

iptrac() { IFS=','
    # to get other information from ip-tracker.org
    j="$@"
    set $j
    
    xidel http://www.ip-tracker.org/locator/ip-lookup.php?ip=$3 -e "//table/tbody/tr[3]/td[2]/table/tbody/tr[2]" -e "//table/tbody/tr[3]/td[2]/table/tbody/tr[3]" -e "//table/tbody/tr[3]/td[2]/table/tbody/tr[4]" -e "//table/tbody/tr[3]/td[2]/table/tbody/tr[5]" -e "//table/tbody/tr[3]/td[2]/table/tbody/tr[6]" -e "//table/tbody/tr[3]/td[2]/table/tbody/tr[7]" -e "//table/tbody/tr[3]/td[2]/table/tbody/tr[8]" -e "//table/tbody/tr[3]/td[2]/table/tbody/tr[9]" -e "//table/tbody/tr[3]/td[2]/table/tbody/tr[10]" -e "//table/tbody/tr[3]/td[2]/table/tbody/tr[11]" -e "//table/tbody/tr[3]/td[2]/table/tbody/tr[12]" -e "//table/tbody/tr[3]/td[2]/table/tbody/tr[13]" -e "//table/tbody/tr[3]/td[2]/table/tbody/tr[14]" -e "//table/tbody/tr[3]/td[2]/table/tbody/tr[15]" -e "//table/tbody/tr[3]/td[2]/table/tbody/tr[16]" -e "//table/tbody/tr[3]/td[2]/table/tbody/tr[17]" -e "//table/tbody/tr[3]/td[2]/table/tbody/tr[18]" -e "//table/tbody/tr[3]/td[2]/table/tbody/tr[19]" -e "//table/tbody/tr[3]/td[2]/table/tbody/tr[20]" -e "//table/tbody/tr[3]/td[2]/table/tbody/tr[21]" -e "//table/tbody/tr[3]/td[2]/table/tbody/tr[22]" -e "//table/tbody/tr[3]/td[2]/table/tbody/tr[23]" -e "//table/tbody/tr[3]/td[2]/table/tbody/tr[24]" -e "//table/tbody/tr[3]/td[2]/table/tbody/tr[25]" -e "//table/tbody/tr[3]/td[2]/table/tbody/tr[26]" -e "//table/tbody/tr[3]/td[2]/table/tbody/tr[27]" -e "//table/tbody/tr[3]/td[2]/table/tbody/tr[28]" -e "//table/tbody/tr[3]/td[2]/table/tbody/tr[29]" http://whois.arin.net/rest/ip/$3 -e "//table/tbody/tr[2]" -e "//table/tbody/tr[3]" | sed 's/\/[0-9]\{1,2\}/& /g' | sed -f /home/swatesh/Final/filter_latlon.sed | sed -f /home/swatesh/Final/filter2.sed | awk -f /home/swatesh/Final/condition_test.awk

echo $1,$2,$4
}
export -f iptrac

 echo "Enter date as YYYY-MM-DD format "
 read date
 echo "enter start time in 24 hours format (only hours like 12)"
 read stime
 echo "enter end time in 24 hours format (only hours like 14)"
 read etime

#stime=12  Time and date for extracting IP addresses based on these values
#etime=14
#date=2014-11-24
awk -F, '{print $1 }' /home/swatesh/Final/Results/data_old.csv > /home/swatesh/Final/CIDR.txt # extracting all IP prefixes from old csv file and storing in CIDR.txt

#cat /home/swatesh/test-data.csv |
#USE WHEN EXTRACTING IP ADDRESSES BETWEEN TIME 12:00 AND 14:00 (inclusive of time starting with 12 and exclusive of time starting with 14)
awk -v a="$stime" -v b="$etime" -v d="$date" -F "[: ]+" -f /home/swatesh/Final/select_time.awk /home/swatesh/test-data.csv |                 
parallel --pipe sorting |                          #pulls all ips external to UMKC from test file 
sort -r -k1 -k2 -k3 | sort -uk3 |                  # sorting removes all duplicate IP addresses
sed -f /home/swatesh/Final/both.sed |              #tags IP as source or destination or both
parallel arin |                                    # finds IP prefix for each ip by scraping www.arin.net
sort -r -k1 -k2 -k3 | sort -uk3 |                  # sorting removes all duplicate IP prefixes               
parallel --pipe grep -vFw -f /home/swatesh/Final/CIDR.txt | # comparison of old IP prefixes in CIDR.txt with newly obtained IP prefixes  
awk -f /home/swatesh/Final/both.awk |              #tags IP prefix as source or destination or both  
sed 's/ /,/g' |                                    # replaces spaces with comma 
parallel iptrac |                                  # downloads all geographical data from ip-tracker.org 
cut -d, --complement -f23 |                        # an extra blank column is ignored
tr -d '\200-\377' | sed 's/([A-Z][A-Z]//;s/  ([A-Z][A-Z]//;s/ *, */,/;s/ , /,/;/^$/d' > /home/swatesh/Final/Results/data_new.csv # # removes all non-ascii characters, extra spaces and stores the output in output csv file.

cat /home/swatesh/Final/Results/data_new.csv >> /home/swatesh/Final/Results/data_old.csv #append new data to old data.
ENDTIME=$(date +%s)
echo "It takes $(($ENDTIME - $STARTTIME)) seconds to complete this task..."

#cat regexp.txt | parallel --pipe -L1000 --round-robin grep -f - bigfile
#sudo -u postgres -H -- psql -d ip_database -c "SELECT ip_address from markers"

