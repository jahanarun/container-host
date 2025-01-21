#!/bin/bash

python3 /cronjober/onvif_camera_set_time.py | tee -a /var/log/cron.log 2>&1
# python3 /cronjober/tailscale-maintenance.py | tee -a /var/log/cron.log 2>&1

/usr/bin/supercronic -split-logs -passthrough-logs /cronjober/crontab
