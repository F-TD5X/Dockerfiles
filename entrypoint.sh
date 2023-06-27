!/bin/sh
# Start the server
crond -L /var/log/crond.log &&\
    YACReaderLibraryServer add-library comics /comics &&\
    YACReaderLibraryServer start
