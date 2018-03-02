FROM alpine:3.7

ARG CREATED
ARG PIGPIO_COMMIT=1737d477479f6009a4e1f3227480bfdb1a3653d0
ARG PIGPIO_SHA256_CHECKSUM=218db5bda5d58a4ecd9dc47027f82d51203de61d49b2eeaae29b0007f5ef31fd

LABEL org.opencontainers.image.title="PiGPIO" \
    org.opencontainers.image.version="0.1.0-1" \
    org.opencontainers.image.vendor="IUNO" \
    org.opencontainers.image.description="PiGPIO is a library for the Raspberry Pi which allows control of the General Purpose Input Outputs (GPIO)." \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.authors="Andre Lehmann <aisberg@posteo.de>" \
    org.opencontainers.image.url="http://abyz.me.uk/rpi/pigpio/" \
    org.opencontainers.image.revision=$PIGPIO_COMMIT \
    org.opencontainers.image.created=$CREATED

RUN apk --update --no-cache --no-progress --virtual .build-deps add \
        gcc \
        libc-dev \
        make \
        ca-certificates \
        unzip \
        curl &&\
    apk --update --no-cache --no-progress add tini &&\
    mkdir -p /usr/local/src/ &&\
    curl -fSL "https://github.com/joan2937/pigpio/archive/${PIGPIO_COMMIT}.zip" -o /usr/local/src/pigpio.zip &&\
    echo "${PIGPIO_SHA256_CHECKSUM}  /usr/local/src/pigpio.zip" | sha256sum -c &&\
    unzip -d /usr/local/src /usr/local/src/pigpio.zip &&\
    cd /usr/local/src/pigpio-* &&\
    `# syntax for ldconfig is different for Alpine than specified in the Makefile` &&\
    (make install ; ldconfig /) &&\
    cd / &&\
    rm -r /usr/local/src &&\
    apk del .build-deps

EXPOSE 8888/tcp

ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/pigpiod", "-g"]
