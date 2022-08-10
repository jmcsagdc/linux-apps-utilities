
alias k="kubectl"
alias cp="cp -iv"
alias rm="rm -iv"
alias mv="mv -iv"

dps () { docker ps | awk '{ print $1 "\t\t" $2 "\t\t\t" $4 $5 $6 }' | grep "$1" }
myhistory () { history | cut -b 8- | sort | uniq | grep -v history | grep $1 }
