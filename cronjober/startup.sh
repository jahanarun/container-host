#!/bin/bash

python3 /scripts/onvif_camera_set_time.py | tee -a /var/log/cron.log 2>&1
python3 /scripts/tailscale-maintenance.py | tee -a /var/log/cron.log 2>&1
