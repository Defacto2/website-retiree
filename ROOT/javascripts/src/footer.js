/*
  Layout functions to be loaded after the page
	path: javascript/src/footer.js

*/
(() => {
  ("use strict");
  const version = new Map()
    .set(`date`, new Date(`1,Jan,2023`))
    .set(`minor`, `17`)
    .set(`major`, `2`)
    .set(`display`, ``);

  version.set(
    `display`,
    `${version.get(`major`)}.${version.get(`minor`)} (${version
      .get(`date`)
      .toLocaleDateString()})`
  );

  // must wait for functions.js to load before running initialise()
  document.getElementById(`layoutHeadJS`).addEventListener(`load`, initialise);
  const pathArray = window.location.pathname.split(`/`),
    urlRewriteOff = `index.cfm`;

  /**
   * Initialise this footer script using controller and action values.
   *
   */
  function initialise() {
    const params = new URLSearchParams(document.location.search.substring(1)),
      wheels = {
        controller: pathArray[1],
        action: ``,
        key: ``,
      };

    const breadCrumbs = () => {
      const header = document.getElementById(`fixedHeader`);
      if (header === null) {
        return document
          .getElementsByTagName(`main`)[0]
          .classList.remove(`header-stick`);
      }
      // headroom library applies an animated hide effect to the breadcrumb header
      const headroom = new Headroom(header, {});
      headroom.init();
    };

    const urlRewrite = () => {
      let index = 1;
      const position = 3,
        off = `index.cfm`;
      switch (wheels.controller) {
        case off:
          // URL rewriting is off
          wheels.controller = params.get(`controller`);
          wheels.action = params.get(`action`);
          // while the cfwheels key parameter can use unique key names,
          // but is always the 3rd parameter
          for (const value of params.values()) {
            if (index === position) {
              wheels.key = value;
              break;
            }
            index++;
          }
          break;
        default:
          // URL writing is on
          wheels.action = pathArray[2];
          wheels.key = pathArray[3];
      }
    };

    const operator = () => {
      const free = document.getElementById(`menusyshdfree`);
      if (free === null) return;
      if (typeof requestOperatorMenu === `undefined`) return;
      setTimeout(requestOperatorMenu, 1);
    };

    const pages = () => {
      switch (wheels.controller) {
        case `file`:
          if (wheels.action === `detail`) return archiveListener();
          break;
        case `organisation`:
        case `person`:
          if (wheels.action === `list`) return archiveListener();
          break;
        case `f`:
          clipboardLink();
          return archiveListener();
        case `search`:
          return searchInput();
        case `home`:
          setTimeout(requestHomeUpdate, 1);
          return countFiles();
        default:
          if (wheels.controller !== ``) break;
          if (typeof wheels.action !== `undefined`) break;
          throw Error(`localhost domains are not supported`);
      }
    };

    breadCrumbs();
    urlRewrite();
    operator();
    pages();
    browserAlerts();
  }

  /**
   * Copies a clean URL to the active file page to the clipboard.
   *
   */
  function clipboardLink() {
    const button = document.getElementById(`copyLink`);
    if (button === null) {
      console.warn(`clipboardLink button does not exist`);
      return;
    }
    const click = () => {
      const oneSecond = 1000,
        replace = document.createElement(`i`),
        icon = document.getElementById(`copyLinkIcon`),
        text = document.getElementById(`copyLinkText`);
      const restore = () => {
        setTimeout(() => {
          replace.classList.add(`fal`, `fa-clipboard`, `fa-fw`);
          icon.textContent = ``;
          icon.append(replace);
          button.classList.remove(`btn-success`);
          button.classList.add(`btn-info`);
          text.textContent = `Share this link`;
        }, oneSecond);
      };
      const success = () => {
        replace.classList.add(`fal`, `fa-clipboard-check`, `fa-fw`);
        icon.textContent = ``;
        icon.append(replace);
        button.classList.remove(`btn-info`);
        button.classList.add(`btn-success`);
        text.textContent = `Copied`;
        restore();
      };
      const failure = () => {
        button.classList.remove(`btn-info`);
        button.classList.add(`btn-danger`);
        button.disabled = true;
      };

      const value = document.getElementById(`shareThisLink`);
      if (!value || !navigator.clipboard)
        return (document.getElementById(`copyLink`).disabled = true);
      if (navigator.clipboard === null) return;
      const port = window.location.port,
        url = new URL(value.textContent),
        http = 80,
        https = 443,
        local = 8560;
      if (port !== http && port !== https) url.port = port;
      if (port !== local) url.port = https;
      navigator.clipboard.writeText(`${url.toString()}`).then(
        () => success(),
        () => failure()
      );
    };
    button.addEventListener(`click`, () => click());
  }

  /**
   * Counts and displays the number of 'Recent additions' to the site.
   *
   */
  function countFiles() {
    const meta = document.getElementsByName(`defacto2:file-count`);
    if (!meta.length) return;
    const metaCount = meta[0].content,
      localCount = localStorage.getItem(`total-file-count`);
    localStorage.setItem(`total-file-count`, `${metaCount}`);
    if (localCount == null) return;
    const total = parseInt(metaCount),
      store = parseInt(localCount),
      difference = total - store;
    if (!difference) return;
    if (isNaN(difference)) return;
    const display = document.getElementById(`homeNewFileCount`);
    const negative = -1;
    const diffString =
      Math.sign(difference) === negative
        ? `${Math.abs(difference)} files removed`
        : `${difference} new files added`;
    display.textContent = `, with ${diffString} since your last visit`;
  }

  /**
   * Test for required browser features.
   * `querySelector`, `localStorage`, `addEventListener`, `formAction`.
   *
   */
  function browserAlerts() {
    const buttonTest = document.createElement(`button`);
    let browserTest = false;
    try {
      browserTest = `querySelector` in document && `addEventListener` in window;
    } catch (err) {
      console.warn(err);
    }
    if (!browserTest) {
      // critical error, the site is not usable
      const notice = document.getElementById(`browserError`);
      if (notice !== null) notice.style.display = `block`;
      return;
    }
    if (!(`formAction` in buttonTest)) {
      // minor error, site works but formaction dependant navigation buttons will fail.
      const formErr = document.getElementById(`browserFormError`);
      if (formErr !== null) formErr.style.display = `block`;
      const inputs = document.getElementsByTagName(`button`);
      // disable all buttons that use formaction
      for (const input of inputs) {
        input.hasAttribute(`formAction`);
        input.disabled = true;
      }
    }
    if (!storageAvailable(`local`)) {
      // major error, no save storage states so navigation breaks
      const storeErr = document.getElementById(`browserStoreError`);
      if (storeErr !== null) storeErr.style.display = `block`;
    }
  }

  /**
   * Refresh the active users statistics located on the footer of the `home` controller.
   */
  function requestHomeUpdate() {
    switch (pathArray[1]) {
      case urlRewriteOff:
      case ``:
        requestJSON(
          `/index.cfm?controller=home&action=countbots`,
          `homecountbots`
        );
        requestJSON(
          `/index.cfm?controller=home&action=counthumans`,
          `homecounthumans`
        );
        break;
      default:
        requestJSON(`/home/countbots`, `homecountbots`);
        requestJSON(`/home/counthumans`, `homecounthumans`);
    }
  }

  /**
   * Enables the coop environment interactions for the "Archive" content panel,
   * which is found in _prod_archive-dir.cfm.
   *
   */
  function archiveListener() {
    const content = document.getElementById(`file-archive-content`),
      panel = document.getElementById(`file-archive-panel`);
    if (content === null) return;
    if (panel === null) return;

    const clickable = () => {
      // set the element text content values
      const set = (li, filename) => {
        const extension = filename
          .slice(((filename.lastIndexOf(`.`) - 1) >>> 0) + 2)
          .toLowerCase();
        switch (extension) {
          case `exe`:
          case `com`:
          case `bat`:
            li.style.cursor = `pointer`;
            li.addEventListener(`click`, function () {
              document.getElementById(`formOnFile[dosee_run_program]`).value =
                li.textContent;
            });
            break;
          case `nfo`:
          case `txt`:
          case `diz`:
          case `ans`:
          case `asc`:
          case `doc`:
            li.style.cursor = `pointer`;
            li.addEventListener(`click`, function () {
              document.getElementById(`formOnFile[retrotxt_readme]`).value =
                li.textContent;
            });
            break;
          default:
        }
      };
      // co-op ability to copy the clicked filename to the form
      const files = 100;
      for (let i = 1; i < files; i++) {
        const li = document.getElementById(`FCL${i}`);
        if (li === null) break;
        // the title is only used in a `coop` environment
        if (li.title === ``) continue;
        const filename = li.textContent;
        // skip directories
        const last = -1;
        if (filename.slice(last) === `/`) continue;
        set(li, filename);
      }
    };

    const expand = () => {
      // only apply the toggle to archive lists with more than 5 items
      const resize = document.getElementById(`fapResize`),
        files = document.getElementById(`fileContentCount`).textContent.trim(),
        minimum = 15;
      if (resize === null) return;
      if (files > minimum) {
        resize.classList.remove(`hidden`);
        resize.parentElement.classList.remove(`hidden`);
      }

      const update = (event) => {
        const val = event.target,
          height = `26em`;
        switch (val.textContent) {
          case `Show more`:
            val.textContent = `Show less`;
            panel.style.height = `unset`;
            panel.style.minHeight = `unset`;
            break;
          default:
            val.textContent = `Show more`;
            panel.style.height = `${height}`;
            panel.style.minHeight = `${height}`;
        }
      };

      resize.style.cursor = `pointer`;
      resize.addEventListener(`click`, (event) => {
        update(event);
      });
    };
    clickable();
    expand();
  }

  /**
   * Toggles between the different search radios buttons.
   *
   */
  function searchInput() {
    const input = document.getElementById(`query-input`);
    if (input === null) return;

    const search = document.getElementById(`search`),
      sLabel = document.getElementById(`search-label`);

    function change() {
      /* eslint-disable no-invalid-this */
      // if the label was clicked then make sure the matching radio is checked
      const id = this.id.replace(`-span`, `-true`);
      if (id !== this.id) {
        const radio = document.getElementById(id);
        radio.checked = true;
      }
      // toggle button colour and submit the form
      this.classList.replace(`btn-default`, `btn-info`);
      switch (this.id) {
        case `s_file-span`:
          sLabel.textContent = `Enter the metadata to lookup`;
          break;
        case `s_groups-span`:
          sLabel.textContent = `Enter the groups to lookup`;
          break;
        case `s_people-span`:
          sLabel.textContent = `Enter the people to lookup`;
          break;
        case `s_websites-span`:
          sLabel.textContent = `Enter a word or a phrase of a website to lookup`;
          break;
        case `s_all-span`:
          sLabel.textContent = `Enter a filename, group, person, word or a phrase to lookup`;
          break;
        default:
      }
      if (!input.value.length) return;
      search.submit();
    }

    const values = [`s_all`, `s_file`, `s_groups`, `s_people`, `s_websites`];
    for (const value of values) {
      const label = document.getElementById(`${value}-span`),
        radio = document.getElementById(`${value}-true`);
      if (label !== null) label.addEventListener(`click`, change);
      if (radio !== null) radio.addEventListener(`change`, change);
    }
  }
  console.info(
    `Loaded footer ${version.get(`display`)} (footer-${version.get(
      `major`
    )}.${version.get(`minor`)}.js)`
  );
})();
