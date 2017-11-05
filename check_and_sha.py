#!/usr/bin/python

"""
so here is a script to analyze the contents of a directory and tell you if it is a file or a dir

also does a sha256sum of each file.
"""

import os
myPath=raw_input('What is the full path you want to check? ')
os.listdir(myPath)

contentList=os.listdir(myPath)
print(myPath+'\n')

for each in contentList:
    fullPath=myPath+each

    if os.path.isdir(fullPath)==True:
        print(each+' is a directory.\n')
    else:
        print(each+' is a file.')
        checkTheSum='sha256sum '+each
        print(checkTheSum)
        mySum=os.popen(checkTheSum).read()
        print(mySum)
