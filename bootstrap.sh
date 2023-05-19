#!/bin/sh
rm -rf /config
rm -rf /comics
mkdir -p \
    /comics \
    /comics/.yacreaderlibrary \
    /config/.local/share/YACReader/YACReaderLibrary

if [ ! -f /config/.local/share/YACReader/YACReaderLibrary/YACReaderLibrary.ini ]; then
    cp /defaults/YACReaderLibrary.ini /config/.local/share/YACReader/YACReaderLibrary/YACReaderLibrary.ini
fi

rm -rf /defaults

echo "
0 */12 * * * YACReaderLibraryServer update-library /comics
" > /var/spool/cron/crontabs/root
