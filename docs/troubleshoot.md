> [!WARNING]
> This documentation is retired and maybe inaccurate.

# Troubleshoot

### [Docker for Windows](https://docs.docker.com/docker-for-windows/troubleshoot/)

There maybe unusual file creation and deletion issues when running this service over Windows due to the use of Docker bind volumes with the containers.

### [Docker for macOS](https://docs.docker.com/docker-for-mac/troubleshoot/)

See link.

### Cleanup and reduce space usage

```
# What is taking up drive space?
docker system df -v

# Cleanup
docker system prune

# Cleanup inc. unused volumes
docker system prune --volumes

# Cleanup all unused images
docker system prune --all
```

### Restart Docker Desktop

The most common cause of failures in Docker Desktop is from overuse. This is
especially true for users on laptops that only sleep but do not restart their operating systems.

If things stop working unexpectantly or throw unusual errors when they were
previously working okay, restart Docker Desktop.

```sh
cd Defacto2-2020
docker compose down; docker compose up
```

### Check configurations

```sh
cd Defacto2-2020
# check Docker
docker compose config
# test nginx
docker compose exec webapp nginx -t
# tomcat version
docker compose exec webapp version.sh
```

### Permissions

Check the permissions of directories and files on the host and in the container.
Docker Desktop on Windows for example has hardcoded file permission bits on Linux containers.

### List services

```sh
cd Defacto2-2020
docker compose config --services
```

### List volumes

```sh
cd Defacto2-2020
docker compose config --volumes
```

### List logs and output

```sh
cd Defacto2-2020
docker compose logs # view all services
docker compose logs webapp
```

### [Further Docker Compose tips for defacto2.net](docker-compose.md)
