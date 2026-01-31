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
    redis \
    memcached

RUN rm -rf /var/lib/apt/lists/*
# RUN apt-get install -y  php-sysvsem
# RUN php -v
#  && rm -rf /var/lib/apt/lists/*

# (Optional) If you still see loading order warnings in specific environments,
# you can force the alphabetical loading order manually:
RUN mv /usr/local/etc/php/conf.d/docker-php-ext-igbinary.ini /usr/local/etc/php/conf.d/01-igbinary.ini && \
    mv /usr/local/etc/php/conf.d/docker-php-ext-redis.ini /usr/local/etc/php/conf.d/02-redis.ini && \
    mv /usr/local/etc/php/conf.d/docker-php-ext-memcached.ini /usr/local/etc/php/conf.d/02-memcached.ini

# Reset working directory as per official image
WORKDIR /var/www/html
