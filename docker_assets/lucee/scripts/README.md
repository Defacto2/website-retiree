# Lucee scripts.

When adding new scripts to `/docker_assets/lucee/scripts/` you must do the following to avoid GitHub
junk and conflicts with execute permission bits.

On the remote defacto2.net server:

```bash
sudo chmod 750 newfile.sh
git add newfile.sh
git commit --all --message="chmod 750"
git push
```

On the local development machine:

```bash
git pull
```

From here on, the _750_ permission bit will remain attached to the file regardless of
the operating system it is edited on.

# Load scripts.

The `Dockerfile` MUST be modified to include a `COPY` command.

```docker
COPY scripts/create-7zs.sh /usr/local/bin
```

```bash
# SSH remote of defacto2
cd /opt/Defacto2-2020

git pull

# Docker rebuild
dc build --no-cache
```

# Run the scripts.

```bash
# SSH remote of defacto2
cd /opt/Defacto2-2020

# Docker execute bash (new)
docker exec --tty dw-app bash
# Docker execute bash (old)
dc exec webapp bash

# scripts location
ls /usr/local/bin/
```