# Dockerfile to create image with cron services
FROM jhnrn/nettools-base

#Install Cron & python
RUN apk -U upgrade && \
    apk add --no-cache \
    py3-pip \
    python3 \
    tini && \
    rm -rf /var/cache/apk/*

RUN mkdir /cronjober
COPY / /cronjober/
WORKDIR /cronjober
COPY . .
RUN rm -rf crons

RUN pip3 install -r requirements.txt --break-system-packages

# Copy cron fies to the cron.d directory
COPY crons/ /var/spool/cron/crontabs/
 
# Apply cron job
RUN chmod 0644 /var/spool/cron/crontabs/* && \
    cat /var/spool/cron/crontabs/*.cron | crontab -
 
# Symlink the cron to stdout
# RUN ln -sf /dev/stdout /var/log/cron.log

# Create the log file to be able to run tail
# Run the command on container startup
# ENTRYPOINT ["/sbin/tini", "--"]
ENTRYPOINT ["/sbin/tini", "--", "./startup.sh && /usr/sbin/crond -f -d 0"]

# CMD /usr/sbin/crond && touch /var/log/cron.log && tail -F /var/log/cron.log
# ENTRYPOINT ["/usr/sbin/crond", "-f", "-d", "0"]
# CMD ["/usr/sbin/crond", "-f"]