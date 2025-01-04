/*
  Global functions and window event listeners.
	path: javascript/src/functions.js

*/
(() => {
  "use strict";
  const version = new Map()
    .set(`date`, new Date(`16,Jun,2022`))
    .set(`minor`, `7`)
    .set(`major`, `1`)
    .set(`display`, ``);

  version.set(
    `display`,
    `${version.get(`major`)}.${version.get(`minor`)} (${version
      .get(`date`)
      .toLocaleDateString()})`
  );
  console.info(
    `Loaded shared functions ${version.get(`display`)} (functions.js)`
  );
})();

// Non-implicit global functions

/**
 * Returns the content value of a meta element.
 *
 * @param {string} name Meta element name
 * @returns A meta element
 */
window.metaContent = function (name) {
  "use strict";
  const elm = document.getElementsByName(`${name}`);
  if (typeof elm[0] === `undefined`) return null;
  return elm[0].getAttribute(`content`);
};

/**
 * Applies query string modifications to a group of anchor elements that share the same class.
 *
 * @param {*} className Shared class name of the anchor elements
 * @param {*} params URL parameters to append to the href value
 */
window.queryStringBase = function (className, params) {
  "use strict";

  const name = String(className);
  let anchors = {},
    base = ``;

  try {
    anchors = document.getElementsByClassName(name);
  } catch (err) {
    return console.warn(
      `queryStringBase could not find any elements with the class name ${name}`
    );
  }

  for (const anchor of anchors) {
    try {
      base = anchor.getAttribute(`href`);
    } catch (err) {
      console.warn(
        `queryStringBase probably could not find the the href attribute for ${name}`
      );
      continue;
    }
    try {
      anchor.setAttribute(`href`, String(`${base}${params}`));
    } catch (err) {
      console.warn(`queryStringBase could not href attribute for ${name}`);
      continue;
    }
  }
};

/**
 * Convert query strings into JSON.
 * https://www.developerdrive.com/2013/08/turning-the-querystring-into-a-json-object-using-javascript/
 *
 * @returns A JSON object
 */
window.queryStringJSON = function () {
  "use strict";
  const query = location.search.slice(1).split(`&`),
    result = {};
  query.forEach((item) => {
    const value = item.split(`=`);
    result[value[0]] = decodeURIComponent(value[1] || ``);
  });
  return JSON.parse(JSON.stringify(result));
};

window.requestJSON = function (url, id) {
  "use strict";
  if (url === null) throw Error(`requestJSON requires a url parameter`);
  if (id === null) throw Error(`requestJSON requires an id parameter`);
  const element = document.getElementById(id);
  if (element === null)
    throw new Error(
      `Aborted the JSON request for "${url}", as the HTML element "${id}" cannot be found`
    );
  fetch(url, {
    method: `POST`,
    headers: {
      "Content-Type": `text/plain charset=UTF-8`,
    },
  })
    .then((response) => {
      if (!response.ok) {
        const error = `A network error occurred requesting JSON`;
        element.textContent = `HTTP Error ${response.status}`;
        throw new Error(`${error}: ${response.statusText} ${response.status}`);
      }
      if (id !== `pingsitegroups`) {
        // if the browser tab is inactive, abort the request
        if (document.hidden) return;
      }
      return response.json();
    })
    .then((result) => {
      element.textContent = result;
    })
    .catch((err) => {
      const error = `An error occurred requesting JSON`;
      console.error(`${error}: ${err}`);
    });
};

/**
 * Request server statistics and active users on the operator menu.
 * !! Never run within a loop as it can create Java memory leaks.
 */
window.requestOperatorMenu = function () {
  "use strict";
  const paths = window.location.pathname.split(`/`);
  switch (paths[1]) {
    case `index.cfm`:
    case ``:
      requestJSON(
        `/index.cfm?controller=system&action=serverfreeram`,
        `menusysramfree`
      );
      requestJSON(
        `/index.cfm?controller=system&action=serverfreehd`,
        `menusyshdfree`
      );
      requestJSON(`/index.cfm?controller=home&action=countbots`, `countbots`);
      requestJSON(
        `/index.cfm?controller=home&action=counthumans`,
        `counthumans`
      );
      break;
    default:
      requestJSON(`/system/serverfreeram`, `menusysramfree`);
      requestJSON(`/system/serverfreehd`, `menusyshdfree`);
      requestJSON(`/home/countbots`, `countbots`);
      requestJSON(`/home/counthumans`, `counthumans`);
  }
};

/**
 * Test for browser storage availability.
 * https://developer.mozilla.org/en-US/docs/Web/API/Web_Storage_API/Using_the_Web_Storage_API
 *
 * @param {*} type Storage type to test, either `local` or `session`
 * @returns Result of the storage test
 */
window.storageAvailable = function (type) {
  "use strict";
  const test = (store) => {
    try {
      const storage = window[store],
        key = `__storage_test__`;
      storage.setItem(key, `test data`);
      storage.removeItem(key);
      return true;
    } catch (err) {
      return false;
    }
  };
  switch (type) {
    case `local`:
    case `session`:
      return test(`${type}Storage`);
    default:
      return false;
  }
};

// Global event listeners

// Keyboard key-press event listener used for pagination navigation and mouse-click short-cuts.
// For more key events: http://unixpapa.com/js/key.html
document.addEventListener(`keydown`, (event) => {
  ("use strict");

  const enter = () => {
    // check for standard buttons that toggle JS submit form functions
    for (const id of upButtons) {
      element = document.getElementById(`${id}`);
      if (element !== null && !element.disabled) return element.click();
    }
    // otherwise look for normal HTML submit buttons and toggle the first one
    elements = document.getElementsByTagName(`button`);
    for (const button of elements) {
      if (button.type === `submit` && !button.disabled) return button.click();
    }
  };

  const backspace = () => {
    // check for standard buttons that toggle JS clear form functions
    element = document.getElementById(`reset-id-button`);
    if (element !== null) return element.click();
    // otherwise look for normal HTML reset buttons and toggle them all
    elements = document.getElementsByTagName(`button`);
    for (const button of elements) {
      if (button.type === `reset` && !button.disabled) button.click();
    }
  };

  const formFocused = (keyDown) => {
    // is a form element (such as input) focused?
    if (keyDown.defaultPrevented) return true;
    if (typeof document.activeElement === `undefined`) return false;
    if (document.activeElement.id) return true;
    return false;
  };

  const doseeStarted = () => {
    // is dosee running on the page?
    const canvas = document.getElementById(`doseeCanvas`);
    if (canvas === null) return false;
    if (Module === null) return false;
    if (!canvas.classList.contains(`dosee-crisp-render`)) return false;
    return true;
  };
  // disable keyboard events when DOSee emulation is running
  if (doseeStarted()) return;

  const arrows = () => {
    switch (event.key) {
      case `ArrowRight`:
        switch (event.ctrlKey) {
          case true:
            return document.getElementById(`GotoLastPage`);
          default:
            return document.getElementById(`GotoNextPage`);
        }
      case `ArrowLeft`:
        switch (event.ctrlKey) {
          case true:
            return document.getElementById(`GotoFirstPage`);
          default:
            return document.getElementById(`GotoPrevPage`);
        }
      default:
    }
  };

  const shortcuts = () => {
    switch (event.ctrlKey) {
      case false:
        return;
      default:
    }
    if (event.key === `p`) {
      const stop = document.getElementById(`chiptuneStop`);
      const play = document.getElementById(`chiptunePlay`);
      const paus = document.getElementById(`chiptunePause`);
      if (!stop.classList.contains(`hidden`)) return stop;
      if (!play.classList.contains(`hidden`)) return play;
      if (!paus.classList.contains(`hidden`)) return paus;
      return;
    }
    switch (event.key) {
      case `d`:
        return document.getElementById(`downloadLinkRef`);
      case `i`:
        return document.getElementById(`fapResize`);
      default:
    }
  };

  // if `element` exits and is a button that is not disabled
  // then run the click event
  const clicker = (element) => {
    switch (Boolean(element)) {
      case true:
        switch (Boolean(element.disabled)) {
          case false:
            return element.click();
          default:
        }
        break;
      default:
    }
  };

  // keyboard events when a form is focused
  let element, elements;
  const upButtons = [
    `clickThisButton`,
    `upload-files-button`,
    `upload-id-button`,
  ];
  if (formFocused(event)) {
    switch (event.ctrlKey) {
      case true:
        switch (event.key.toLowerCase()) {
          // Ctrl+Enter to submit the active form
          case `enter`:
            return enter();
          // Ctrl+Backspace to reset the active form
          case `backspace`:
            return backspace();
          default:
            return;
        }
      default:
        // ignore all other keyboard key events when a form input is active
        return;
    }
  }
  // kept in order of most likely to be used
  // use switches to allow JS engines to convert into bytecode
  clicker(arrows());
  clicker(shortcuts());
});

// Hamburger animation event listener
window.addEventListener(`load`, () => {
  "use strict";
  const button = document.getElementById(`hamburgerButton`);
  if (typeof button === `undefined`) return;
  if (button === null) return;
  // element loses focus
  button.addEventListener(
    `blur`,
    () => {
      const menu = document.querySelector(`.hamburger`);
      menu.classList.remove(`is-active`);
    },
    [false, false, true]
  );
  button.addEventListener(
    `click`,
    () => {
      const menu = document.querySelector(`.hamburger`);
      menu.classList.add(`is-active`);
    },
    [false, false, true]
  );
  button.addEventListener(
    `dblclick`,
    () => {
      const menu = document.querySelector(`.hamburger`);
      menu.classList.add(`is-active`);
    },
    [false, false, true]
  );
});

// Store and restore user defaults for URI parameters using their localStorage.
window.addEventListener(`load`, () => {
  "use strict";

  if (!storageAvailable(`local`)) return;
  if (typeof URL === `undefined`) return;
  if (typeof URLSearchParams === `undefined`) return;

  const chars = 3,
    locate = new URL(window.location),
    path = window.location.pathname,
    paths = path.split(`/`),
    params = new URLSearchParams(locate.search.slice(1));

  // Validates a storage item value against the permitted values.
  const validate = (item, value) => {
    if (typeof item === `undefined`)
      throw Error(`validate item requires an argument`);
    if (typeof value === `undefined`)
      throw Error(`validate value requires an argument`);
    const missing = -1,
      outputs = [`card`, `thumb-`, `text`],
      sorts = [
        `posted_asc`,
        `posted_desc`,
        `date_asc`,
        `date_desc`,
        `title_asc`,
        `title_desc`,
        `size_asc`,
        `size_desc`,
      ];
    let values = [];
    switch (item) {
      case `output`:
        values = outputs;
        break;
      case `sort`:
        values = sorts;
        break;
      default:
        throw Error(`unknown validate item argument ${item}`);
    }
    if (values.indexOf(value) === missing) {
      console.warn(
        `${item} has the invalid stored value ${value} expecting ${values}`
      );
      return false;
    }
    return true;
  };

  // Check for existence and validate items in localStorage.
  const check = (item) => {
    if (!storageAvailable(`local`))
      throw Error(`check ${item} failed as localStorage is unavailable`);
    const stored = localStorage.getItem(item);
    if (stored === null) {
      console.warn(`${item} does not exist in the localStorage`);
      return false;
    }
    return validate(item, stored);
  };

  const store = () => {
    if (params.has(`output`))
      localStorage.setItem(`output`, params.get(`output`));
    if (params.has(`sort`)) localStorage.setItem(`sort`, params.get(`sort`));
  };

  const setFiles = () => {
    if (!check(`output`)) return;
    if (!check(`sort`)) return;
    const links = document.getElementsByTagName(`a`),
      output = `${localStorage.getItem(`output`)}`,
      sort = `${localStorage.getItem(`sort`)}`;
    let api;
    const update = (link) => {
      if (typeof link.href === `undefined`) return;
      if (link.href === ``) return;
      try {
        api = new URL(link.href);
      } catch (err) {
        return console.log(`could not parse URL: ${link.href}`);
      }
      if (api.host !== locate.host) return;
      switch (api.pathname) {
        case `/file/list`:
          api.searchParams.set(`output`, output);
          api.searchParams.set(`sort`, sort);
          link.href = api.toString();
          break;
        default:
      }
    };
    for (const link of links) {
      if (link.classList.contains(`do-not-sort`)) continue;
      update(link);
    }
  };

  const setAnchors = (page) => {
    if (!check(`output`)) return;
    if (!check(`sort`)) return;
    if (![`f`, `g`, `p`].includes(page))
      throw Error(`unknown setAnchors page argument ${page}`);

    const skip = () => {
      if (api.host !== locate.host) return true;
      if (
        page === `f` &&
        api.pathname.slice(0, chars) !== `/g/` &&
        api.pathname.slice(0, chars) !== `/p/`
      )
        return true;
      if (page === `g` && api.pathname.slice(0, chars) !== `/g/`) return true;
      if (page === `p` && api.pathname.slice(0, chars) !== `/p/`) return true;
      return false;
    };

    const update = (link) => {
      if (typeof link.href === `undefined`) return;
      if (link.href === ``) return;
      try {
        api = new URL(link.href);
      } catch (err) {
        return console.log(`could not parse URL: ${link.href}`);
      }
      if (skip()) return;
      api.searchParams.set(`output`, output);
      api.searchParams.set(`platform`, `-`);
      api.searchParams.set(`section`, `-`);
      api.searchParams.set(`sort`, sort);
      link.href = api.toString();
    };

    const links = document.getElementsByTagName(`a`),
      output = `${localStorage.getItem(`output`)}`,
      sort = `${localStorage.getItem(`sort`)}`;
    let api;
    for (const link of links) {
      update(link);
    }
  };

  // 19/1/21: remove unused localStorage items that maybe on the browser
  // from previous visits. this can be removed in the future.
  const legacy = [
    `fileOutput`,
    `filePerPage`,
    `fileSort`,
    `linkPerpage`,
    `linkSort`,
    `groupPerpage`,
    `groupInfo`,
    `searchFiles`,
    `searchGroups`,
    `searchPeople`,
    `searchSites`,
  ];
  for (const key of legacy) {
    localStorage.removeItem(key);
  }

  const route = paths[1],
    action = paths[2];
  switch (route) {
    case `f`:
      if (action !== `index`) return setAnchors(`f`);
      break;
    case `g`:
    case `p`:
      if (action !== `list`) return store();
      break;
    case `file`:
      if (action === `index`) return setFiles();
      if (action === `list`) return store();
      break;
    case `organisation`:
      if (action === `list`) return setAnchors(`g`);
      break;
    case `person`:
      if (action === `list`) return setAnchors(`p`);
      break;
    case `search`:
      if (action !== `result`) break;
      switch (params.get(`search`)) {
        case `all`:
          return setAnchors(`f`);
        case `files`:
        case `groups`:
          return setAnchors(`g`);
        case `people`:
          return setAnchors(`p`);
        default:
      }
      break;
    default:
  }
});
