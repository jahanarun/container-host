FROM alpine
EXPOSE 53/tcp 53/udp
ARG TARGETARCH=amd64
ARG TARGETPLATFORM
RUN apk --no-cache add bind-tools curl jq

RUN curl https://api.github.com/repos/nextdns/nextdns/releases/latest

RUN case ${TARGETPLATFORM} in \
      "linux/arm/v7") TARGETARCH=armv7 ;; \
      "linux/arm/v6") TARGETARCH=armv6 ;; \
    esac \
    && NEXTDNS_VERSION=$(curl https://api.github.com/repos/nextdns/nextdns/releases/latest | jq -r .tag_name) \
    && NEXTDNS_VERSION="${NEXTDNS_VERSION:1}" \
    && wget -O /tmp/nextdns.tar.gz https://github.com/nextdns/nextdns/releases/download/v${NEXTDNS_VERSION}/nextdns_${NEXTDNS_VERSION}_linux_$TARGETARCH.tar.gz \
    && tar xf /tmp/nextdns.tar.gz -C /usr/bin nextdns \
    && rm /tmp/nextdns.tar.gz

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]