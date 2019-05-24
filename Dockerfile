FROM debian:stretch as builder

RUN apt-get update && apt-get install -y curl

ENV LTC_VERSION=0.17.1
ENV LTC_CHECKSUM="9cab11ba75ea4fb64474d4fea5c5b6851f9a25fe9b1d4f7fc9c12b9f190fed07 litecoin-${LTC_VERSION}-x86_64-linux-gnu.tar.gz"

RUN curl -SLO "https://download.litecoin.org/litecoin-${LTC_VERSION}/linux/litecoin-${LTC_VERSION}-x86_64-linux-gnu.tar.gz" \
  && echo "${LTC_CHECKSUM}" | sha256sum -c - | grep OK \
  && tar -xzf litecoin-${LTC_VERSION}-x86_64-linux-gnu.tar.gz

FROM bitnami/minideb:stretch
ENV LTC_VERSION=0.17.1
RUN useradd -m litecoin
RUN apt-get remove -y --allow-remove-essential --purge adduser gpgv mount hostname gzip login sed
USER litecoin
COPY --from=builder /litecoin-${LTC_VERSION}/bin/litecoind /bin/litecoind
RUN mkdir -p /home/litecoin/.litecoin
ENTRYPOINT ["litecoind"]
CMD ["-printtoconsole"]
