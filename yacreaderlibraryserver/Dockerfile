FROM alpine:latest
MAINTAINER ftd5x

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories &&\
	apk add --virtual .build-deps qt5-qtbase-dev wget git make unzip g++ poppler-qt5-dev &&\
	mkdir /src &&\
	cd /src &&\
	git clone https://hub.fastgit.org/YACReader/yacreader.git . &&\
	git checkout master &&\
	cd compressed_archive/ &&\
	wget https://sourceforge.net/projects/p7zip/files/p7zip/16.02/p7zip_16.02_src_all.tar.bz2/download -O p7zip.tar.gz &&\
	tar xf p7zip.tar.gz && mv p7zip_16.02 libp7zip &&\
	#cd compressed_archive/unarr/ &&\
	#wget github.com.cnpmjs.org/selmf/unarr/archive/master.zip &&\
	#unzip master.zip &&\
	#rm master.zip &&\
	#cd unarr-master/lzmasdk &&\
	#ln -s 7zTypes.h Types.h &&\
	cd /src/YACReaderLibraryServer &&\
	qmake-qt5 CONFIG+='server_standalone static 7zip' YACReaderLibraryServer.pro &&\
	make -j `nproc` &&\
	strip --strip-all YACReaderLibraryServer &&\
	make install &&\
	cd / &&\
	rm -rf /src &&\
	apk del .build-deps &&\
	apk add --virtual .run-deps poppler-qt5 qt5-qtbase qt5-qtbase-sqlite

ADD YACReaderLibrary.ini /root/.local/share/YACReader/YACReaderLibrary/

ENV LC_ALL=C.UTF8

ENTRYPOINT ["YACReaderLibraryServer","start"]
