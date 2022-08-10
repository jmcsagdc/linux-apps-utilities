# use with arg to specify search pattern

dps () { docker ps | awk '{ print $1 "\t\t" $2 "\t\t\t" $4 $5 $6 }' | grep $1 }
