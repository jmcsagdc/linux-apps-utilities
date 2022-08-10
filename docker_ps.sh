# use with arg or without. With just specifies pattern

dps () { docker ps | awk '{ print $1 "\t\t" $2 "\t\t\t" $4 $5 $6 }' }
