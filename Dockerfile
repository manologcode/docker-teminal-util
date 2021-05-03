###################################################################################
# Based on alpine
#
# To build, do:
#   $ docker build -t crea/util .
#
###################################################################################

FROM alpine:3.8

RUN apk add --update bash && rm -rf /var/cache/apk/*

## YOUTUBE-DL

RUN set -x \
 && apk add --no-cache ca-certificates curl ffmpeg python \
    # Install youtube-dl
    # https://github.com/rg3/youtube-dl
 && curl -Lo /usr/local/bin/youtube-dl https://yt-dl.org/downloads/latest/youtube-dl \
 && chmod a+rx /usr/local/bin/youtube-dl \
    # Clean-up
 && apk del curl \
    # Create directory to hold downloads.
 && mkdir /downloads \
 && chmod a+rw /downloads \
    # Basic check it works.
 && youtube-dl --version

ENV SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt


## PDFTK

RUN set -x && \
    apk add --update pdftk

## GHOSTSCRIPT & IMAGEMAGICK
RUN apk add --no-cache inotify-tools imagemagick ghostscript

## QPDF
RUN apk add --no-cache qpdf

# compile mp3gain
# RUN mkdir -p /tmp/mp3gain-src
# RUN curl -Lo /tmp/mp3gain-src/mp3gain.zip https://sourceforge.net/projects/mp3gain/files/mp3gain/1.6.1/mp3gain-1_6_1-src.zip
# RUN cd /tmp/mp3gain-src
# RUN unzip -qq /tmp/mp3gain-src/mp3gain.zip
# RUN sed -i "s#/usr/local/bin#/usr/bin#g" /tmp/mp3gain-src/Makefile
# RUN make
# RUN make install


WORKDIR /downloads

VOLUME /downloads

CMD bash
