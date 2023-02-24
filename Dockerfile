FROM alpine:latest
LABEL maintainer="ftd5x"

ARG YACR_VERSION="9.11.0"
ENV HOME="/config"

COPY ./* /

RUN apk add --no-cache --virtual .build-deps cmake qt5-qtbase-dev wget git make unzip bzip2 xz g++ poppler-qt5-dev patch &&\
	git clone -b master --single-branch https://github.com/selmf/unarr.git /tmp/unrar &&\
	cd /tmp/unrar &&\
	mkdir build && cd build &&\
	cmake -DENABLE_7Z=ON .. &&\
	make && make install &&\
	git clone https://github.com/YACReader/yacreader.git /src &&\
	cd /src &&\
	git checkout ${YACR_VERSION} &&\
	cd /src/YACReaderLibraryServer &&\
	qmake-qt5 CONFIG+='unrar server_standalone static' YACReaderLibraryServer.pro &&\
	make -j `nproc` &&\
	strip --strip-all YACReaderLibraryServer &&\
	make install &&\
	cd / &&\
	rm -rf /src &&\
	apk del .build-deps &&\
	apk add --no-cache --virtual .run-deps bzip2 xz poppler-qt5 qt5-qtbase qt5-qtbase-sqlite &&\
	rm -rf /var/cache/apk/* &&\
	/bootstrap.sh

ENV LC_ALL=C.UTF8
ENTRYPOINT ["/bin/sh","/entrypoint.sh"]