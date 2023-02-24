#!/bin/sh
mkdir -p \
    /comics \
    /comics/.yacreaderlibrary \
    /config/.local/share/YACReader/YACReaderLibrary

if [ ! -f /config/.local/share/YACReader/YACReaderLibrary/YACReaderLibrary.ini ]; then
    cp /defaults/YACReaderLibrary.ini /config/.local/share/YACReader/YACReaderLibrary/YACReaderLibrary.ini
fi


echo "
0 * * * * YACReaderLibraryServer update-library /comics
" > /var/spool/cron/crontabs/root
