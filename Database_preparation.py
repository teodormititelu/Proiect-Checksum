import os
import json
import hashlib
from pathlib import Path
import datetime

Path = input("Introduceti locatia fisierelor: ")

DB = {}
DB["database"] = {}

def Iter_dir( path ):

    files = os.scandir( path )
    for file in files:

        if os.path.isdir(os.path.join( path, file )):
                Iter_dir( os.path.join( path, file ) )
                continue;

        DB["database"][file.name] = {}

        with open( file, 'rb' ) as infile:
            line = infile.readline()
            checksum = hashlib.md5()

            while line:

                checksum.update( line )
                line = infile.readline()

        DB["database"][file.name]["path"] = os.path.join( Path, file )
        DB["database"][file.name]["Modified"] = str( datetime.datetime.fromtimestamp( os.stat( os.path.join( Path, file ) ).st_mtime ) )
        DB["database"][file.name]["checksum"] = checksum.hexdigest()

Iter_dir( Path )

with open( 'Database.json', 'w' ) as outfile:
    json.dump( DB, outfile )
