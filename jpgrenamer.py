#!/usr/bin/env python3

import os

directory = '.'

print("I only do jpgs in the current working directory!)

myString = input("new filename base: ")

def muddleContents(directory,myString):
    i = 0
    for filename in os.listdir(directory):
        if ".jpg" in filename:
            f = os.path.join(directory, filename)
            if os.path.isfile(f):
                print("before: ", f)
                i += 1
                newF = myString+"_"+str(i)+".jpg"
                print("after: ", newF)
                doIt = input("Change it y/n? ")
                if "y" in doIt:
                    os.rename(filename,newF)
                else:
                    print("I skipped this")
            else:
                print("Not proper file ", f)
        else:
            print(filename+" <-----IS NOT A JPEG")

muddleContents(directory,myString)
