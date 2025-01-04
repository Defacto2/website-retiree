#!/usr/bin/env bash
#
# Docker MySQL export database

export MYSQL_PWD=$(cat /opt/Defacto2-2020/.config/defacto2-inno)
export MYSQL_CONTAINER=d2020-db

# SQL INSERT INTO
insert () {
    local filename=d2-sql-insert
    local file=/opt/backup/sql/$filename
    local daily=$file-$(date +"%A") # day of week
    local monthly=$file-$(date +"%B-%Y") # month and year
    docker exec $MYSQL_CONTAINER mysqldump --user=root --password=${MYSQL_PWD} --skip-comments --single-transaction --quick --lock-tables=false --complete-insert --ignore-table=defacto2-inno.users defacto2-inno > $file.sql
    sha1sum --tag $file.sql > $file.sql.sha1
    local diff=$(diff $file.sql $daily.sql)
    if [ "$diff" != "" ] || [ ! -f $daily.sql ]
    then
        echo "Refreshing daily SQL insert"
        cp $file.sql $daily.sql
        sha1sum --tag $daily.sql > $daily.sql.sha1
    fi
    local diff=$(diff $file.sql $monthly.sql)
    if [ "$diff" != "" ] || [ ! -f $monthly.sql ]
    then
        echo "Refreshing monthly SQL insert"
        cp $file.sql $monthly.sql
        sha1sum --tag $monthly.sql > $monthly.sql.sha1
    fi
}
# SQL REPLACE INTO
update () {
    local filename=d2-sql-update
    local file=/opt/backup/sql/$filename
    local monthly=$file-$(date +"%B-%Y") # month and year
    docker exec $MYSQL_CONTAINER mysqldump --user=root --password=${MYSQL_PWD} --replace --skip-triggers --skip-comments --no-create-info --no-create-db --skip-add-drop-table --single-transaction --quick --lock-tables=false --complete-insert --ignore-table=defacto2-inno.users defacto2-inno > $file.sql
    sha1sum --tag $file.sql > $file.sql.sha1
    # only use diff with uncompressed files, as gz compression on
    # two identical files will result in differences
    local diff=$(diff $file.sql $monthly.sql)
    if [ "$diff" != "" ] || [ ! -f $monthly.sql ]
    then
        echo "Refreshing monthly SQL update"
        cp $file.sql $monthly.sql
        sha1sum --tag $monthly.sql > $monthly.sql.sha1
    fi
}
insert
update
unset MYSQL_PWD CONTAINER
chown ben:ben /opt/backup/sql/*.sql /opt/backup/sql/*.sql.sha1
chmod 644 /opt/backup/sql/*.sql /opt/backup/sql/*.sql.sha1
ls -l /opt/backup/sql
exit 0