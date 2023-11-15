FROM nextcloud

RUN echo "LimitRequestBody 0" > /etc/apache2/conf-enabled/z_fix-restrictions.conf

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    apt-add-repository -y non-free && \
    apt-get update
RUN apt-get install -y \
        procps \
        smbclient \
        ffmpeg \
        nano \
        libmagickcore-6.q16-6-extra \
        libimage-exiftool-perl \
        mesa-va-drivers

# RUN dpkg -i install php-sysvsem
# RUN pkg install php80-sysvsem 
RUN docker-php-ext-install -j "$(nproc)" \
        sysvsem \
    ; 
RUN rm -rf /var/lib/apt/lists/* 
# RUN apt-get install -y  php-sysvsem
# RUN php -v
#  && rm -rf /var/lib/apt/lists/* 
