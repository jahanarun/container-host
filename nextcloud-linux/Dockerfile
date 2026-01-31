FROM nextcloud

RUN echo "LimitRequestBody 0" > /etc/apache2/conf-enabled/z_fix-restrictions.conf

RUN apt-get update && \
    apt-get install -y \
        procps \
        smbclient \
        ffmpeg \
        nano \
        libimage-exiftool-perl \
        mesa-va-drivers && \
    rm -rf /var/lib/apt/lists/*

# RUN dpkg -i install php-sysvsem
# RUN pkg install php80-sysvsem
# RUN docker-php-ext-install -j "$(nproc)" \
#         sysvsem \
#     ;

# Copy the installer from its official image
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

# Combine installations into a single RUN layer to reduce image size
# This automatically handles the igbinary dependency for redis.
RUN install-php-extensions \
    sysvsem \
    igbinary \
    redis

RUN rm -rf /var/lib/apt/lists/*
# RUN apt-get install -y  php-sysvsem
# RUN php -v
#  && rm -rf /var/lib/apt/lists/*
