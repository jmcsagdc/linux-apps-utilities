#!/usr/bin/python

"""
so here is a script to analyze the contents of a directory and tell you if it is a file or a dir

also does a sha256sum of each file.

Native python way from python.org that I need to incorporate:

import hashlib, binascii
dk = hashlib.pbkdf2_hmac('sha256', b'password', b'salt', 100000)
binascii.hexlify(dk) 
b'0394a2ede332c9a13eb82e9b24631604c31df978b4e2f0fbd2c549944f9d79a5' 
What I've done below probably won't work...
"""

import os, hashlib, binascii
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
        #checkTheSum='sha256sum '+each
        #print(checkTheSum)
        #mySum=os.popen(checkTheSum).read()
        temp = hashlib.pbkdf2_hmac('sha256', each, b'salt', 100000)
        mySum = binascii.hexlify(temp)
        print(mySum)
