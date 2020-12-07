import os
import json
import hashlib
from pathlib import Path

Path = input("Introduceti locatia fisierelor: ")

with open( "Database.json" ) as json_file:
    DB = json.load( json_file )

#print( json.dumps( DB, indent = 2 ) )

def Check_dir( path ):

    files = os.scandir( path )
    for file in files:

        if os.path.isdir(os.path.join( path, file )):
                Check_dir( os.path.join( path, file ) )
                continue;

        with open( file, 'rb' ) as infile:
            line = infile.readline()
            checksum = hashlib.md5()

            while line:

                checksum.update( line )
                line = infile.readline()

        if DB["database"][file.name]["checksum"] != checksum.hexdigest() :
            print( "Fisierul " + file.name + " este corupt!")

Check_dir( Path )

