FROM alpine

RUN apk add --no-cache avahi augeas avahi-tools

ADD entrypoint.sh /opt/entrypoint.sh

ENTRYPOINT ["/opt/entrypoint.sh"]