FROM nextcloud

RUN echo "LimitRequestBody 0" > /etc/apache2/conf-enabled/z_fix-restrictions.conf

RUN apt-get update
RUN apt-get install -y procps smbclient ffmpeg nano libmagickcore-6.q16-6-extra libimage-exiftool-perl mesa-va-drivers vainfo vdapu-driver-all vdapuinfo
RUN dpkg -i install php-sysvsem
RUN rm -rf /var/lib/apt/lists/* 
