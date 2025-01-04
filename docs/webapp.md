> [!WARNING]
> This documentation is retired and maybe inaccurate.

# Web application

The core of Defacto2 runs on [Lucee](http://lucee.org/), a CFML scripting language for web development that runs on the Java Virtual Machine. This document contains a collection of notes on what can be configured and modified for this deployment of the Defacto2 web application.

### Frameworks and dependencies

The application uses a number of frameworks and dependencies that are managed through [yarn package](../package.json) `package.json` and [nginx aliases](../docker_assets/nginx/aliases.conf) `aliases.conf`.

- **[CFWheels v2](http://cfwheels.org)**
- **[Bootstrap v3](https://getbootstrap.com/docs/3.4/)** and **[JQuery](https://jquery.com)**
- **[Font Awesome](http://fortawesome.github.io/Font-Awesome/)**

### Commandline utilities

The application uses the following command line tools that will need to be installed to the operating system.

- **[AnsiLove-C](https://github.com/ansilove/AnsiLove-C)** is compiled and installed through Dockerfile.
- **[GraphicsMagick](http://www.graphicsmagick.org/)** is installed and deals with image conversion plus thumbnail generation.

A number of other file utilities such as `arc fdupes p7zip-full pngquant tofrodos unrar-free` get installed using the `apt` package manager that's run in the [Dockerfile](../docker_assets/lucee/Dockerfile).

```bash
sudo apt-get -y install arc /
fdupes graphicsmagick p7zip-full /
pngquant tofrodos unrar unzip zipinfo
```

### Directory `ROOT/config/`

`config/` contains all the configuration files in use by CFWheels and Defacto2. These setting files are all coded in ColdFusion Markup (CFML).

To apply any changes to these settings you will need to either:

- reload the CFWheels framework.
- restart the Lucee server.
- shutdown and restart the Docker container.

See [How To Switch Modes](http://cfwheels.org/docs/1-1/chapter/switching-environments) in CFWheels and [a list of CFWheels settings and defaults](http://cfwheels.org/docs/1-1/chapter/configuration-and-defaults).

---

### Four CFWheels environments

The following are settings you can apply depending on which environment is set.

- **Production** is the default environment a public server should be operating as.
- **Development** and **Testing** environments.<br>
  These should only be used on private or local servers as they are designed for programming and testing.
- **Maintenance** takes the CFWheels offline.

[Switching Environments](http://cfwheels.org/docs/1-1/chapter/switching-environments).

```shell
ROOT/config/

development/settings.cfm
maintenance/settings.cfm
production/settings.cfm
testing/settings.cfm
```

---

### The following files contain CFWheels settings

#### `ROOT/config/app.cfm`

Is used by CFWheels to emulate the Lucee `Application.cfc`.<br>[Application.CFC reference](https://wikidocs.adobe.com/wiki/display/coldfusionen/Application.CFC+Reference).

**There are some critical Defacto2 settings accessed from within `app.cfm`**

#### `ROOT/config/environment.cfm`

Lucee `APPLICATION` scope variables are applied here. These are variables that remain in memory until the server is reset or times out.

#### `ROOT/config/routes.cfm`

Contains hard coded URL routes and redirections used by Cfwheels.<br>[Using routes](http://docs.cfwheels.org/v1.4/docs/using-routes).

#### `ROOT/config/settings.cfm`

Contains a collection of settings saved to variables as well as dynamically generated links to various `ROOT/config/settings/*.cfm` files contained within the same directory.

---

### Test server

Defacto2 uses a variable named `application.testServer` which contains an IP address. When the host server is running on this IP address the application changes some critical settings intended for for a developer server. These configurations are not intended or safe to run as public production applications.

To change the test server IP address this variable setting needs to be changed.

`ROOT/config/settings.cfm`

```js
application.testServer = "localhost";
```

---

### CFWheels and Defacto2 settings and configurations

Information on Cfwheels settings can be found at [configuration-and-defaults](https://guides.cfwheels.org/docs/configuration-and-defaults).<br>All Defacto2 specific settings start with the variable name `myapp.`

`ROOT/config/`

`settings-application.cfm`<br>
Includes IP exceptions/restrictions, load timeouts and miscellaneous settings.

`settings-menus.cfm`<br>
Dynamic menu text, menu descriptions and URLs used with user navigation.

`settings-navigation.cfm`<br>
Defaults values for page navigation and data filters.

`settings-paths.cfm`<br>
Directory locations and application dependencies paths.

`settings-uploads.cfm`<br>
File upload settings and permissions.

`settings-webapps.cfm`<br>
URLs and account names for external services used by Defacto2 like Pouet and Demozoo.

---

### JS

- JS source code use the `.js` extension are stored in `/ROOT/javascripts/src`.
- JS files used in production are compress and minified using [UglifyJS](https://github.com/mishoo/UglifyJS).
- Production ready external files are placed in `javascripts/` and use the `.min.js` extension.

All JS are written in ES6 syntax and use [eslint](https://marketplace.visualstudio.com/items?itemName=dbaeumer.vscode-eslint) and [Prettier](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode).

Both should be install locally for use with with Visual Studio Code.

---

### CSS

Defacto2 uses [LESS](http://lesscss.org/) for its custom CSS documents.

All `.less` files found in `stylesheets/src/` are editable Defacto2 CSS documents.<br>
To convert a `.less` document into a CSS document a LESS compiler needs to be used.

External CSS and LESS documents used in production are compressed and minified using [clean-css](https://github.com/jakubpawlowicz/clean-css-cli).<br>
These files are placed in `stylesheets/` and used the `.min.css` extension.
