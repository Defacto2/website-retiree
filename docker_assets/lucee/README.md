# Lucee Docker container

`.cflintrc` [CFLint](https://github.com/cflint/CFLint) folder-based configuration file.

`scripts/` Contains Linux shell scripts for the maintenance of the container and site.

`WEB-INF/web.xml` The Lucee Java servlet definition. It should not be modified.

`.zshrc` The [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh) configuration for the customisation of Z shell (zsh terminal shell).

`default.conf` **The Defacto2 nginx web server configuration**.

`index.cfm` A test dump page for Lucee and CFWheels.

`nginx_signing.key` The nginx signing key required by the Lucee Docker container.

`nginx.conf` The base nginx web server configuration. It should not be modified.

`supervisord.conf` The [Supervisor](http://supervisord.org) configuration file.

> Supervisor is a client/server system that allows its users to monitor and control a number of processes on UNIX-like operating systems.
