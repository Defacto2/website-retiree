/*
  Chiptune player
	path: javascript/src/chiptune-ui.js

*/
(() => {
  ("use strict");

  // point to the original browser console warn method
  const warnMethod = console.warn;
  // override console.warn() to intercept all messages
  // this only occures with chiptune-ui.js
  console.warn = function (msg) {
    const id = `openmpt: openmpt_module`;
    const invalid = `ERROR: error loading file`;
    // handle problematic openmpt warnings and exit
    if (msg.substring(0, id.length) === id) {
      if (msg.endsWith(invalid)) {
        const ctrl = document.getElementById(`chiptune-controls`);
        const red = `rgb(212, 63, 58)`;
        ctrl.style.borderColor = red;
        ctrl.textContent = `${invalid}`;
        console.error(msg);
        return;
      }
    }
    // else use the browser's console.warn() method to print the warning
    warnMethod(msg);
  };

  window[`libopenmpt`] = {};

  libopenmpt.locateFile = function (filename) {
    switch (filename) {
      case `libopenmpt.js.mem`:
        return `/javascripts/${filename}`;
      default:
        return filename;
    }
  };

  libopenmpt.on;

  libopenmpt.onRuntimeInitialized = function () {
    const chiptuneStop = document.getElementById(`chiptuneStop`),
      chiptunePause = document.getElementById(`chiptunePause`),
      chiptunePlay = document.getElementById(`chiptunePlay`);
    let player;

    if (chiptuneStop === null)
      return console.error(
        `Chiptune.js was loaded but no player controls exist on the page`
      );

    function init() {
      if (typeof player === `undefined`) {
        const none = -1;
        player = new ChiptuneJsPlayer(new ChiptuneJsConfig(none));
        return console.log(
          `Initialise Chiptune2.js`,
          `https://github.com/deskjet/chiptune2.js`
        );
      }
      player.stop();
      playPauseButton();
    }

    function afterLoad(buffer) {
      if (buffer.byteLength) player.play(buffer);
    }

    function loadURL(path = ``) {
      console.log(`Chiptune2.js url path:`, path);
      if (path === ``)
        return console.error(`No path to the chiptune file was given`);
      /* eslint-disable no-invalid-this */
      player.load(path, afterLoad.bind(this));
    }

    function pauseButton() {
      player.togglePause();
      switchPauseButton();
    }

    function playButton() {
      //chiptune-path
      const zip = document.getElementsByName(`chiptune-path`);
      const meta = document.getElementsByName(`file:url`);
      let url = ``;
      if (typeof zip[0] !== `undefined`) {
        url = zip[0].getAttribute(`content`);
      }
      if (url === `` && typeof meta[0] !== `undefined`) {
        url = meta[0].getAttribute(`content`);
      }
      if (url === ``) return;
      loadURL(url);
      player.togglePause();
      chiptuneStop.classList.toggle(`hidden`);
      chiptunePlay.classList.toggle(`hidden`);
    }

    function switchPauseButton() {
      chiptuneStop.classList.add(`hidden`);
      chiptunePause.classList.toggle(`hidden`);
      chiptunePlay.classList.toggle(`hidden`);
    }

    function playPauseButton() {
      chiptuneStop.classList.toggle(`hidden`);
    }

    document.getElementById(`pause`).addEventListener(`click`, pauseButton);
    document.getElementById(`play`).addEventListener(`click`, pauseButton);
    document.getElementById(`stop`).addEventListener(`click`, playButton);

    init();
  };
})();
