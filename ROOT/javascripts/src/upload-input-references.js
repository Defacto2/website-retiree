/*
  Send your files References inputs.
  path: javascript/src/upload-input-references.js

  The JS for clearing the References text is found in upload.js formReset()

*/
(() => {
  "use strict";
  const version = new Map()
    .set(`date`, new Date(`13,Jan,2021`))
    .set(`minor`, `3`)
    .set(`major`, `1`)
    .set(`display`, ``);

  version.set(
    `display`,
    `${version.get(`major`)}.${version.get(`minor`)} (${version
      .get(`date`)
      .toLocaleDateString()})`
  );

  const demozoo = document.getElementById(`newFile-web_id_demozoo`),
    pouët = document.getElementById(`newFile-web_id_pouet`),
    youTube = document.getElementById(`newFile-web_id_youtube`);

  if (demozoo !== null) demozoo.addEventListener(`change`, parseEvent);
  if (pouët !== null) pouët.addEventListener(`change`, parseEvent);
  if (youTube !== null) youTube.addEventListener(`change`, parseEvent);

  console.info(
    `Loaded Demozoo, Pouët & YouTube title scraper ${version.get(
      `display`
    )} (input-references.js)`
  );

  /**
   * Obtains a record ID from a input element and validates it against a
   * third-party API. Use `parseEvent()` as the frontend for this function.
   *
   * @param {string} [api=``] Service to ping, either `youtube`, `demozoo`, `pouet`
   * @param {string} [title=``] Name of the service to be used in feedback
   * @param {string} [action=``] The value of the action URL parameter
   */
  function checkID(api = ``, title = ``, action = ``) {
    const key = document.getElementById(`newFile-web_id_${api}`).value,
      span = document.getElementById(`check-${api}-span`),
      youtubeLen = 11;
    let valid = false;
    // check that the input value is a valid structure
    switch (api) {
      case `youtube`:
        if (key.length < youtubeLen) break;
        // requires value to be comprised of alphanumeric characters, hyphens and underscores
        if (/^[\d|a-zA-Z|_|-]+$/.test(key) === false) break;
        valid = true;
        break;
      case `demozoo`:
      case `pouet`:
        // requires the key to be numeric
        if (/^\d+$/.test(key)) valid = true;
        break;
      default:
        throw Error(`unknown checkID api ${api}`);
    }
    if (!valid) {
      span.textContent = `${title} ID ${key} is not valid`;
      return;
    }
    // create request URL
    let url = `${location.protocol}//${location.host}/upload/${action}/${key}`;
    if (location.pathname === `/index.cfm`) {
      url = `${location.protocol}//${location.host}/index.cfm?controller=upload&action=${action}&key=${key}?m=json`;
    }
    // loading spinner
    const spinner = document.createElement(`span`);
    spinner.classList.add(`fal`, `fa-circle-notch`, `fa-spin`, `fa-fw`);
    span.textContent = ``;
    span.append(spinner);
    // ping the request URL
    fetch(url, {
      method: `GET`,
      headers: {
        "Content-Type": `application/json charset=UTF-8`,
      },
    })
      .then((response) => {
        if (!response.ok) {
          throw new Error(`A network error code ${response.status} occurred`);
        }
        return response.json();
      })
      .then((result) => {
        span.textContent = `${result}`;
      })
      .catch((err) => {
        const error = `There is an error looking up ${title} id "${key}"`;
        span.textContent = `${error}. ${err}.`;
        console.error(`${error}: ${err}`);
      });
  }

  /**
   * Handle on-change input element events for third-party API checks
   *
   * @param {*} change onChange result
   */
  function parseEvent(change) {
    let title = ``,
      uri = ``;
    switch (change.target.id) {
      case `newFile-web_id_demozoo`:
        title = `Demozoo`;
        uri = `lookup-demozoo`;
        break;
      case `newFile-web_id_pouet`:
        title = `Pouët`;
        uri = `lookup-pouet`;
        break;
      case `newFile-web_id_youtube`:
        title = `YouTube`;
        uri = `lookup-you-tube`;
        break;
      default:
        throw Error(`unknown parseEvent change target id ${change.target.id}`);
    }
    let id = title.toLocaleLowerCase();
    if (id === `pouët`) id = `pouet`;
    switch (change.target.value) {
      case ``:
        document.getElementById(`check-${id}-span`).textContent = ``;
        break;
      default:
        console.info(`Fetching ${title} information`);
        checkID(id, title, uri);
    }
  }
})();
