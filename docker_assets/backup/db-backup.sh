#!/usr/bin/env bash
#
# Docker Backup, restore, or migrate data volumes
# https://docs.docker.com/storage/volumes/#backup-restore-or-migrate-data-volumes
backup () {
    local gz=/backup/d2-db-volume.tar.gz
    local daily=/backup/d2-db-volume-$(date +"%A").tar.gz
    local monthly=/backup/d2-db-volume-$(date +"%B-%Y").tar.gz
    docker run --rm --volumes-from d2020-db -v /opt/backup:/backup ubuntu bash -c "cd /var/lib/mysql && tar zcvf $gz ."
    cp /opt$gz /opt$monthly
    cp /opt$gz /opt$daily
    chown ben:ben /opt/backup/*.tar.gz
    chmod 640 /opt/backup/*.tar.gz
}
backup
exit 0