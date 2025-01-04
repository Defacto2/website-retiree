# Crontab Generator (https://crontab-generator.org/)

# at 12:00am backup the database
0 0 * * * /opt/daily-defacto2/docker_assets/backup/db-backup.sh >/dev/null 2>&1

# at 12:10am dump the SQL database to a text file
10 0 * * * /opt/daily-defacto2/docker_assets/backup/sql-dump.sh >/dev/null 2>&1

# every even minute test the state of the CFML server
*/2 * * * * /opt/daily-defacto2/docker_assets/lucee/scripts/keep-alive.sh >/dev/null 2>$1

# every hour run set permission bits
0 * * * * /opt/daily-defacto2/docker_assets/lucee/scripts/setbits.sh >/dev/null 2>&1

# reboot at 12:30am of the 13th of each month
30 0 13 * *  /sbin/reboot > /var/log/reboot.log