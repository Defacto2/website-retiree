/*
  Infinite scroll of files.
  path: javascript/src/infinite-scroll.js

*/
(() => {
  ("use strict");
  const version = new Map()
    .set(`date`, new Date(`21,Jan,2021`))
    .set(`minor`, `5.3.1`)
    .set(`major`, `1`)
    .set(`display`, ``);
  version.set(
    `display`,
    `${version.get(`major`)}.${version.get(`minor`)} (${version
      .get(`date`)
      .toLocaleDateString()})`
  );

  if (typeof Symbol.iterator === `undefined`) {
    console.warn(`InfiniteScroll is not usable with this browser`);
    return hideLabel();
  }
  if (typeof URLSearchParams === `undefined`) {
    console.warn(`InfiniteScroll is not usable with this browser`);
    return hideLabel();
  }

  const appendClass = () => {
    switch (scroll.output) {
      case `thumb-`:
      case `thumb`:
        return `file-as-thumb`;
      case `text`:
        return `file-as-text`;
      default:
        return `file-as-card`;
    }
  };

  const containerClass = () => {
    if (scroll.output === `text`) return `files-table`;
    return `files-container`;
  };

  const fileAsName = () => {
    const search = new URLSearchParams(window.location.search);
    switch (search.get(`output`)) {
      case `text`:
        return `file-as-text`;
      case `thumb-`:
        return `file-as-thumb`;
      default:
        return `file-as-card`;
    }
  };

  const hideEllipsis = () => {
    const ellipsis = document.getElementsByClassName(`loader-ellipsis`)[0],
      last = document.getElementsByClassName(`infinite-scroll-last`)[0];
    if (typeof ellipsis !== `undefined`) ellipsis.style.display = `none`;
    if (typeof last !== `undefined`) last.style.display = `none`;
  };

  // hide the show per-page and current page labels.
  const hideLabel = () => {
    const scrolls = document.getElementsByClassName(`hide-from-infscroll`);
    for (const element of scrolls) {
      if (typeof element.style !== `undefined`) element.style.display = `none`;
    }
    const status = document.getElementsByClassName(`page-load-status`)[0];
    if (status !== null) status.style.display = `none`;
  };

  const infiniteScrollChecks = () => {
    if (!valid(scroll.perPage)) {
      console.warn(
        `Querystring prepage "${scroll.perPage}" is not valid so aborting the request of thumbnails`
      );
      return hideLabel();
    }
    if (!valid(scroll.page)) {
      console.warn(
        `Querystring page "${scroll.page}" is not valid so aborting the request of thumbnails`
      );
      return hideLabel();
    }
    const end = document.getElementById(`LastPageOfList`);
    if (end !== null && parseInt(end.textContent) <= parseInt(scroll.page)) {
      requestThumbs(scroll.page, scroll.perPage);
      console.warn(
        `Querystring page "${scroll.page}" is less than or equal to ${end.textContent} so aborting InfiniteScroll`
      );
      return hideLabel();
    }
    // See for all options: https://infinite-scroll.com/options.html
    if (document.getElementsByClassName(`pagination__next`).length < 1) {
      console.warn(`No pagination__next found so aborting InfiniteScroll`);
      return hideLabel();
    }
  };

  // determine container and item sizes based on the
  // first record loaded and rendered by the CFML server.
  const pages = () => {
    const container = document.getElementsByClassName(`files-container`)[0],
      item = document.getElementsByClassName(`${fileAsName()}`)[0],
      width = Math.floor(container.scrollWidth / item.offsetWidth),
      height = Math.ceil(container.scrollHeight / item.offsetHeight);
    return width * height * 2;
  };

  const queryParams = () => {
    const replace = new URLSearchParams(window.location.search);
    replace.set(`perpage`, scroll.perPage);
    if (replace.has(`output`)) scroll.output = replace.get(`output`);
    if (replace.has(`page`)) return redirect(replace);
    // replace the page value with a page number given by InfiniteScroll
    replace.delete(`page`);
    return (scroll.replacement = replace.toString());
  };

  const redirect = (replace) => {
    scroll.page = replace.get(`page`);
    if (scroll.page < 1) return;
    replace.delete(`page`);
    replace.delete(`perpage`);
    console.warn(
      `redirecting the page as &page=1 paramater is in the window.location`
    );
    document.location.replace(
      `${window.location.pathname}?${replace.toString()}`
    );
  };

  const valid = (page) => {
    if (page === null) return false;
    if (Number.isNaN(page)) return false;
    if (parseInt(page) < 0) return false;
    return true;
  };

  const scroll = {
    output: `card`,
    page: 1,
    perPage: pages(),
    replacement: ``,
  };
  queryParams();
  infiniteScrollChecks();

  // Infinite Scroll options
  // https://github.com/metafizzy/infinite-scroll#options
  const infScroll = new InfiniteScroll(`.${containerClass()}`, {
    debug: false,
    append: `.${appendClass()}`,
    checkLastPage: `.pagination__next`,
    history: `replace`,
    prefill: true,
    hideNav: `.hide-from-infscroll`,
    scrollThresold: 1000,
    status: `.page-load-status`,
    path() {
      // to be able to load page number 1,
      // this func is required instead of using the &page={{#}} string
      const pageIndex = this.loadCount + 1;
      return `${window.location.pathname}?${scroll.replacement}&page=${pageIndex}`;
    },
  });
  // Infinite Scroll load once
  infScroll.once(`load`, function () {
    // both the Lucee server and InfiniteScroll duplicate item number 1
    // this remove one of the duplicate elements and loads the other thumbnail element
    const firstItem = document.getElementById(`tuuid-1_0`);
    if (firstItem !== null) {
      let uuid = ``;
      switch (scroll.output) {
        case `text`:
          firstItem.remove();
          break;
        default:
          uuid = `${firstItem.textContent}`;
          firstItem.parentElement.remove();
          requestThumb(`1_0`, `${uuid}`);
      }
    }
    hideLabel();
    const badge = document.getElementById(`infScrollBadge`);
    badge.classList.remove(`hidden`);
    badge.style.display = `inline`;
    console.info(`InfiniteScroll has successfully initialised`);
  });
  // Infinite Scroll append
  infScroll.on(`append`, function () {
    /* eslint-disable no-invalid-this */
    const index = this.pageIndex;
    if (Number.isNaN(index) || index < 0) {
      console.warn(
        `InfiniteScroll aborted as pageIndex=${index} is less-than 1 or is not-a-number`
      );
      return hideEllipsis();
    }
    const currentPage = index - 1;
    requestThumbs(currentPage, scroll.perPage);
  });
  // Infinite Scroll errors
  infScroll.on(`error`, function (err) {
    const scrolls = document.getElementsByClassName(`hide-from-infscroll`);
    for (const element of scrolls) {
      if (typeof element.style !== `undefined`) element.style.display = `block`;
    }
    document.getElementById(`infScrollBadge`).classList.add(`hidden`);
    console.warn(`InfiniteScroll broke :( ${err}`);
  });

  /**
   * Loads a thumbnail using an asynchronous method
   *
   * @param {string} [id=``] Thumbnail ID
   * @param {string} [uuid=``] Thumbnail UUID used as the image filename
   *
   * Note: the `?` is appended to the thumb.style to trigger a query string URL.
   * This combined with the Caching Level = No query string in the cache setting
   * for Cloudflare should fix broken thumbnail rerendering.
   */
  function requestThumb(id = ``, uuid = ``) {
    const img = new Image();
    img.src = `/images/uuid/400x400/${uuid}.png`;
    img.onload = () => {
      const thumb = document.getElementById(`thumb-${id}`);
      if (thumb === null) return;
      thumb.style = `background-image:url(${img.src}?);`;
    };
  }

  /**
   * Loops through a collection of thumbnails to update their images
   *
   * @param {number} [currentPage=0] Current page number
   * @param {number} [perPage=0] Items per-page
   */
  function requestThumbs(currentPage = 0, perPage = 0) {
    for (let i = 0; i < perPage; i++) {
      const id = `${currentPage}_${i}`,
        element = document.getElementById(`tuuid-${id}`);
      if (element === null) break;
      const uuid = element.innerText,
        luceeID = 35,
        rfc4122 = 36;
      if (uuid.length === luceeID || uuid.length === rfc4122)
        requestThumb(`${id}`, element.innerText);
    }
  }

  console.info(
    `Loaded infinite scroll init ${version.get(`display`)} (infinite-scroll.js)`
  );
})();
