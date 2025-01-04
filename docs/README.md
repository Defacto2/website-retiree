> [!CAUTION]
> THIS IS A HISTORICAL ARTEFACT.
> This repository is discontinued and should never be hosted online. It relies on a lot of dependencies and the older the code base becomes the more maintenance the code and libraries require. This code also may not function without modification due to hard-coded directory locations.

> [!WARNING]
> All known password references have been set to "password".

# Former source code for Defacto2

This `Defacto2-2020` repository is the **~~current live~~ former source code for Defacto2** hosted on https://defacto2.net.

> [!WARNING]
> Any further documentation maybe inaccurate.

The previous repository, `defacto2.net/` is retired.

## Documentation

#### [Developer Docker install](https://github.com/bengarrett/Defacto2-dev) - [DigitalOcean proxy](https://github.com/bengarrett/digital_ocean) - [Update software](UPDATE.md)

- [Web application](webapp.md)
- [Troubleshoot](troubleshoot.md)
- [Docker compose tips](docker-compose.md)
- [MySQL tips](mysql.md)
- [Lucee shell scripts](../docker_assets/lucee/scripts/README.md)
- [Lucee programming cheatsheet](code.md)


## Important Cloudflare info!

#### DO NOT ENABLE _Always Use HTTPS_

> Redirect all requests with scheme “http” to “https”. This applies to all http requests to the zone.

This will cause an endless loop with the waybackweb hosted pages.

## Git

### New branches

```sh
# create new
git branch newfeature
git checkout newfeature

# commit
git commit -a -m "new feature"

# merge into the main branch
git checkout main
git merge newfeature
```

### Branch renaming

```sh
git branch -m master main
git fetch origin
git branch -u origin/main main
```


## CORS

Cross-origin Resource Sharing is handled by the [DigitalOcean proxy](https://github.com/bengarrett/digital_ocean) in the `configs/defacto2.net.conf` file.

[MDN Web Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy).

## SSL

Security certificates are managed by [Cloudflare](https://dash.cloudflare.com/) and are configured by the [DigitalOcean proxy](https://github.com/bengarrett/digital_ocean) in the `configs/defacto2.net.conf` file.

## Legacy redirects

Legacy URL redirections have been moved out of the core codebase and are handled by the [`legacy.conf`](../docker_assets/nginx/legacy.conf) nginx file.

## HTTP cache control headers

Static file cache headers can be adjusted in the [`locations.conf`](../docker_assets/nginx/locations.conf) nginx file.

## MIME

MIME types have been overridden and need to be manually configured in the [`nginx.conf`](../docker_assets/nginx/nginx.conf) under `types`.

The `application/wasm` type is required by Chrome and Safari to successfully run WebAssembly code.

## Web hooks and permissions

Permissions are applied by the [`/opt/webhooks/commands/defacto2.sh`](https://github.com/bengarrett/webhooks/blob/master/commands/defacto2.sh) script on the [DigitalOcean proxy](https://github.com/bengarrett/digital_ocean). The script is run every time code is pushed into this repo.

[Web hooks can be configured through GitHub](https://github.com/bengarrett/Defacto2-2020/settings/hooks).

- Payload URL<br>`http://webhooks.retrotxt.com/hooks/defacto2`
- Content type<br>`application/json`
- Secret<br>See: `webhooks\hooks.json` **>** `trigger-rule` **>** `match` **>** `secret`
- Enable _Just the push event_

## Crontab and automation

Linux automation is handled by the [`crontab.sh`](../docker_assets/lucee/scripts/crontab.sh) found on the Digital Ocean host server.

##### root user

The root user for cron is needed for system tasks or file system changes.

```sh
# list jobs
sudo crontab -l
# edit jobs
sudo crontab -e
```

```sh
# m h  dom mon dow   command

# Crontab Generator (https://crontab-generator.org/)

# at 12:00am backup the database
0 0 * * * /opt/Defacto2-2020/docker_assets/backup/db-backup.sh >/dev/null

# at 12:10am dump the SQL database to a text file
10 0 * * * /opt/Defacto2-2020/docker_assets/backup/sql-dump.sh >/dev/null

# every even minute test the state of the CFML server
*/2 * * * * /opt/Defacto2-2020/docker_assets/lucee/scripts/keep-alive.sh >/dev/null 2>&1

# every hour run set permission bits
0 * * * * /opt/Defacto2-2020/docker_assets/lucee/scripts/setbits.sh >/dev/null

# reboot at 12:30am of the 13th of each month
30 0 13 * *  /sbin/reboot > /var/log/reboot.log
```

##### standard user

Note: cronjobs can only be run as root. To run a job as a local user, a bash script must be used.

`/etc/cron.daily/my`
[credit](https://askubuntu.com/questions/1105542/run-etc-cron-daily-from-specific-user)

```sh
#!/bin/sh

# If started as root, then re-start as user "ben":
if [ "$(id -u)" -eq 0 ]; then
    exec sudo -H -u gavenkoa $0 "$@"
    echo "This is never reached.";
fi

echo "This runs as user $(id -un)";
# prints "ben"

exit 0;
```

Copy and adapt the generic script.
```
sudo chmod +x /etc/cron.daily/my
sudo cp /etc/cron.daily/my /etc/cron.daily/df2-update-groups
sudo cp /etc/cron.daily/my /etc/cron.daily/df2-manage-new
sudo cp /etc/cron.daily/my /etc/cron.daily//df2-update-sitemap
```

##### df2-update-groups

```sh
#!/bin/sh

# If started as root, then re-start as user "ben":
if [ "$(id -u)" -eq 0 ]; then
    exec sudo -H -u gavenkoa $0 "$@"
fi
/usr/bin/df2 output groups --cronjob
exit 0;
```

##### df2-manage-new

```sh
#!/bin/sh

# If started as root, then re-start as user "ben":
if [ "$(id -u)" -eq 0 ]; then
    exec sudo -H -u gavenkoa $0 "$@"
fi
/usr/bin/df2 new
exit 0;
```

##### df2-update-sitemap

```sh
#!/bin/sh

# If started as root, then re-start as user "ben":
if [ "$(id -u)" -eq 0 ]; then
    exec sudo -H -u gavenkoa $0 "$@"
fi
/usr/local/bin/df2 output sitemap > /opt/Defacto2-2020/ROOT/files/sitemap/files.xml
exit 0;
```

##### crontab -e

```sh
# at 02:00am update groups
0 2 * * * /etc/cron.daily/df2-update-groups

# every hour run df2 task
0 * * * * /etc/cron.daily/df2-manage-new >/dev/null

# every Monday at 02:10am update sitemap
10 2 * * 1 /etc/cron.daily/df2-update-sitemap
```

## Shell scripts

#### MySQL database

[Backup](../docker_assets/backup/db-backup.sh), [Export](../docker_assets/backup/sql-dump.sh), [Sync](../docker_assets/backup/sql-sync.sh)


#### Lucee

- [Backup assets to 7z archives](../docker_assets/lucee/scripts/create-7zsh.sh)
- [Convert PNG images to WebP](../docker_assets/lucee/scripts/create-webp.sh)
- [Crontab](../docker_assets/lucee/scripts/crontab.sh)
- [Keep alive](../docker_assets/lucee/scripts/keep-alive.sh)
- [Reset file and directory permission bits](../docker_assets/lucee/scripts/setbits.sh)
- [Java set environment](../docker_assets/lucee/scripts/setenv.sh)


## Add a new computer to remote SSH access

Local macOS/Linux

```sh
ssh-add -L # print public key in use
ssh-add -l # print hash of public key in use
```

Remote Ubuntu

```sh
cd ~/.ssh
micro authorized_keys # edit and append the public key
systemctl reload ssh
```
