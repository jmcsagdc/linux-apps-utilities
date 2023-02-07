#!/usr/bin/env python3

import os, sys

directory = '.'

print("XXXXXXXXXXXXXXXXXXXXXXXXXX")
print("I only do jpgs in the current working directory!")
print("Current working directory: "+os.getcwd())
print("XXXXXXXXXXXXXXXXXXXXXXXXXX")
myString = input("New filename base: ")

print('Suffix is -generative-stock.jpg')

def muddleContents(directory,myString):
    i = 0
    for filename in os.listdir(directory):
        f = os.path.join(directory, filename)
        if ".jpg" in filename:            
            if os.path.isfile(f):
                print("XXXXXXXXXXXXXXXXXXXXXXXXXX")
                print("BEFORE: ", f)
                i += 1
                newF = myString+"_"+str(i)+"-generative-stock.jpg"
                print("AFTER: ", newF)
                print("Use x to EXIT")
                doIt = input("Change it y/x/n? ")
                if "y" in doIt:
                    os.rename(filename,newF)
                elif "x" in doIt:
                    sys.exit()
                else:
                    print("I skipped this")
            else:
                print("Not proper file ", f)
        else:
            if os.path.isdir(f):
                # print(f+" is a directory")
                pass
            else:
                print("XXXXXXXXXXXXXXXXXXXXXXXXXX")
                print(filename+" <-----IS NOT A JPEG")

muddleContents(directory,myString)
