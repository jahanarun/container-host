# Dockerfile to create image with cron services
FROM jhnrn/nettools-base

#Install Cron & python
RUN apk -U upgrade && \
    apk add --no-cache \
    supercronic shadow \
    py3-pip \
    python3 \
    tini && \
    rm -rf /var/cache/apk/*

RUN mkdir /cronjober
RUN adduser --system www-data
# RUN useradd -m www-data

WORKDIR /cronjober
COPY --chown=www-data:www-data  . .
# RUN rm -rf crons

RUN chown -R www-data:www-data /cronjober
RUN pip3 install -r requirements.txt --break-system-packages 
USER www-data
RUN chmod +x /cronjober/startup.sh
# \
#     && set -x \
#     && apk add --no-cache supercronic shadow

# Copy cron fies to the cron.d directory
# COPY crons/ /var/spool/cron/crontabs/
 
# Apply cron job
# RUN chmod 0644 /var/spool/cron/crontabs/* && \
#     cat /var/spool/cron/crontabs/*.cron | crontab -
 
# Symlink the cron to stdout
# RUN ln -sf /dev/stdout /var/log/cron.log
# COPY crontab .

# Create the log file to be able to run tail
# Run the command on container startup

# CMD ["/usr/bin/supercronic", "-test", "crontab"]

# ENTRYPOINT ["/cronjober/startup.sh"]
ENTRYPOINT ["/sbin/tini", "--", "/cronjober/startup.sh"]
# RUN /cronjober/startup.sh
# ENTRYPOINT ["tail", "-f", "/dev/null"]

# CMD /usr/sbin/crond && touch /var/log/cron.log && tail -F /var/log/cron.log
# ENTRYPOINT ["/usr/sbin/crond", "-f", "-d", "0"]
# CMD ["/usr/sbin/crond", "-f"]