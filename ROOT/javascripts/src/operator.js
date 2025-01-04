/*
  1) Keyboard combination events, Ctrl+Alt + keypress.
  2) Query string generation for operator menus.
  3) Local browser time for the hardware page.
  path: javascript/src/operator.js

*/
(() => {
  "use strict";

  // Query strings for menu URLs
  queryString();

  // Local browser time
  const clock = document.getElementById(`localbrowsertime`);
  if (clock !== null) localTime(clock);

  // Keyboard keydown event listeners
  // https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent/key
  document.addEventListener(
    `keydown`,
    (event) => {
      const macOS = Boolean(
        1 + navigator.platform.toLowerCase().indexOf(`mac`)
      );
      // do not alert when only Control key is pressed.
      if ([`Meta`, `Alt`].includes(event.key)) return;
      if (!event.altKey && !macOS) return;
      if (!event.metaKey && macOS) return;
      // Even though event.key is not 'Control' (e.g., 'a' is pressed),
      // event.ctrlKey may be true if Ctrl key is pressed at the same time.
      if (!event.ctrlKey) return;
      keyboard(event.key, event.code);
    },
    false
  );

  /**
   * Simulate a button click visualisation by cycling between two Bootstrap colours
   *
   * @param {*} elm A button element
   * @param {string} [replacement=``] The Bootstrap colour class to display for 1 second
   * @param {string} [original=``] The original button class to reapply afterwards
   */
  function animate(elm, replacement = ``, original = ``) {
    if (typeof elm === `undefined`)
      throw Error(`animate button element is missing`);
    elm.classList.toggle(`${replacement}`);
    elm.classList.toggle(`${original}`);
    const oneSecond = 1000;
    setTimeout(() => {
      elm.classList.toggle(`${replacement}`);
      elm.classList.toggle(`${original}`);
    }, oneSecond);
  }

  function keyboard(key, code) {
    let elm;
    // Ctrl + Alt + key
    // NOTE: the following are reserved
    // d  download file
    // i  items archive
    // t  chiptune player
    console.log(key, code);
    switch (key.toLowerCase()) {
      case `[`:
        elm = document.getElementById(`fofPlatformJS`);
        if (elm === null) return;
        return elm.click();
      case `]`:
        elm = document.getElementById(`fofLabelJS`);
        if (elm === null) return;
        return elm.click();
      case `x`:
        elm = document.getElementById(`form1_reset`);
        if (elm === null) return;
        animate(elm, `btn-info`, `btn-danger`);
        return elm.click();
      case `s`:
        elm = document.getElementById(`saveEditsTop`);
        if (elm === null) return;
        animate(elm, `btn-info`, `btn-primary`);
        elm = document.getElementById(`form1`);
        return elm.submit();
      case `z`:
        elm = document.getElementById(`refresh_thumbs`);
        if (elm === null) return;
        if (elm.disabled === true) return;
        animate(elm, `btn-info`, `btn-default`);
        return elm.click();
      case `p`:
        elm = document.getElementById(`refresh_archive`);
        if (elm === null) return;
        if (elm.disabled === true) return;
        animate(elm, `btn-info`, `btn-default`);
        return elm.click();
      case `=`:
        elm = document.getElementById(`recordActivation`);
        console.log(elm);
        if (elm === null) return;
        return elm.click();
      case `arrowup`:
        elm = document.getElementById(`doseeCaptureUpload`);
        if (elm === null) return;
        if (elm.disabled === true)
          return console.log(`To capture a screenshot DOSee must be running`);
        animate(elm, `btn-info`, `btn-primary`);
        return elm.click();
      case `arrowdown`:
        elm = document.getElementById(`doseeCanvas`);
        if (elm === null) return;
        return elm.click();
      case `end`:
        elm = document.getElementById(`doseeExit`);
        if (elm === null) return;
        return elm.click();
      default:
        switch (code) {
          case `space`:
            elm = document.getElementById(`doseeCanvas`);
            if (elm === null) return;
            return elm.click();
          default:
        }
    }
  }

  function localTime(elmement) {
    if (typeof elmement === `undefined`)
      throw Error(`localtime element is missing`);
    // Local browser time
    const d = new Date(),
      m = [
        `January`,
        `February`,
        `March`,
        `April`,
        `May`,
        `June`,
        `July`,
        `August`,
        `September`,
        `October`,
        `November`,
        `December`,
      ],
      browserDate = `${d.getDate()} ${m[d.getMonth()]} ${d.getFullYear()}`,
      browserTime = `${d.getHours()}:${d.getMinutes()}`;
    elmement.textContent = `${browserDate}, ${browserTime}`;
  }

  function queryString() {
    let output = null,
      sort = null;
    if (storageAvailable(`local`)) {
      output = localStorage.getItem(`output`);
      sort = localStorage.getItem(`sort`);
    }

    let join = `?`;
    if (location.pathname === `/index.cfm`) join = `&`;
    const json = queryStringJSON();
    if (typeof json.output === `string`) {
      output = json.output;
      sort = json.sort;
    }
    if (output === null) output = metaContent(`nav:output`);
    if (sort === null) sort = metaContent(`nav:sort`);

    // apply built query string to operator menus
    const query = String(
      `${join}output=${output}&platform=-&section=-&sort=${sort}`
    );
    if (typeof queryStringBase !== `undefined`) {
      queryStringBase(`jsopmenus`, query);
    }
  }
})();
