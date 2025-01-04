#!/usr/bin/env bash
#
# Docker MySQL export database changes from a specific date

# SQL INSERT INTO
sqlexport () {
    local fromdate="2019-08-12"
    local filename=d2-sql-sync-insert
    local file=~/$filename
    
    mysqldump --user=root --password --where="createdat>'$fromdate'" \
    --skip-comments --no-create-info defacto2-inno files > $file.sql
    
    chown ben:ben ~/$filename.sql
    chmod 640 ~/$filename.sql
    ls -l ~/$filename.sql
}
sqlexport
exit 0