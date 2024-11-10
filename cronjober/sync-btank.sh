#!/bin/bash
rsync=/usr/bin/rsync
btrfs=/usr/bin/btrfs
snapper=/usr/bin/snapper
date=/bin/date
vols=(media)
declare -A source_dict
source_dict["media"]="/merged/media/"
# source_dict["appdata"]="/rocket10/appdata/"

declare -A destination_dict
destination_dict["media"]="/mnt/btank/media/"
# destination_dict["appdata"]="/rocket10/appdata/"

logging=1

function log() {
        if [[ $logging == 1 ]]; then
                echo "$(date +%Y-%m-%d) $(date +%H:%M:%S): $1"
        fi
}

function take_snapshot() {
        config_name=$1
        log "Taking snapshot"
        $snapper -c $config_name create --description "rsyncer job"
}
function rsyncer() {
        source=$1
        target=$2
        $rsync -avh --stats --exclude=".*/" $source $target
}
log "Starting..."

for vol_name in "${vols[@]}"; do
        log "Processing subvolume: $vol_name"
        take_snapshot $vol_name
        source_dir=${source_dict[$vol_name]}
        target_dir=${destination_dict[$vol_name]}
        rsyncer $source_dir $target_dir
done

log "Finished"
