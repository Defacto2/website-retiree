/*
  Interact with online APIs.
  path: javascript/src/upload-input-production-id.js

  For the CFML interactions with this script:
  controllers/Uploads.cfc
    _parseAPIDemozoo()
    _parseAPIPouet()
    lookupDemozoo()
    lookupPouet()

*/
(() => {
  "use strict";
  const version = new Map()
    .set(`date`, new Date(`01,May,2021`))
    .set(`minor`, `9`)
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
    reset = document.getElementById(`reset-id-button`),
    submit = document.getElementById(`upload-id-button`);

  demozoo.addEventListener(`change`, parseEvent);
  pouët.addEventListener(`change`, parseEvent);
  reset.addEventListener(`click`, resetEvent);

  console.info(
    `Loaded the Demozoo & Pouët toolset ${version.get(
      `display`
    )} (upload-input-production-id.js)`
  );
  /**
   * Obtains a record ID from a input element and validates it against a
   * third-party API. Use `parseEvent()` as the frontend for this function.
   *
   * @param {string} [api=``] Service to ping, either `demozoo` or `pouet`
   * @param {string} [title=``] Name of the service to be used in feedback
   * @param {string} [action=``] The value of the action URL parameter
   */
  function checkID(api, title = ``, action = ``) {
    if (action === ``) throw Error(`checkID action argument cannot be empty`);
    switch (api.toLowerCase()) {
      case `demozoo`:
      case `pouet`:
        break;
      default:
        throw Error(
          `unknown checkID api "${api}" argument, the value must be "demozoo" or "pouet"`
        );
    }
    const webElm = document.getElementById(`newFile-web_id_${api}`);
    if (webElm === null)
      throw Error(`checkID input element "newFile-web_id_${api}" is missing`);
    const key = webElm.value,
      span = document.getElementById(`check-${api}-span`);
    // the key must be a numeric value
    if (/^\d+$/.test(key) !== true)
      return (span.textContent = `${title} ID ${key} is not valid`);

    const spinner = () => {
      const spin = document.createElement(`span`);
      spin.classList.add(`fal`, `fa-circle-notch`, `fa-spin`, `fa-fw`);
      span.textContent = ``;
      span.append(spin);
    };

    const update = (item) => {
      const demozoos = function (id, value) {
        if (api !== `pouet`) return;
        if (id !== `web_id_demozoo`) return;
        if (value.length === 0) return;
        document.getElementById(`demozoo-mark`).textContent = value;
        return true;
      };
      const platform = function (id, value) {
        if (id !== `platform`) return;
        elm.value = value.toLowerCase();
        return true;
      };
      const pouets = function (id, value) {
        if (api !== `demozoo`) return;
        if (id !== `web_id_pouet`) return;
        if (value.length === 0) return;
        document.getElementById(`pouet-mark`).textContent = value;
        return true;
      };
      const publishers = function (id, value) {
        if (id !== `group_brand_by` && id !== `group_brand_for`) return;
        elm.value = renameGroup(value);
        return true;
      };
      const tagAs = function (id, value) {
        if (id !== `section`) return;
        if (value.includes(`Application Generator`)) {
          const employment = 14;
          elm.selectedIndex = employment;
          return true;
        }
        elm.value = value.toLowerCase();
        return true;
      };
      const thumbnail = (id, value) => {
        switch (id) {
          case `thumbnail1`:
          case `thumbnail2`:
          case `thumbnail3`:
            if (value === ``) return;
            document
              .getElementById(`listthumbnail-container`)
              .classList.remove(`hidden`);
            elm.src = value;
            return true;
          default:
        }
      };
      const unused = [`comment`, `list_links`];
      if (unused.includes(item.id)) return;
      const id = `newFile-${item.id}`,
        value = item.v;
      const elm = document.getElementById(id);
      if (elm === null)
        return console.error(`checkID cannot find element ${id}`);
      if (thumbnail(item.id, value)) return;
      if (pouets(item.id, value)) return;
      if (demozoos(item.id, value)) return;
      if (publishers(item.id, value)) return;
      if (platform(item.id, value)) return;
      if (tagAs(item.id, value)) return;
      elm.value = value;
      if (item.id === api)
        document.getElementById(`${api}-mark`).textContent = value;
    };

    const url = () => {
      if (location.pathname === `/index.cfm`)
        return `${location.protocol}//${location.host}?controller=upload&action=${action}&key=${key}&m=extenalUpload`;
      return `${location.protocol}//${location.host}/upload/${action}/${key}?m=extenalUpload`;
    };

    spinner();
    const mark = document.getElementById(`${api}-mark`);
    if (mark !== null) mark.textContent = key;

    const apply = (result) => {
      const unsuitable = `string`;
      if (typeof result === unsuitable) return (span.textContent = result);
      span.textContent = `✓ ${title} ID ${key} looks good`;
      const oneSecond = 1000;
      window.setTimeout(() => {
        span.textContent = ``;
      }, oneSecond);
      for (const item of result) {
        update(item);
      }
      submit.disabled = false;
      // hide any unused thumbnails
      const thumb2 = document.getElementById(`newFile-thumbnail2`);
      if (thumb2.src.length === 0) thumb2.style.display = `none`;
      if (thumb2.src === location.href) thumb2.style.display = `none`;
      const thumb3 = document.getElementById(`newFile-thumbnail3`);
      if (thumb3.src.length === 0) thumb3.style.display = `none`;
      if (thumb3.src === location.href) thumb3.style.display = `none`;
    };

    const request = new Request(url(), {
      cache: `no-cache`,
      method: `GET`,
    });
    fetch(request)
      .then((response) => {
        if (!response.ok) {
          const error = `Network error response fetching the ${title} ID: ${response.status} ${response.statusText}`;
          span.textContent = error;
          throw new Error(error);
        }
        return response.json();
      })
      .then((result) => apply(result))
      .catch((err) => {
        const error = `An error occurred fetching the ${title} ID: ${err}`;
        console.error(error);
        span.textContent = error;
      });

    /**
     * Clean up whitespace leaks or rename alternative group names.
     * For example Demozoo uses `ACiD` while Defacto2 uses `ACiD Productions`.
     *
     * @param {string} [name=``] Key group name used by Demozoo or Pouet
     * @returns Defacto2 key name or an empty string
     */
    function renameGroup(name = ``) {
      const group = name.trim();
      switch (api) {
        case `demozoo`:
          switch (group.toLowerCase()) {
            case `2000 a.d`:
              return `2000ad`;
            case `acid`:
              return `ACiD Productions`;
            case `bitchin ansi designs`:
              return `Bitchin ANSI Designs`;
            case `ice`:
              return `Insane Creators Enterprise`;
            default:
              return group;
          }
        case `pouet`:
          return group;
        default:
          throw Error(`unknown checkID api "${api}" used for swap brand`);
      }
    }
  }

  /**
   * Handle on-change input element events for third-party API checks
   *
   * @param {*} change onChange result
   */
  function parseEvent(change) {
    const input = change.target,
      request = input.value;
    let disableId = ``,
      title = ``,
      uri = ``;
    resetEvent();
    input.value = request;
    switch (input.id) {
      case `newFile-web_id_demozoo`: {
        title = `Demozoo`;
        uri = `lookup-demozoo`;
        disableId = `web_id_pouet`;
        break;
      }
      case `newFile-web_id_pouet`: {
        title = `Pouët`;
        uri = `lookup-pouet`;
        disableId = `web_id_demozoo`;
        break;
      }
      default:
        throw Error(`unknown parse event input id`);
    }
    let id = title.toLocaleLowerCase();
    if (id === `pouët`) id = `pouet`;
    switch (input.value) {
      case ``:
        document.getElementById(`check-${id}-span`).textContent = ``;
        document.getElementById(`newFile-${disableId}`).disabled = false;
        break;
      default:
        console.info(`Fetching information on ${title} ID ${input.value}`);
        document.getElementById(`newFile-${disableId}`).disabled = true;
        checkID(id, title, uri);
    }
  }

  /**
   * Resets the form and input elements
   *
   * @param {*} click onClick button result
   */
  function resetEvent(click) {
    submit.disabled = true;
    document.getElementById(`form1`).reset();
    const feedback = document.getElementById(`feedBack`);
    feedback.textContent = ``;
    feedback.classList.add(`hidden`);
    //feedback.style.display = `none`
    // example ids
    document.getElementById(`demozoo-mark`).textContent = `0`;
    document.getElementById(`pouet-mark`).textContent = `0`;
    // preview thumbs
    document.getElementById(`newFile-thumbnail1`).src = ``;
    document.getElementById(`newFile-thumbnail2`).src = ``;
    document.getElementById(`newFile-thumbnail3`).src = ``;
    document.getElementById(`listthumbnail-container`).classList.add(`hidden`);
    // help feedback
    if (typeof click === `undefined`) return;
    if (click.target.id !== `reset-id-button`) return;
    localStorage.removeItem(`uploadweb_id_demozoo`);
    localStorage.removeItem(`uploadweb_id_pouet`);
    demozoo.disabled = false;
    pouët.disabled = false;
    document.getElementById(`check-demozoo-span`).textContent = ``;
    document.getElementById(`check-pouet-span`).textContent = ``;
  }
})();
