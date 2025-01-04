/*
  RetroTxt color in Lucee.
  path: javascript/src/retrotxt-color.js

*/
(() => {
  ("use strict");
  const version = new Map()
    .set(`date`, new Date(`4,Jul,2022`))
    .set(`minor`, `1`)
    .set(`major`, `1`)
    .set(`display`, ``);

  version.set(
    `display`,
    `${version.get(`major`)}.${version.get(`minor`)} (${version
      .get(`date`)
      .toLocaleDateString()})`
  );

  if (document.getElementById(`retrotxt-viewer`) === null) return;

  const retrotxt = new Map()
    .set(`brand`, document.getElementById(`retrotxt-branding`))
    .set(`canvas`, document.getElementById(`retrotxt-canvas`))
    .set(`viewer`, document.getElementById(`retrotxt-viewer`));

  if (typeof retrotxt.get(`brand`) === `undefined`)
    return console.error(`retrotxt-branding element missing`);
  if (typeof retrotxt.get(`canvas`) === `undefined`)
    return console.error(`retrotxt-canvas element missing`);
  if (typeof retrotxt.get(`viewer`) === `undefined`)
    return console.error(`retrotxt-viewer element missing`);

  const csi = `←[`;
  let textContent = retrotxt.get(`canvas`).textContent;
  // detect ansi color controls or exit
  if (!textContent.includes(csi)) return;

  // known sequences to remove from text
  const purge = new Map([
    [`?7h`, `autowrap`],
    [`?7l`, `no autowrap`],
    [`?25h`, `cursor visible`],
    [`?25l`, `cursor invisible`],
    [`?47h`, `save screen`],
    [`?47l`, `restore screen`],
    [`?1049h`, `enable alternative buffer`],
    [`?1049l`, `disable alternative buffer`],
    [`=7h`, `line wrap`],
    [`J`, `erase`],
    [`0J`, `erase`],
    [`1J`, `erase`],
    [`2J`, `erase screen`],
    [`3J`, `erase saved lines`],
    [`K`, `erase`],
    [`0K`, `erase`],
    [`1K`, `erase`],
    [`2K`, `erase line`],
    [`H`, `cursor to home`],
    [`6n`, `request cursor position`],
    [`s`, `save cursor position`],
    [`u`, `restore cursor to saved position`],
    [`0;0H`, `reset cursor`],
    [`255D`, `cursor back as far as possible`],
  ]);

  // replace private amiga sequences, cursor toggles[?]
  // see: http://amigadev.elowar.com/read/ADCD_2.1/Includes_and_Autodocs_3._guide/node0102.html
  // `0 p` or `0 p[formfeed]` or `1 p`
  const amiRegex = /←\[[0|1] p[\f]?/g;
  textContent = textContent.replaceAll(amiRegex, ``);

  // replace cursor right positions with spaces, ←[#C;
  const cursorRightRegex = /←\[(\d+)(C)/g;
  textContent = textContent.replaceAll(cursorRightRegex, function (p0, p1) {
    return ` `.repeat(p1);
  });

  // remove known escape+space cursor controls
  const miscRegex = /\x27\[[0|1|M|7|8] p/g;
  textContent = textContent.replaceAll(miscRegex, ``);

  // filter out known unusable sequences
  let tc = textContent.split(csi);
  const lines = tc.filter(function (line) {
    const trimmed = line.split(`\n`)[0];
    if (typeof purge.get(trimmed.trim()) !== `undefined`) return false;
    return true;
  });
  tc = null;

  // screen modes
  // =[0|1|2|3|4|5|6|7|13|14|15|16|17|18|19]h
  // cursor controls
  // ESC[0000;0000H
  // ESC[0000;0000f
  // 0000A|B|C|D|E|F|G // move cursor 0000 positions

  // SGR (Select Graphic Rendition) parameters
  const resetAll = 0,
    bold = 1,
    dim = 2,
    italic = 3,
    underline = 4,
    blink = 5,
    blinkFast = 6,
    invert = 7,
    conceal = 8,
    strike = 9,
    fontDefault = 10,
    font1 = 11,
    font2 = 12,
    font3 = 13,
    font4 = 14,
    font5 = 15,
    font6 = 16,
    font7 = 17,
    font8 = 18,
    font9 = 19,
    fontFraktur = 20,
    underline2x = 21,
    // _underscore is used for not
    _intensity = 22,
    _italicFraktur = 23,
    _underline = 24,
    _blink = 25,
    _invert = 27,
    _conceal = 28,
    _strike = 29,
    black = 30,
    red = 31,
    green = 32,
    yellow = 33,
    blue = 34,
    magenta = 35,
    cyan = 36,
    white = 37,
    reserved0 = 38,
    reset0 = 39,
    blackB = 40,
    redB = 41,
    greenB = 42,
    yellowB = 43,
    blueB = 44,
    magentaB = 45,
    cyanB = 46,
    whiteB = 47,
    reserved1 = 48,
    reset1 = 49,
    frame = 51,
    encircle = 52,
    overline = 53,
    _frameEncircle = 54,
    _overline = 55;

  // SGR as CSS style replacements
  const underlineStyle = `text-decoration:underline;text-underline-position:from-font;`;
  const sgr = new Map([
    [resetAll, ``],
    [bold, ``],
    [dim, `font-weight:lighter;`],
    [italic, `font-style:italic;`],
    [underline, underlineStyle],
    [blink, `animation:500ms blink step-end infinite;`],
    [blinkFast, `animation:300ms blink step-end infinite;`],
    [invert, `filter:invert(1);`],
    [conceal, `hide`],
    [strike, `text-decoration:line-through;`],
    [fontDefault, ``],
    [font1, ``],
    [font2, ``],
    [font3, ``],
    [font4, ``],
    [font5, ``],
    [font6, ``],
    [font7, ``],
    [font8, ``],
    [font9, ``],
    [fontFraktur, ``],
    [underline2x, `${underlineStyle}text-decoration-style:double;`],
    [_intensity, ``],
    [_italicFraktur, ``],
    [_underline, ``],
    [_blink, ``],
    [_invert, ``],
    [_conceal, ``],
    [_strike, ``],
    [black, `sg30`],
    [red, `sg31`],
    [green, `sg32`],
    [yellow, `sg33`],
    [blue, `sg34`],
    [magenta, `sg35`],
    [cyan, `sg36`],
    [white, `sg37`],
    [reserved0, ``],
    [reset0, ``],
    [blackB, `sg40`],
    [redB, `sg41`],
    [greenB, `sg42`],
    [yellowB, `sg43`],
    [blueB, `sg44`],
    [magentaB, `sg45`],
    [cyanB, `sg46`],
    [whiteB, `sg47`],
    [reserved1, ``],
    [reset1, ``],
    [frame, ``],
    [encircle, ``],
    [overline, ``],
    [_frameEncircle, ``],
    [_overline, ``],
  ]);

  let flagged = newFlags();
  replaceAll();
  resize();

  // newFlags returns a Map used to track various SGR modes.
  // This is also used by the reset all modes sequence.
  function newFlags() {
    return new Map([
      [`foreground`, ``],
      [`background`, ``],
      [bold, false],
      [dim, false],
      [italic, false],
      [blink, false],
      [blinkFast, false],
      [strike, false],
      [underline, false],
      [invert, false],
      [underline2x, false],
    ]);
  }

  // replaceAll replaces all set graphics modes sequences in
  // the text content with HTML span elements.
  function replaceAll() {
    // ([\s\S]*) zero or more white and non-whitespace chars
    const sgrRegex = /m[\s\S]*/;
    const pre = retrotxt.get(`canvas`);
    pre.textContent = ``;
    for (const line of lines) {
      const sgrMatch = line.match(sgrRegex);
      if (sgrMatch === null) {
        if (line === ``) continue;
        const span = document.createElement(`span`);
        span.textContent = `${line}`;
        pre.append(span);
        continue;
      }
      const slice = line.substring(0, sgrMatch.index);
      const params = marshall(slice);
      const span = element(params, `${line.substring(sgrMatch.index + 1)}`);
      pre.append(span);
    }
  }

  // marshall takes the slice of set graphics modes characters,
  // and returns them as an array of integers.
  function marshall(slice = ``) {
    const array = slice.split(`;`);
    const params = [];
    for (const val of array) {
      params.push(parseInt(val, 10));
    }
    return params;
  }

  // element takes the text content and encloses it around a
  // span element, with the class and style values set by
  // the params array of integers representing SGR paramater values.
  function element(params = [], content = ``) {
    const span = document.createElement(`span`);
    span.textContent = content;
    for (const param of params) {
      const got = sgr.get(param);
      if (param === resetAll) {
        flagged = newFlags();
        continue;
      }
      const bld = flagged.get(bold);
      const brightBase = 60;
      if (param >= black && param <= white) {
        if (bld === false) flagged.set(`foreground`, `${got}`);
        else flagged.set(`foreground`, `sg${param + brightBase}`);
      }
      if (param >= blackB && param <= whiteB) {
        flagged.set(`background`, `${got}`);
      }
      switch (param) {
        case reset0:
          flagged.set(`foreground`, ``);
          break;
        case reset1:
          flagged.set(`background`, ``);
          break;
        case bold:
          flagged.set(bold, true);
          break;
        case dim:
          flagged.set(dim, true);
          break;
        case _intensity:
          flagged.set(bold, false);
          flagged.set(dim, false);
          break;
        case italic:
          flagged.set(italic, true);
          break;
        case _italicFraktur:
          flagged.set(italic, false);
          break;
        case blink:
          flagged.set(blink, true);
          flagged.set(blinkFast, false);
          break;
        case blinkFast:
          flagged.set(blink, false);
          flagged.set(blinkFast, true);
          break;
        case _blink:
          flagged.set(blink, false);
          flagged.set(blinkFast, false);
          break;
        case strike:
          flagged.set(strike, true);
          break;
        case _strike:
          flagged.set(strike, false);
          break;
        case underline:
          flagged.set(underline, true);
          break;
        case underline2x:
          flagged.set(underline2x, true);
          break;
        case _underline:
          flagged.set(underline, false);
          flagged.set(underline2x, false);
          break;
        case invert:
          flagged.set(invert, true);
          break;
        case _invert:
          flagged.set(invert, false);
          break;
        default:
      }

      const classes = [];
      let style = ``;
      const fg = flagged.get(`foreground`),
        bg = flagged.get(`background`);
      if (fg.length) classes.push(`${fg}`);
      if (bg.length) classes.push(`${bg}`);
      if (flagged.get(dim)) style = `${style}${sgr.get(dim)}`;
      if (flagged.get(italic)) style = `${style}${sgr.get(italic)}`;
      if (flagged.get(strike)) style = `${style}${sgr.get(strike)}`;
      if (flagged.get(underline)) style = `${style}${sgr.get(underline)}`;
      if (flagged.get(underline2x)) style = `${style}${sgr.get(underline2x)}`;
      if (flagged.get(invert)) style = `${style}${sgr.get(invert)}`;

      if (style.length) span.setAttribute(`style`, `${style.trim()}`);
      if (classes.length > 0) {
        for (const cls of classes) {
          span.classList.add(cls);
        }
      }
    }
    return span;
  }

  // resize the text content canvas after all the known SGR and
  // escaped control sequences have been removed from the text.
  function resize() {
    const defaultColumns = 80;
    const wideFont = 9;
    const canvas = retrotxt.get(`canvas`).textContent.split(`\n`);
    let columns = 0;
    for (const line of canvas) {
      if (line.length > columns) columns = line.length;
    }
    if (columns < defaultColumns) columns = defaultColumns;

    const footerSize = document.getElementById(`full-font-size`);
    footerSize.textContent = `${columns}x${canvas.length}`;
    const ff = retrotxt.get(`canvas`).style.fontFamily;
    let fontWidth = 8;
    switch (ff) {
      case `mcga`:
      case `monospace`:
        fontWidth = wideFont;
        break;
      default:
    }
    const mw = columns * fontWidth;
    retrotxt.get(`canvas`).style.maxWidth = `${mw}px`;
    retrotxt.get(`canvas`).style.paddingRight = `2px`;
    retrotxt.get(`viewer`).style.maxWidth = `${mw}px`;
  }

  console.info(
    `Loaded RetroTxt color mode ${version.get(`display`)} (retrotxt-color.js)`
  );
})();
