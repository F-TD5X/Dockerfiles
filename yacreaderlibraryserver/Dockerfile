FROM alpine:latest
MAINTAINER ftd5x

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories &&\
	apk add --virtual .build-deps qt5-qtbase-dev wget git make unzip g++ poppler-qt5-dev &&\
	mkdir /src &&\
	cd /src &&\
	git clone https://hub.fastgit.org/YACReader/yacreader.git . &&\
	git checkout master &&\
	cd compressed_archive/unarr/ &&\
	wget github.com.cnpmjs.org/selmf/unarr/archive/master.zip &&\
	unzip master.zip &&\
	rm master.zip &&\
	cd unarr-master/lzmasdk &&\
	ln -s 7zTypes.h Types.h &&\
	cd /src/YACReaderLibraryServer &&\
	qmake-qt5 CONFIG+='server_standalone static' YACReaderLibraryServer.pro &&\
	make -j `nproc` &&\
	make install &&\
	cd / &&\
	rm -rf /src &&\
	apk del .build-deps &&\
	apk add --virtual .run-deps poppler-qt5 qt5-qtbase-x11 &&\
    mkdir /src &&\
    ldd /usr/bin/YACReaderLibraryServer  | grep "=> /" | awk '{print $3}' | xargs -I '{}' cp -v '{}' /src/ &&\
    apk del .run-deps &&\
    cp /src/* /usr/lib &&\
    rm -r /src

ADD YACReaderLibrary.ini /root/.local/share/YACReader/YACReaderLibrary/

VOLUME /comics

EXPOSE 8080

ENV LC_ALL=C.UTF8

ENTRYPOINT ["YACReaderLibraryServer","start"]
