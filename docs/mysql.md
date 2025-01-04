> [!WARNING]
> This documentation is retired and maybe inaccurate.

# MySQL

## New user account

Create a new user for the [df2 command line tool](https://github.com/Defacto2/df2).

```sh
docker --tty exec db bash
```

> `root@????:/# _`

```sh
# sign in to the database
mysql -u root -p
> Enter password: ****
```

From within the `mysql>` prompt, use the `mysql` database.

```mysql
mysql> use mysql;
> Database changed
```

Create the user `df2` with remote access and set its permissions.

```mysql
create user 'df2'@'%' identified by 'NEWPASSWORD';
update user set Select_priv=2, Insert_priv=2, Update_priv=2 where User='df2';
```

Confirm changes, quit and exit mysql.

```mysql
flush privileges;
quit;
```

## MySQL root password

Update the `root` user password in the database.

```sh
docker --tty exec db bash
```

> `root@????:/# _`

```sh
# sign in to the database
mysql -u root -p
> Enter password: ****
```

From within the MySQL prompt, choose the `mysql` database.

```mysql
mysql> use mysql;
> Database changed
```

The root host `%` is used for Adminer logins while `localhost` is for terminal mysql logins.

```mysql
update user set authentication_string=PASSWORD("NEWPASSWORD") where User='root' and Host='%';
update user set authentication_string=PASSWORD("NEWPASSWORD") where User='root' and Host='localhost';
```

Confirm changes, quit and exit mysql.

```mysql
flush privileges;
quit;
```

### Update site configurations

Edit `.config/defacto2.json`.

```json
{
  "mysql": {
    "host": "db",
    "database": "defacto2-inno",
    "username": "root",
    "password": "NEWPASSWORD"
  }
}
```

Edit `.env`.

```
# Insecure passwords
PW_MYSQL=NEWPASSWORD
```

Edit `.config/defacto2-inno`

```
NEWPASSWORD
```

### Reload site configurations

To apply the new password.

```sh
docker compose stop webapp; docker compose up --build -d
```
