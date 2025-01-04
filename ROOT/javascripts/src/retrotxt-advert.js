/*
  RetroTxt from Defacto2 banner
  path: javascript/src/operator.js

*/
(() => {
  "use strict";

  const headJS = document.getElementById(`layoutHeadJS`);
  if (headJS !== null) headJS.addEventListener(`load`, hide);

  /**
   * Toggle the RetroTxt from Defacto2 banner
   *
   */
  function hide() {
    const toggleIcon = document.getElementById(`retrotxt_toggle_i`),
      toggleText = document.getElementById(`retrotxt_toggle_text`),
      container = document.getElementById(`retrotxt-container`);
    let displayAd = null;
    switch (storageAvailable(`local`)) {
      case true:
        displayAd = localStorage.retrotxt2_info_display;
        switch (displayAd) {
          case `undefined`:
            toggleIcon.style.display = `none`;
            toggleText.style.display = `none`;
            break;
          default:
            if (toggleIcon === null) return;
            if (toggleText === null) return;
            if (container === null) return;
            if (displayAd === `false`) {
              container.style.display = `none`;
              return;
            }
            toggleIcon.addEventListener(`click`, () => {
              container.style.display = `none`;
              localStorage[`retrotxt2_info_display`] = false;
            });
            toggleText.addEventListener(`click`, () => {
              container.style.display = `none`;
              localStorage[`retrotxt2_info_display`] = false;
            });
            toggleIcon.addEventListener(`mouseover`, () => {
              toggleIcon.style.cursor = `pointer`;
            });
            toggleText.addEventListener(`mouseover`, () => {
              toggleText.style.cursor = `pointer`;
            });
        }
        break;
      default:
    }
  }
})();
