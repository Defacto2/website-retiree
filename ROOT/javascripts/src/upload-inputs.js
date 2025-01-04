/*
  Send your files inputs.
  path: javascript/src/upload-inputs.js

*/
(() => {
  "use strict";
  const version = new Map()
    .set(`date`, new Date(`26,April,2022`))
    .set(`minor`, `6`)
    .set(`major`, `1`)
    .set(`display`, ``);
  version.set(
    `display`,
    `${version.get(`major`)}.${version.get(`minor`)} (${version
      .get(`date`)
      .toLocaleDateString()})`
  );

  const pathNames = window.location.pathname.split(`/`),
    storage = storageAvailable(`local`),
    blank = document.getElementById(`blank-date-button`),
    year = document.getElementById(`newFile-date_issued_year`),
    month = document.getElementById(`newFile-date_issued_month`),
    day = document.getElementById(`newFile-date_issued_day`),
    stores = {
      year: `uploaddate_issued_year`,
      month: `uploaddate_issued_month`,
      day: `uploaddate_issued_day`,
    };

  // Published date
  if (pathNames[2] !== `submitFile`) {
    const today = document.getElementById(`today-date-button`);
    if (year !== null) year.addEventListener(`change`, blankDateButtonFocus);
    if (month !== null) month.addEventListener(`change`, blankDateButtonFocus);
    if (day !== null) day.addEventListener(`change`, blankDateButtonFocus);
    if (today !== null) today.addEventListener(`click`, todaysDate);
    if (blank !== null) blank.addEventListener(`click`, blankDates);
    if (storage) {
      const y = localStorage.getItem(stores.year),
        m = localStorage.getItem(stores.month),
        d = localStorage.getItem(stores.day);
      if (y !== null || m !== null || d !== null) {
        const btn = document.getElementById(`blank-date-button`);
        if (btn !== null) btn.disabled = false;
      }
    }
  }

  // Tag as
  const section = document.getElementById(`newFile-section`);
  if (section !== null && typeof hintSelect !== `undefined`) {
    section.addEventListener(`change`, () => {
      const value = section[section.selectedIndex].value;
      hintSelect(`section`, value);
    });
    section.addEventListener(`keyup`, () => {
      const value = section[section.selectedIndex].value;
      hintSelect(`section`, value);
    });
  }

  // Platform or operating system
  const platform = document.getElementById(`newFile-platform`);
  if (platform !== null && typeof hintSelect !== `undefined`) {
    platform.addEventListener(`change`, () => {
      const value = platform[platform.selectedIndex].value;
      hintSelect(`platform`, value);
    });
    platform.addEventListener(`keyup`, () => {
      const value = platform[platform.selectedIndex].value;
      hintSelect(`platform`, value);
    });
  }

  // Clear form
  const resetButton = document.getElementById(`reset-button`);
  if (resetButton !== null && typeof resetInputs !== `undefined`) {
    resetButton.addEventListener(`click`, resetInputs);
  }

  /**
   * Display hints for various platforms and operating systems
   *
   * @param {*} [type=``]
   * @param {*} [val=``]
   * @returns String of hint
   */
  function hintSelect(type = ``, value = ``) {
    if (type === ``) throw Error(`hint select hint type cannot be empty`);
    const leaveBlank = `Leave blank.`;
    const text = function (hint, val = ``) {
      if (val === ``) return leaveBlank;
      if (hint === null) return ``;
      return hint;
    };
    const hint = metaContent(`hint:${type}:${value.toLowerCase()}`),
      upload = document.getElementById(`newFile-${type}-span`);
    if (upload !== null) upload.textContent = text(hint, value.toLowerCase());
    if (upload.textContent === leaveBlank) {
      const oneSecond = 1000;
      window.setTimeout(() => {
        upload.textContent = ``;
      }, oneSecond);
    }
  }

  /**
   * Enable `blank date` button which is disabled onload so no-script can ignore it.
   *
   * @returns
   */
  function blankDateButtonFocus() {
    if (blank === null) return;
    blank.disabled = false;
    if (year !== null && year.value !== ``) return;
    if (month !== null && month.value !== ``) return;
    if (day !== null && day.value !== ``) return;
    blank.disabled = true;
  }

  /**
   * Function to blank the dates of custom date input forms.
   *
   */
  function blankDates() {
    const store = storageAvailable(`local`);
    day.value = ``;
    month.value = ``;
    year.value = ``;
    blank.disabled = true;
    if (store) {
      localStorage.removeItem(stores.year);
      localStorage.removeItem(stores.month);
      localStorage.removeItem(stores.day);
    }
  }

  /**
   * Blanks the values of section and platform selection elements
   *
   */
  function resetInputs() {
    const s = document.getElementById(`newFile-section-span`),
      p = document.getElementById(`newFile-platform-span`),
      f = document.getElementById(`feedBack`);
    if (s !== null) s.textContent = ``;
    if (p !== null) p.textContent = ``;
    if (f !== null) f.classList.add(`hidden`);
    blankDateButtonFocus();
  }

  /**
   * Selects the current date as the published date
   *
   */
  function todaysDate() {
    const store = storageAvailable(`local`),
      now = new Date();
    year.value = now.getFullYear();
    // JS uses a range of 0-11 for months
    month.value = now.getMonth() + 1;
    day.value = now.getDate();
    if (store) {
      localStorage.setItem(stores.year, now.getFullYear());
      localStorage.setItem(stores.month, now.getMonth() + 1);
      localStorage.setItem(stores.day, now.getDate());
    }
    blankDateButtonFocus();
  }

  console.info(
    `Loaded inputs for uploads ${version.get(`display`)} (upload-inputs.js)`
  );
})();
