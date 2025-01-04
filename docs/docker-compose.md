> [!WARNING]
> This documentation is retired and maybe inaccurate.

# Tips for Docker Compose

- Docker containers act as individual, isolated servers with their own file systems.
- They communicate over a shared local network using TCP ports.
- They can share individual files using volume binding.
- They can share folders with the host using volume binding.
- They can share folders between containers using non-bind volumes.

### To start and stop

```sh
cd Defacto2-2020
docker compose up # Press Ctrl+C to exit
```

### Start in the background and stop

```sh
cd Defacto2-2020
# launch and run in the background
docker compose up -d
# list containers
docker compose ps
# stop and shutdown
docker compose down
```

### Update images to new versions under the same tags

```sh
cd Defacto2-2020

# updates individual images
docker pull lucee/lucee:5.3-nginx

# only updates the images listed in docker compose
docker compose pull
```

### Rebuild and start

A use-case would be after edits to values in `docker compose.yml` or `.env`

```sh
cd Defacto2-2020
docker compose up --build
```

### Display images in use

```sh
cd Defacto2-2020
docker compose images
```

### Gain shell access to a service

```sh
cd Defacto2-2020
# shell access to the Lucee app
docker compose exec webapp bash
```

```sh
cd Defacto2-2020
# shell access to the database
docker compose exec db bash
```

To exit run `exit` in the shell.

### Dump the MySQL database to the host computer

```sh
cd Defacto2-2020
docker compose exec db mysqldump \
--password=password \
--single-transaction \
--databases defacto2-inno > defacto2.sql
```

### Display the operating system environment variables

```sh
cd Defacto2-2020
docker compose exec webapp env
```

### Display the operating system version

```sh
cd Defacto2-2020
docker compose exec webapp lsb_release -a
```

### [Troubleshooting](troubleshoot.md)
