# Base image
FROM tailscale/tailscale AS tailscale
# USER root

COPY ./custom.sh /custom.sh


FROM jhnrn/nettools-base

COPY --from=tailscale /usr/local/bin/tailscale /usr/local/bin/
COPY --from=tailscale /usr/local/bin/tailscaled /usr/local/bin/

# Copy the wrapper script into the image
COPY ./custom.sh /custom.sh

RUN chmod +x /custom.sh

STOPSIGNAL SIGTERM

ENTRYPOINT ["/custom.sh"]
