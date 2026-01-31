# 1. FIX: Pin to 32.0.5 to match your data version
FROM nextcloud:32.0.5-apache

# 2. Add dependencies for the packages you need
RUN apt-get update && \
    apt-get install -y \
        procps \
        smbclient \
        ffmpeg \
        nano \
        libimage-exiftool-perl \
        mesa-va-drivers && \
    rm -rf /var/lib/apt/lists/*

# 3. Use the installer to REINSTALL redis and memcached WITH igbinary support
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

# This command re-compiles them to ensure they use igbinary correctly
RUN install-php-extensions \
    sysvsem \
    igbinary \
    redis \
    memcached

# 4. FIX: Force the loading order
# Even if they are installed, PHP loads them alphabetically.
# We move them to numbered files to guarantee igbinary (01) is first.
RUN mv /usr/local/etc/php/conf.d/docker-php-ext-igbinary.ini /usr/local/etc/php/conf.d/01-igbinary.ini || true && \
    mv /usr/local/etc/php/conf.d/docker-php-ext-redis.ini /usr/local/etc/php/conf.d/02-redis.ini || true && \
    mv /usr/local/etc/php/conf.d/docker-php-ext-memcached.ini /usr/local/etc/php/conf.d/02-memcached.ini || true

# Add your custom apache config
RUN echo "LimitRequestBody 0" > /etc/apache2/conf-enabled/z_fix-restrictions.conf

WORKDIR /var/www/html
