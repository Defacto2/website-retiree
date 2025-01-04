> [!WARNING]
> This documentation is retired and maybe inaccurate.

# Update

### Docker compose containers

[Update images to new versions under the same tags](docker-compose.md).


### CfWheels

[Edit Dockerfile](../docker_assets/cfwheels/README.md).

### Nginx configurations

This is only applicable for the `webapp` nginx docker container and is required after any [nginx config file](../docker_assets/nginx/nginx.conf) is changed.

```sh
cd Defacto2-2020
# download and apply updated configs
git pull && dc stop webapp && dc up -d --build webapp

# test for changes
dc run proxy nginx -T
```

---

### JS <small>npm</small> dependencies

The easiest way is to use yarn interactive command.

```sh
pnpm update --interactive           # update minor current versions
pnpm update --interactive --latest  # update to the absolute newest version
pnpm exec grunt copy                # copy any updated library dependencies
```

New dependencies **must** be linked via the [nginx aliases config](../docker_assets/nginx/aliases.conf)  `/docker_assets/nginx/aliases.conf`.

---

### Frontend files, JS, CSS, etc.

Custom assets found in `/ROOT/javascripts` and `/ROOT/stylesheets` will most likely require minification or compilation which is done with [Grunt](https://gruntjs.com/).

```sh
# JS minify and CSS compilation and compression
pnpm exec grunt     # or grunt js or grunt css
```

Static files served by nginx are often **cached** by either the server or Cloudflare.

When testing changes, make sure Cloudflare is in development mode and the browser has its network caching off.

> Temporarily bypass our cache allowing you to see changes to your origin server in realtime.
> <br>[Cloudflare development mode](https://dash.cloudflare.com/a3bd3e6436bd9334f0158023038207a4/defacto2.net)

You may need to clear the Cloudflare cache.

> Clear cached files to force Cloudflare to fetch a fresh version of those files from your web server.
> <br>[Cloudflare purge cache](https://dash.cloudflare.com/a3bd3e6436bd9334f0158023038207a4/defacto2.net)

---

### Operating system command line tools

[See commandline utilities in webapp](webapp.md).
