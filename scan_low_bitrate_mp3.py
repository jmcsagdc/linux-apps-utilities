#!/usr/bin/python

import os
pyRun=os.popen('find . -iname "*.mp3" | while read f; do     mp3info -p "%r,,,%F \n" "$f"; done > temp.csv').read()
print pyRun

myData=open("temp.csv").readlines()
len(myData)
counter = 1
artistAlbums = []
singleAlbums = []
albums = []

for line in myData:
    row=line.strip().split(',,,.')
    if row[0].isdigit():
        if int(row[0])<200:
            #print counter, row[0], row[1]
            artistAlbums.append(row[1])
        else:
            pass # print row[0], " nope"
    else:
        pass

for each in artistAlbums:
    _, myArtist, myAlbum, _ = each.split('/')
    # print myArtist, myAlbum
    if myAlbum not in albums:
        albums.append(myAlbum)
        singleAlbums.append([myArtist, myAlbum])

#print albums # now a list of lists that contains [artist, album]
for each in singleAlbums:
    print counter, each
    counter += 1
