BEGIN{ip="nothing" 
    time=""
    type=""
 }
 {
    if (ip != $3)
    {
       if(time != "")
       { 
          print time, ip, type
       }
    time=$1" "$2
    ip=$3
    type=$4
    }
    else if (type != $4)
    {
       type="both"
    }
 }
 END{
    print time, ip, type
 }
