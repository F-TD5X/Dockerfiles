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
time YACReaderLibraryServer update-library /comics >> /var/log/server.log
" > /update.sh
chmod +x /update.sh

echo "
0 */12 * * * /update.sh
" > /var/spool/cron/crontabs/root
