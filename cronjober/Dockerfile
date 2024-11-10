# Dockerfile to create image with cron services
FROM jhnrn/nettools-base

#Install Cron & python
RUN apk -U upgrade
# RUN apk add busybox-initscripts openrc --no-cache
RUN apk add --no-cache tini

RUN apk add --no-cache \
        python3 py3-pip

RUN rm -rf /var/cache/apk/*

RUN mkdir /scripts
COPY / /scripts/
WORKDIR /scripts
# COPY onvif_camera_set_time.py .
RUN pip3 install -r requirements.txt --break-system-packages

# Copy cron fies to the cron.d directory
COPY *.cron /var/spool/cron/crontabs/
 
# Apply cron job
RUN chmod 0644 /var/spool/cron/crontabs/* && \
    cat /var/spool/cron/crontabs/*.cron | crontab -
 
# Symlink the cron to stdout
# RUN ln -sf /dev/stdout /var/log/cron.log

# Create the log file to be able to run tail
# Run the command on container startup
ENTRYPOINT ["/sbin/tini", "--"]
# CMD /usr/sbin/crond && touch /var/log/cron.log && tail -F /var/log/cron.log
CMD ["/usr/sbin/crond", "-f", "-d", "0"]
# CMD ["/usr/sbin/crond", "-f"]