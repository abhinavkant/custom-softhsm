FROM alpine:latest

RUN set -x \
    && apk add --no-cache \
        bash \
        wget \
        gcc \
        tar \
        alpine-sdk \
        perl \
        linux-headers \
        automake \
        libtool \
        autoconf \
    && rm -rf /var/cache/apk/*

RUN openssl version

ENV OPENSSL_VERSION="3.4.0"

WORKDIR /opt/openssl

# Download openssl
RUN set -x \
  && wget --no-check-certificate -O openssl-${OPENSSL_VERSION}.tar.gz "https://github.com/openssl/openssl/archive/refs/tags/openssl-${OPENSSL_VERSION}.tar.gz" \
  && tar -xvf openssl-${OPENSSL_VERSION}.tar.gz \
  && rm -rf openssl-${OPENSSL_VERSION}.tar.gz \
  && cd  openssl-openssl-${OPENSSL_VERSION}

# Configure and build OpenSSL
RUN cd openssl-openssl-${OPENSSL_VERSION} \
    && ./config \
# --prefix=/opt/openssl --openssldir=/usr/local/ssl \
    && make \
    && make test \
    && make install

RUN rm -rf /opt/openssl/openssl-openssl-${OPENSSL_VERSION}

RUN export LD_LIBRARY_PATH=/usr/local/ssl/lib:$LD_LIBRARY_PATH
ENV PATH=/usr/local/ssl/bin:$PATH

ENV SOFTHSM_VERSION="2.6.1"

# Download softhsm
RUN set -x \
  && wget --no-check-certificate -O softhsm-${SOFTHSM_VERSION}.tar.gz "https://github.com/softhsm/SoftHSMv2/archive/refs/tags/${SOFTHSM_VERSION}.tar.gz" \
  && tar -xvf softhsm-${SOFTHSM_VERSION}.tar.gz \
  && rm -rf softhsm-${SOFTHSM_VERSION}.tar.gz \
  && cd SoftHSMv2-${SOFTHSM_VERSION}

# Compile SoftHSMv2
RUN cd SoftHSMv2-${SOFTHSM_VERSION} \
    && sh autogen.sh \
    && ./configure --prefix=/usr/local \
    && make \
    && make install

RUN rm -fr SoftHSMv2-${SOFTHSM_VERSION}