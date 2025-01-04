# CFWheels Updates

[Instructions for upgrading CFWheels applications](https://guides.cfwheels.org/docs/upgrading)

To update the CFWheels version you must delete the associated
Docker volume and run rebuild in docker-compose.

```bash
dc down
docker volume ls
docker volume rm --force [...]_cf_wheels
dc build
```

https://github.com/cfwheels/cfwheels/releases
