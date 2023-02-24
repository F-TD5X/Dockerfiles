!/bin/sh
# Start the server
crond &&\
    YACReaderLibraryServer add-library comics /comics &&\
    YACReaderLibraryServer start
