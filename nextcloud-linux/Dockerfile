FROM nextcloud

RUN echo "LimitRequestBody 0" > /etc/apache2/conf-enabled/z_fix-restrictions.conf

RUN apt-get update && apt-get install -y procps smbclient ffmpeg nano libmagickcore-6.q16-6-extra libimage-exiftool-perl && rm -rf /var/lib/apt/lists/* 
