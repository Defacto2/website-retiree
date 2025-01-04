/*
  RetroTxt in Lucee.
  path: javascript/src/retrotxtcf.js

*/
(() => {
  "use strict";
  const version = new Map()
    .set(`date`, new Date(`4,Jul,2022`))
    .set(`minor`, `5.1`)
    .set(`major`, `21`)
    .set(`display`, ``);

  version.set(
    `display`,
    `${version.get(`major`)}.${version.get(`minor`)} (${version
      .get(`date`)
      .toLocaleDateString()})`
  );

  const retrotxt = new Map().set(
    `viewer`,
    document.getElementById(`retrotxt-viewer`)
  );
  // Disable the configuration menu?
  // When the viewer element is not loaded by CF
  if (retrotxt.get(`viewer`) === null) return;
  // When there is no LocalStorage support, disable the configuration menu
  if (!storageAvailable(`local`)) return;

  retrotxt
    .set(`brand`, document.getElementById(`retrotxt-branding`))
    .set(`canvas`, document.getElementById(`retrotxt-canvas`))
    .set(`clip`, document.getElementById(`copy-canvas`));

  const menus = new Map()
      .set(`config`, document.getElementById(`config-menu`))
      .set(`options`, document.getElementById(`config-menu-options`))
      .set(`status`, document.getElementById(`config-menu-status`))
      .set(`posLeft`, document.getElementById(`retrotxt-left`))
      .set(`posCentre`, document.getElementById(`retrotxt-centre`)),
    fontFamily = {
      mcga: document.getElementById(`dos-font-mcga`),
      monospace: document.getElementById(`dos-font-monospace`),
      topaz2: document.getElementById(`dosFontTopaz2`),
      vga8: document.getElementById(`dos-font-vga8`),
      menu: document.getElementById(`dos-font-menu`),
      title: document.getElementById(`full-font-name`),
      text: document.getElementById(`retrotxt-foot`),
    },
    saved = {
      font: loadShift(`dosfont`),
      colour: loadShift(`doscolour`),
      pos: loadShift(`dosposition`),
    },
    txt = {
      black: document.getElementById(`dos-font-black`),
      dos: document.getElementById(`dos-font-dos`),
      modern: document.getElementById(`dos-font-modern`),
      green: document.getElementById(`dos-font-green`),
      white: document.getElementById(`dosfont-white`),
    };

  // defaults for if local storage returns an invalid value
  const missing = -1;
  if (saved.font.length === missing) saved.font = `vga8`;
  if (saved.colour.length === missing) saved.colour = `white`;
  if (saved.pos.length === missing) saved.pos = `auto`;

  // topaz2 amiga font style override for text for amiga platform
  if (fontFamily.topaz2 !== null) {
    saved.font = `topaz2`;
  }

  // apply CSS styles
  shiftStyle(saved.colour, saved.font);
  markStyle(saved.colour, saved.font, saved.pos);

  // event handlers
  // VGA8
  if (fontFamily.vga8 !== null) {
    fontFamily.vga8.addEventListener(`click`, () => {
      clickEvent(`dosfont`, `vga8`);
    });
  }
  // MCGA
  if (fontFamily.mcga !== null) {
    fontFamily.mcga.addEventListener(`click`, () => {
      clickEvent(`dosfont`, `mcga`);
    });
  }
  // Monospace
  if (fontFamily.monospace !== null) {
    fontFamily.monospace.addEventListener(`click`, () => {
      clickEvent(`dosfont`, `monospace`);
    });
  }
  // Topaz2
  if (fontFamily.topaz2 !== null) {
    // do not monitor click events
  }
  // Canvas positions
  menus.get(`posLeft`).addEventListener(`click`, () => {
    clickEvent(`position`, `initial`);
  });
  menus.get(`posCentre`).addEventListener(`click`, () => {
    clickEvent(`position`, `auto`);
  });
  // Black style
  txt.black.addEventListener(`click`, () => {
    clickEvent(`doscolour`, `black`);
  });
  txt.black.addEventListener(`mouseover`, () => {
    mouseOverEvent(`doscolour`, `black`);
  });
  txt.black.addEventListener(`mouseleave`, () => {
    shiftStyle(saved.colour, saved.font);
  });
  // DOS style
  txt.dos.addEventListener(`click`, () => {
    clickEvent(`doscolour`, `dos`);
  });
  txt.dos.addEventListener(`mouseover`, () => {
    mouseOverEvent(`doscolour`, `dos`);
  });
  txt.dos.addEventListener(`mouseleave`, () => {
    shiftStyle(saved.colour, saved.font);
  });
  // Modern style
  txt.modern.addEventListener(`click`, () => {
    clickEvent(`doscolour`, `modern`);
  });
  txt.modern.addEventListener(`mouseover`, () => {
    mouseOverEvent(`doscolour`, `modern`);
  });
  txt.modern.addEventListener(`mouseleave`, () => {
    shiftStyle(saved.colour, saved.font);
  });
  // Green style
  txt.green.addEventListener(`click`, () => {
    clickEvent(`doscolour`, `green`);
  });
  txt.green.addEventListener(`mouseover`, () => {
    mouseOverEvent(`doscolour`, `green`);
  });
  txt.green.addEventListener(`mouseleave`, () => {
    shiftStyle(saved.colour, saved.font);
  });
  // White style
  txt.white.addEventListener(`click`, () => {
    clickEvent(`doscolour`, `white`);
  });
  txt.white.addEventListener(`mouseover`, () => {
    mouseOverEvent(`doscolour`, `white`);
  });
  txt.white.addEventListener(`mouseleave`, () => {
    shiftStyle(saved.colour, saved.font);
  });
  // restore to saved font & style after mouseover preview
  retrotxt.get(`viewer`).addEventListener(`mouseleave`, () => {
    shiftStyle(saved.colour, saved.font);
  });
  // copy text to clipboard
  if (typeof navigator.clipboard === `undefined`)
    retrotxt.get(`clip`).classList.add(`hidden`);
  else
    retrotxt.get(`clip`).addEventListener(`click`, () => {
      clipText(`retrotxt-canvas`);
    });
  // configuration menu
  menus.get(`config`).addEventListener(`click`, () => {
    if (menus.get(`options`).classList.contains(`hide-true`)) {
      menus.get(`options`).classList.remove(`hide-true`);
      menus.get(`options`).classList.add(`hide-false`);
      menus.get(`status`).textContent = `-`;
      retrotxt.get(`brand`).textContent = `v${version.get(`display`)}`;
      return;
    }
    menus.get(`options`).classList.remove(`hide-false`);
    menus.get(`options`).classList.add(`hide-true`);
    menus.get(`status`).textContent = `+`;
  });

  // display font family and colour menu
  const colourize = () => {
    if (saved.colour === `black`)
      return `display: block; color: black; background-color: white;`;
    return `display: block;`;
  };
  fontFamily.menu.style.cssText = colourize();

  /**
   * Font menu mouse over event handler.
   *
   * @param {string} [name=``] Name of the LocalStorage item.
   * @param {string} [value=``] Value of the LocalStorage item.
   */
  function mouseOverEvent(name = ``, value = ``) {
    switch (name) {
      case `doscolour`:
        return shiftStyle(value, saved.font);
      case `dosfont`:
        return shiftStyle(saved.colour, value);
      default:
        throw Error(`unknown mouse over event name ${name}`);
    }
  }
  /**
   * Font menu on-click event handler.
   *
   * @param {string} [name=``] Name of the LocalStorage item.
   * @param {string} [value=``] Value of the LocalStorage item.
   */
  function clickEvent(name = ``, value = ``) {
    saveShift(name, value);
    switch (name) {
      case `doscolour`:
        saved.colour = value;
        break;
      case `dosfont`:
        saved.font = value;
        break;
      case `position`:
        saved.pos = value;
        break;
      default:
        throw Error(`unknown click event name ${name}`);
    }
    markStyle(saved.colour, saved.font, saved.pos);
    shiftStyle(saved.colour, saved.font);
  }

  function fileHumanizeSize(size = 0) {
    const three = 3,
      round = 100,
      kB = 1000,
      MB = Math.pow(kB, 2),
      GB = Math.pow(kB, three);
    if (size > GB)
      return `${(Math.round((size * round) / GB) / round).toFixed(2)} GB`;
    if (size > MB)
      return `${(Math.round((size * round) / MB) / round).toFixed(1)} MB`;
    if (size > kB)
      return `${(Math.round((size * round) / kB) / round).toFixed()} kB`;
    return `${Math.round(size).toFixed()} bytes`;
  }

  /**
   * Copies the text of the element to the browser clipboard.
   *
   * @param {string} [id=``] ID of the element
   */
  function clipText(id = ``) {
    const element = document.getElementById(id);
    if (element === null) throw Error(`select text element "${id}" is missing`);
    navigator.clipboard.writeText(`${element.textContent}`).then(
      function () {
        console.log(
          `Copied ${fileHumanizeSize(
            element.textContent.length
          )} to the clipboard`
        );
        const button = document.getElementById(`copy-canvas`),
          oneSecond = 1000;
        if (button === null) return;
        const save = button.textContent;
        button.textContent = `✓ Copied`;
        window.setTimeout(() => {
          button.textContent = `${save}`;
        }, oneSecond);
      },
      function (err) {
        console.error(`could not save any text to the clipboard: ${err}`);
      }
    );
  }

  /**
   * Load font choices from the LocalStorage
   *
   * @param {string} [name=``] Name of the LocalStorage item
   * @returns LocalStorage value
   */
  function loadShift(name = ``) {
    const colours = [`black`, `dos`, `modern`, `green`, `white`],
      fonts = [`mcga`, `monospace`, `vga8`],
      positions = [`auto`, `initial`];
    /**
     * Determines if the local storage value is valid
     *
     * @param {string} [name=``] Name of the LocalStorage item.
     * @param {string} [value=``] Value of the LocalStorage item.
     * @returns boolean
     */
    const validate = (store = ``, value = ``) => {
      const missing = -1;
      let i = missing;
      switch (store) {
        case `dosfont`:
          i = fonts.indexOf(value);
          break;
        case `doscolour`:
          i = colours.indexOf(value);
          break;
        case `dosposition`:
          i = positions.indexOf(value);
          break;
        default:
          throw Error(`unknown loadshift validate name ${name}`);
      }
      switch (i) {
        case missing:
          return false;
        default:
          return true;
      }
    };

    let data = ``,
      valid = false;

    switch (name) {
      case `dosfont`:
        switch (typeof localStorage.dosfont) {
          case `undefined`:
            data = `vga8`;
            valid = true;
            break;
          default:
            data = localStorage.dosfont;
            valid = validate(`dosfont`, data);
        }
        break;
      case `doscolour`:
        switch (typeof localStorage.doscolour) {
          case `undefined`:
            data = `white`;
            valid = true;
            break;
          default:
            data = localStorage.doscolour;
            valid = validate(`doscolour`, data);
        }
        break;
      case `dosposition`:
        switch (typeof localStorage.dosposition) {
          case `undefined`:
            data = `auto`;
            valid = true;
            break;
          default:
            data = localStorage.dosposition;
            valid = validate(`dosposition`, data);
        }
        break;
      default:
        console.error(`invalid localStorage name ${name}`);
        return ``;
    }
    if (valid === false) {
      console.warn(`Invalid localStorage data value "${data}" for "${name}"`);
      return ``;
    }
    return data;
  }
  /**
   * Save font choices to the LocalStorage
   *
   * @param {string} [name=``] Name of the LocalStorage item.
   * @param {string} [value=``] Value of the LocalStorage item.
   */
  function saveShift(name = ``, value = ``) {
    switch (name) {
      case `dosfont`:
        switch (value) {
          case `vga8`:
            // VGA8 is default so no need to save it to storage
            return localStorage.removeItem(`dosfont`);
          default:
            return localStorage.setItem(`dosfont`, value);
        }
      case `doscolour`:
        switch (value) {
          case `white`:
            // White is default
            return localStorage.removeItem(`doscolour`);
          default:
            return localStorage.setItem(`doscolour`, value);
        }
      case `position`:
        switch (value) {
          case `auto`:
            // Left is default
            return localStorage.removeItem(`dosposition`);
          default:
            return localStorage.setItem(`dosposition`, value);
        }
      default:
        console.error(`invalid localStorage name ${name}`);
    }
  }
  /**
   * Mark the active colour, font and position choices
   *
   * @param {string} [colour=``] Active colour name
   * @param {string} [font=``] Active font name
   * @param {string} [position=``] Active position name
   */
  function markStyle(colour = ``, font = ``, position = ``) {
    const mark = `►`;
    // remove any existing marks
    if (fontFamily.mcga !== null) {
      const mcga = fontFamily.mcga.textContent;
      fontFamily.mcga.textContent = mcga.replace(mark, ``);
    }
    if (fontFamily.monospace !== null) {
      const mono = fontFamily.monospace.textContent;
      fontFamily.monospace.textContent = mono.replace(mark, ``);
    }
    if (fontFamily.vga8 !== null) {
      const vga8 = fontFamily.vga8.textContent;
      fontFamily.vga8.textContent = vga8.replace(mark, ``);
    }
    if (fontFamily.topaz2 !== null) {
      const topaz2 = fontFamily.topaz2.textContent;
      fontFamily.topaz2.textContent = topaz2.replace(mark, ``);
    }
    const left = menus.get(`posLeft`).textContent,
      cent = menus.get(`posCentre`).textContent;
    menus.get(`posLeft`).textContent = left.replace(mark, ``);
    menus.get(`posCentre`).textContent = cent.replace(mark, ``);
    txt.black.textContent = txt.black.textContent.replace(mark, ``);
    txt.modern.textContent = txt.modern.textContent.replace(mark, ``);
    txt.dos.textContent = txt.dos.textContent.replace(mark, ``);
    txt.green.textContent = txt.green.textContent.replace(mark, ``);
    txt.white.textContent = txt.white.textContent.replace(mark, ``);
    // apply new marks
    switch (colour) {
      case `black`:
        txt.black.textContent = mark + txt.black.textContent;
        break;
      case `dos`:
        txt.dos.textContent = mark + txt.dos.textContent;
        break;
      case `green`:
        txt.green.textContent = mark + txt.green.textContent;
        break;
      case `white`:
        txt.white.textContent = mark + txt.white.textContent;
        break;
      case `modern`:
        txt.modern.textContent = mark + txt.modern.textContent;
        break;
      // black is the default and the fall back colour
      default:
        txt.black.textContent = mark + txt.black.textContent;
        break;
    }
    switch (font) {
      case `mcga`:
        fontFamily.mcga.textContent = mark + fontFamily.mcga.textContent;
        break;
      case `monospace`:
        fontFamily.monospace.textContent =
          mark + fontFamily.monospace.textContent;
        break;
      // vga8 font the default and a fall back font
      default:
        if (fontFamily.topaz2 !== null)
          fontFamily.topaz2.textContent = mark + fontFamily.topaz2.textContent;
        else if (fontFamily.vga8 !== null)
          fontFamily.vga8.textContent = mark + fontFamily.vga8.textContent;
        break;
    }
    switch (position) {
      case `initial`:
        menus.get(`posLeft`).textContent =
          mark + menus.get(`posLeft`).textContent;
        break;
      case `auto`:
        menus.get(`posCentre`).textContent =
          mark + menus.get(`posCentre`).textContent;
        break;
      default:
        throw Error(`unknown mark style position ${position}`);
    }
  }
  /**
   * Implement colour, font and position choices
   *
   * @param {string} [colour=``] Active colour name
   * @param {string} [font=``] Active font name
   * @param {string} [position=``] Active position name
   */
  function shiftStyle(colour = ``, font = ``) {
    const black = `background-color:black;`,
      white = `background-color:white;`,
      modc = `color:rgba(220,220,204,1);`,
      modbg = `background-color:rgba(64,64,64,1);`;
    let styleCanvas = ``,
      fontName = ``,
      styleFont = ``,
      styleFoot = `color:#aaa;${black}`,
      styleHref = `color:#aaa;`,
      styleMenu = `display:block;${black}`,
      styleViewer = ``,
      styleWhite = `color:white;${black}`;
    switch (colour) {
      case `black`:
        styleCanvas = `color:black;${white}`;
        styleFoot = `color:black;${white}`;
        styleHref = `color:black;`;
        styleMenu = `display:block;color:black;${white}`;
        styleWhite = `color:white;${black}`;
        styleViewer = `${white}`;
        break;
      case `modern`:
        styleCanvas = `${modc} ${modbg}`;
        styleFoot = `${modc} ${modbg}`;
        styleHref = `${modc}`;
        styleMenu = `display: block; ${modc} ${modbg}`;
        styleWhite = `color:white; ${modbg}`;
        styleViewer = `${modbg}`;
        break;
      case `green`:
        styleCanvas = `color:rgba(0,255,0,1);${black}`;
        styleViewer = `${black}`;
        // amber color: rgba(185,128,0,1)
        break;
      case `dos`:
        styleCanvas = `color:#aaa; ${black}`;
        styleViewer = `${black}`;
        break;
      default:
        // White colour is default and fall-back
        styleCanvas = `color:white; ${black}`;
        styleViewer = `${black}`;
        break;
    }
    const defaultColumns = 80;
    const canvas = document
      .getElementById(`retrotxt-canvas`)
      .textContent.split(`\n`);
    let columns = 0;
    for (const line of canvas) {
      if (line.length > columns) columns = line.length;
    }
    if (columns < defaultColumns) columns = defaultColumns;

    switch (font) {
      case `mcga`:
        styleFont = `font-family: font-mcga; max-width: ${columns}rem;`;
        styleViewer += `max-width: ${columns}rem;`;
        fontName = `IBM ISO9+`;
        break;
      case `monospace`:
        styleFont = `font-family: monospace; max-width: ${columns}rem;`;
        styleViewer += `max-width: ${columns}rem;`;
        fontName = `Monospace`;
        break;
      case `topaz2`:
        // 80 cols x 25 rows - 640x400 8x16 font
        styleFont = `font-family: font-topaz-two; max-width: ${columns}rem;`;
        styleViewer += `max-width: ${columns}rem;`;
        fontName = `Amiga Topaz2`;
        break;
      case `vga8`:
        // vga8
        // 80 cols x 25 rows - 640x400 8x16 font
        // columns * eightPixels
        styleFont = `font-family: font-vga-eight; max-width: ${columns}rem;`;
        styleViewer += `max-width: ${columns}rem;`;
        fontName = `IBM VGA8+`;
        break;
      default:
    }
    fontFamily.title.textContent = `Font ${fontName} `;
    const link = document.createElement(`a`);
    switch (font) {
      case `monospace`:
        break;
      case `topaz2`:
        link.textContent = `dMG`;
        link.href = `https://www.trueschool.se`;
        fontFamily.title.append(link);
        break;
      default:
        link.textContent = `VileR`;
        link.href = `https://int10h.org/oldschool-pc-fonts/`;
        fontFamily.title.append(link);
    }
    // note in Strict mode you must use .style.cssText for IE/Edge compatibility
    // see: https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement/style
    retrotxt.get(`canvas`).style.cssText = `${styleCanvas} ${styleFont} `;
    retrotxt.get(`viewer`).style.cssText = styleViewer;

    fontFamily.text.style.cssText = styleFoot;
    fontFamily.menu.style.cssText = styleMenu;
    if (fontFamily.mcga !== null) fontFamily.mcga.style.cssText = styleHref;
    if (fontFamily.vga8 !== null) fontFamily.vga8.style.cssText = styleHref;
    if (fontFamily.monospace !== null)
      fontFamily.monospace.style.cssText = styleHref;
    if (fontFamily.topaz2 !== null) fontFamily.topaz2.style.cssText = styleHref;
    txt.white.style.cssText = styleWhite;
  }

  console.info(
    `Loaded RetroTxt on CF ${version.get(`display`)} (retrotxtcf.js)`
  );
})();
