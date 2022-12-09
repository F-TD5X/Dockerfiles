FROM alpine:latest
MAINTAINER ftd5x

RUN addgroup -S app && adduser -S app -G app &&\
	apk add --virtual .build-deps qt5-qtbase-dev wget git make unzip g++ poppler-qt5-dev patch &&\
	mkdir /src &&\
	cd /src &&\
	git clone https://github.com/YACReader/yacreader.git . &&\
	git checkout tags/9.10.0 -b latest &&\
	cd compressed_archive/ &&\
	wget https://sourceforge.net/projects/p7zip/files/p7zip/16.02/p7zip_16.02_src_all.tar.bz2 -O p7zip_16.02_src_all.tar.bz2 &&\
	tar xf p7zip_16.02_src_all.tar.bz2 &&\
	mv p7zip_16.02 libp7zip &&\
	cd /src/YACReaderLibraryServer &&\
	qmake-qt5 CONFIG+='7zip server_standalone static' YACReaderLibraryServer.pro &&\
	make -j `nproc` &&\
	strip --strip-all YACReaderLibraryServer &&\
	make install &&\
	cd / &&\
	rm -rf /src &&\
	apk del .build-deps &&\
	apk add --virtual .run-deps poppler-qt5 qt5-qtbase qt5-qtbase-sqlite

ADD YACReaderLibrary.ini /root/.local/share/YACReader/YACReaderLibrary/

ENV LC_ALL=C.UTF8
USER app

ENTRYPOINT ["YACReaderLibraryServer","start"]
