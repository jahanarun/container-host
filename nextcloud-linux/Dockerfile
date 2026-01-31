FROM nextcloud

USER root

# Add dependencies for the packages you need
RUN apt-get update && \
    apt-get install -y \
        procps \
        smbclient \
        ffmpeg \
        nano \
        libimage-exiftool-perl \
        mesa-va-drivers && \
    rm -rf /var/lib/apt/lists/*

# Use the installer to REINSTALL redis and memcached WITH igbinary support
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

# This command re-compiles them to ensure they use igbinary correctly
RUN install-php-extensions \
    sysvsem \
    igbinary \
    redis \
    memcached

# # Create a custom PHP setting file for Nextcloud
# RUN echo "memory_limit=8G" > /usr/local/etc/php/conf.d/z-custom-nextcloud.ini && \
#     echo "upload_max_filesize=16G" >> /usr/local/etc/php/conf.d/z-custom-nextcloud.ini && \
#     echo "post_max_size=16G" >> /usr/local/etc/php/conf.d/z-custom-nextcloud.ini && \
#     echo "output_buffering=0" >> /usr/local/etc/php/conf.d/z-custom-nextcloud.ini

# Create a file for OPcache
RUN echo "opcache.enable=1" > /usr/local/etc/php/conf.d/z-opcache.ini && \
    echo "opcache.interned_strings_buffer=16" >> /usr/local/etc/php/conf.d/z-opcache.ini && \
    echo "opcache.max_accelerated_files=10000" >> /usr/local/etc/php/conf.d/z-opcache.ini && \
    echo "opcache.memory_consumption=128" >> /usr/local/etc/php/conf.d/z-opcache.ini && \
    echo "opcache.save_comments=1" >> /usr/local/etc/php/conf.d/z-opcache.ini && \
    echo "opcache.revalidate_freq=60" >> /usr/local/etc/php/conf.d/z-opcache.ini && \
    echo "opcache.jit=1255" >> /usr/local/etc/php/conf.d/z-opcache.ini && \
    echo "opcache.jit_buffer_size=128M" >> /usr/local/etc/php/conf.d/z-opcache.ini

# Create a file for redis session
RUN echo "session.save_handler = redis" > /usr/local/etc/php/conf.d/redis-session.ini && \
    echo "session.save_path = 'tcp://redis:6379'" >> /usr/local/etc/php/conf.d/redis-session.ini && \
    echo "redis.session.locking_enabled = 1" >> /usr/local/etc/php/conf.d/redis-session.ini && \
    echo "redis.session.lock_retries = -1" >> /usr/local/etc/php/conf.d/redis-session.ini && \
    echo "redis.session.lock_wait_time = 10000" >> /usr/local/etc/php/conf.d/redis-session.ini

# Add your custom apache config
RUN echo "LimitRequestBody 0" > /etc/apache2/conf-enabled/z_fix-restrictions.conf

WORKDIR /var/www/html
