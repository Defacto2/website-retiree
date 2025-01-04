/*
  Interactions with external APIs
	path: javascript/src/apis-external.js

  If the HTML or JS is changed in: /views/files/_prod_admin.cfm
  Then the apis-external.swapDownload() function must be checked
  to make sure it  is still addressing the correct elements!

*/
(() => {
  ("use strict");

  const version = new Map()
    .set(`date`, new Date(`24,Jan,2021`))
    .set(`minor`, `3`)
    .set(`major`, `2`)
    .set(`display`, ``);

  version.set(
    `display`,
    `${version.get(`major`)}.${version.get(`minor`)}
    (${version.get(`date`).toLocaleDateString()})`
  );

  const demozoo = document.getElementById(`demozooIDValue`),
    pouët = document.getElementById(`pouetIDValue`),
    flashes = document.getElementById(`flashCollection`);
  if (demozoo === null || pouët === null) return;

  const extLinks = [],
    protocol = `${location.protocol}//`,
    links = new Map()
      .set(`DemozooGroups`, `${protocol}demozoo.org/groups/`)
      .set(`DemozooSceners`, `${protocol}demozoo.org/sceners/`)
      .set(`pouëtAvatars`, `${protocol}www.pouet.net/content/avatars/`)
      .set(`pouëtWho`, `${protocol}www.pouet.net/user.php?who=`);

  if (demozoo.innerHTML.length) checkID(`demozoo`, demozoo.innerHTML);
  if (pouët.innerHTML.length) checkID(`pouët`, pouët.innerHTML);

  console.info(
    `Loaded external API interface ${version.get(
      `display`
    )} (apis-external-${version.get(`major`)}.${version.get(`minor`)}.js)`
  );

  /**
   * Obtains a record ID from a input element and validates it against a
   * third-party API.
   *
   * @param {string} [api=``] Service to ping, either `demozoo`, `pouët`, `pouet`
   * @param {string} [id=``] The record ID to lookup on the API
   */
  function checkID(api = ``, id = ``) {
    const action = () => {
      switch (api) {
        case `demozoo`:
          return `lookup-demozoo`;
        case `pouet`:
        case `pouët`:
          return `lookup-pouet`;
        default:
          throw Error(`unknown checkID api ${api}`);
      }
    };
    const url = () => {
      if (location.pathname === `/index.cfm`) {
        return `${location.protocol}//${
          location.host
        }/index.cfm?controller=upload&action=${action()}&key=${id}&m=json`;
      }
      // This URL is to avoid CORS errors,
      // which are not supported by Pouët's API.
      return `${location.protocol}//${
        location.host
      }/upload/${action()}/${id}?m=json`;
    };

    console.info(`Requesting the ${api} API for production #${id}`);
    fetch(url(), {
      method: `GET`,
      headers: {
        "Content-Type": `application/json charset=UTF-8`,
      },
    })
      .then((response) => {
        if (!response.ok) {
          const error = `A network error occurred requesting API`;
          throw new Error(
            `${error}: ${response.statusText} ${response.status}`
          );
        }
        return response.json();
      })
      .then((result) => {
        switch (api) {
          case `demozoo`:
            parseDemozoo(result);
            break;
          case `pouet`:
          case `pouët`:
            parsePouët(result);
            break;
          default:
            throw new Error(`Unknown requesting API "${api}"`);
        }
      })
      .catch((err) => {
        const error = `An error occurred requesting API`;
        console.error(`${error}: ${err}`);
      });
  }

  /**
   * Wrap the supplied text around a `<code>` element.
   *
   * @param {string} [text=``] Text to be wrapped by the element
   * @param {string} [title=``] Mouse-over `title` attribute for the element
   * @returns HTML element
   */
  function codeElement(text = ``, title = ``) {
    const code = document.createElement(`code`),
      i = document.createElement(`i`);
    code.title = title;
    i.classList.add(`fal`, `fa-tag`);
    code.append(i, ` ${text}`);
    return code;
  }

  /**
   * Parse the Demozoo API response and create HTML for display.
   *
   * @param {*} [data={}] API JSON reply parsed into an object
   */
  function parseDemozoo(data = {}) {
    const container = document.getElementById(`demozooContainer`),
      youtubeID = document.getElementById(`youtubeIDValue`);

    if (typeof data.author_nicks === `undefined`)
      return container.classList.add(`hidden`);

    const productionLink = () => {
      const link = document.getElementById(`demozooProdLink`),
        id = link.href.split(`/productions`).pop();
      if (id === `/`) link.href = `${link.href}${data.id}`;
    };

    const authorNicks = () => {
      const update = (nick) => {
        const elm = data.author_nicks[nick],
          small = document.createElement(`small`),
          em = document.createElement(`em`),
          a = document.createElement(`a`);
        small.title = `Author`;
        small.id = `demozooAuthor${nick}`;
        small.append(` `);
        if (elm.abbreviation.length) {
          small.append(` `, em, `, `);
          em.textContent = `${elm.abbreviation}`;
        }
        if (elm.releaser.is_group) {
          a.href = `${links.get(`DemozooGroups`)}${elm.releaser.id}`;
          a.textContent = `${elm.name}`;
          em.append(a);
          small.append(a);
        }
        document.getElementById(`demozooAuthors`).append(small);
      };
      for (const nick in data.author_nicks) {
        update(nick);
      }
    };

    const demozooPlatforms = () => {
      // platform tags
      const tags = document.getElementById(`demozooTags`);
      for (const platform of data.platforms) {
        const code = codeElement(platform.name, `Platform`);
        tags.append(code, ` `);
      }
      // description tags
      for (const type of data.types) {
        const code = codeElement(type.name, `Type`);
        tags.append(code, ` `);
      }
    };

    const downloadLinks = () => {
      for (const link of data.download_links) {
        if (link.url.includes(`defacto2.net`)) continue;
        // skip any external links that also double-up as download links
        if (extLinks.includes(link.url)) continue;
        // skip HTTP/FTP links if a Pouet record exists
        const proto = link.url.split(`:`)[0];
        if (
          [`http`, `https`, `ftp`].includes(proto) &&
          data.web_id_pouet > 0 &&
          pouët.innerHTML.length === 0
        )
          continue;
        extLinks.push(link.url);
        swapDownloadEvent(extLinks.length, link.url);
      }
    };

    const externalLinks = () => {
      const update = (link) => {
        const a = document.createElement(`a`);
        a.href = link.url;
        a.title = data.title;
        const url = new URL(link.url);
        a.textContent = `${url.hostname.toString()} `;
        const i = document.createElement(`i`);
        switch (data.icon) {
          case `github`:
          case `youtube`:
            // font awesome brand icon
            i.classList.add(`fab`, `fa-${data.icon}`);
            break;
          default:
            // font awesome light icon
            i.classList.add(`fal`, `fa-${data.icon}`);
            break;
        }
        a.append(i);
        downloads.append(`\xa0\xa0\xa0`, a);
      };
      data.github = ``;
      data[`web_id_pouet`] = ``;
      data.youtubeId = ``;
      data.icon = `external-link`;
      data.title = `External link`;
      const downloads = document.getElementById(`demozooDownloads`);
      for (const link of data.external_links) {
        // Skip any defacto2 links
        if (link.url.includes(`defacto2.net`)) continue;
        switch (link.link_class) {
          case `DemosceneTvVideo`:
            // broken links
            continue;
          case `GithubRepo`:
            data.github = link.url
              .split(`/`)
              .slice(Math.max(link.url.split(`/`).length - 2, 1));
            data.icon = `github`;
            data.title = `GitHub repository`;
            break;
          case `PouetProduction`:
            data[`web_id_pouet`] = link.url.split(`=`).pop();
            data.title = `Pouët production`;
            continue;
          case `YoutubeVideo`:
            data.youtubeId = link.url.split(`=`).pop();
            // Skip if defacto2 already displays this YouTube video
            if (youtubeID.innerHTML === data.youtubeId) continue;
            data.icon = `youtube`;
            data.title = `YouTube video`;
            break;
          default:
          // all other links are displayed
        }
        update(link);
      }
      // When an unlisted pouet link is discovered, request its API data
      if (data.web_id_pouet > 0 && pouët.innerHTML.length === 0)
        checkID(`pouet`, data.web_id_pouet);
    };

    const authors = () => {
      const credits = document.getElementById(`demozooCredits`);
      const update = (credit) => {
        const code = document.createElement(`code`);
        code.style.whiteSpace = `nowrap`;
        code.title = `Credit`;
        const a = document.createElement(`a`);
        a.href = `${links.get(`DemozooSceners`)}${credit.nick.releaser.id}`;
        a.textContent = `${credit.nick.name}`;
        code.append(a);
        if (credit.category.length) code.append(` [${credit.category}`);
        if (credit.role.length) code.append(`, ${credit.role}`);
        if (credit.category.length || credit.role.length) code.append(`]`);
        credits.append(code, ` `);
      };
      for (const credit of data.credits) {
        update(credit);
      }
    };

    productionLink();
    authorNicks();
    demozooPlatforms();
    downloadLinks();
    externalLinks();
    authors();
    container.classList.remove(`hidden`);
  }

  /**
   * Parse the Pouët API response and create HTML for display.
   *
   * @param {*} [data={}] API JSON reply parsed into an object
   */
  function parsePouët(data = {}) {
    const youtubeID = document.getElementById(`youtubeIDValue`),
      container = document.getElementById(`pouetContainer`);

    if (data.error === true) return container.classList.add(`hidden`);
    if (typeof data.voteup === `undefined`)
      return container.classList.add(`hidden`);

    const productionLink = () => {
      const link = document.getElementById(`pouetProdLink`),
        split = link.href.split(`?`),
        which = new URLSearchParams(split[1]);
      which.set(`which`, `${data.id}`);
      link.href = `${split[0]}?${which.toString()}`;
    };

    const parties = () => {
      const placings = document.getElementById(`pouetPlacings`);
      const update = (placing) => {
        const place = data.placings[placing],
          span = document.createElement(`span`);
        span.id = `pouetPlacing${placing}`;
        const icon = document.createElement(`placing`);
        icon.classList.add(`fal`, `fa-trophy`);
        const rank = document.createElement(`strong`);
        rank.textContent = ordinalInt(place.ranking);
        const party = document.createElement(`em`),
          a = document.createElement(`a`);
        a.href = place.party.web;
        a.textContent = place.party.name;
        span.append(icon, ` `, rank, ` at `, party);
        party.append(a, `, ${place.year}`);
        placings.append(span);
      };
      for (const placing in data.placings) {
        update(placing);
      }
    };

    const votes = () => {
      document.getElementById(`pouetVoteUp`).textContent = data.voteup;
      document.getElementById(`pouetVotePiggy`).textContent = data.votepig;
      document.getElementById(`pouetVoteDown`).textContent = data.votedown;
      const up = parseInt(data.voteup),
        meh = parseInt(data.votepig),
        down = parseInt(data.votedown),
        topScore = 10,
        maxStars = 5,
        halfScore = 0.5;
      if (up + meh + down < topScore) return;
      const score = data.voteavg * maxStars,
        floor = Math.floor(score);
      const average = document.getElementById(`pouetVoteAvg`),
        fullStar = document.createElement(`i`),
        halfStar = document.createElement(`i`);
      fullStar.classList.add(`fal`, `fa-star`);
      halfStar.classList.add(`fal`, `fa-star-half`);
      average.title = `Average voting score ${(2 * score).toFixed(1)}`;
      if (floor <= halfScore) return average.append(halfStar);
      if (floor < 1) return average.append(fullStar);
      for (let i = 0; i < floor; i++) {
        average.append(fullStar.cloneNode());
      }
      const roundUp = 4.5;
      if (score > roundUp && score < maxStars)
        return average.append(fullStar.cloneNode());
      if (score - floor >= halfScore)
        return average.append(halfStar.cloneNode());
    };

    const authors = () => {
      const credits = document.getElementById(`pouetCredits`);
      const update = (credit) => {
        const elm = data.credits[credit],
          code = document.createElement(`code`),
          span = document.createElement(`span`),
          img = document.createElement(`img`),
          a = document.createElement(`a`);
        code.style.whiteSpace = `nowrap`;
        span.id = `pouetCredit${credit}`;
        img.src = `${links.get(`pouëtAvatars`)}${elm.user.avatar}`;
        a.href = `${links.get(`pouëtWho`)}${elm.user.id}`;
        a.textContent = `${elm.user.nickname}`;
        code.append(span);
        const none = -1;
        if (elm.user.avatar.length > none) span.append(img, ` `);
        span.append(a, ` [${elm.role}]`);
        credits.append(code, ` `);
      };
      for (const credit in data.credits) {
        update(credit);
      }
    };

    const downloadLinks = () => {
      const downloads = document.getElementById(`pouetDownloadLinks`);
      const replaceCase = (cases) => {
        if (cases.includes(`music`)) return `soundtrack`;
        if (cases.includes(`soundtrack`)) return `soundtrack`;
        if (cases.includes(`video`)) return `video`;
        if (cases.includes(`vimeo`)) return `vimeo`;
        if (cases.includes(`youtube`)) return `youtube`;
      };
      const update = (download) => {
        download.case = replaceCase(download.type.toLowerCase());
        download.icon = ``;
        download.youtubeId = ``;
        let iconTitle = download.type;
        switch (download.case) {
          case `demoscene.tv`:
            // broken links
            return;
          case `capped.tv`:
            download.icon = `television`;
            break;
          case `soundcloud`:
            download.icon = `soundcloud`;
            iconTitle = `Soundcloud audio`;
            break;
          case `source`:
            download.icon = `code-fork`;
            break;
          case `soundtrack`:
            download.icon = `music`;
            break;
          case `video`:
            download.icon = `video`;
            iconTitle = `Video download`;
            break;
          case `vimeo`:
            download.icon = `vimeo-v`;
            iconTitle = `Vimeo video`;
            break;
          case `youtube`:
            download.youtubeid = download.link.split(`=`);
            if (youtubeID.innerHTML === download.youtubeid.pop()) return;
            download.icon = `youtube`;
            iconTitle = `YouTube video`;
            break;
          default:
            download.icon = `external-link`;
        }
        const a = document.createElement(`a`),
          i = document.createElement(`i`);
        a.href = download.link;
        a.title = iconTitle;
        switch (download.icon) {
          case `soundcloud`:
          case `youtube`:
          case `vimeo-v`:
            // font awesome brand
            i.classList.add(`fab`, `fa-${download.icon}`);
            break;
          default:
            // font awesome light
            i.classList.add(`fal`, `fa-${download.icon}`);
        }
        a.append(i);
        downloads.append(`\xa0\xa0\xa0`, a);
      };
      for (const download of data.downloadLinks) {
        update(download);
      }
    };

    const unlistedDemozoo = () => {
      // When an unlisted Demozoo link is discovered, request its API data
      const none = 0;
      if (data.demozoo === none) return;
      if (demozoo.innerHTML.length) return;
      document.getElementById(`demozooContainer`).classList.remove(`hidden`);
      checkID(`demozoo`, data.demozoo);
    };

    const directDownload = () => {
      const download = data.download,
        valid = [`http`, `https`, `ftp`];
      if (extLinks.includes(download)) return;
      const link = download.split(`:`)[0];
      if (!valid.includes(link)) return;
      extLinks.push(download);
      swapDownloadEvent(extLinks.length, download);
    };

    productionLink();
    parties();
    votes();
    authors();
    downloadLinks();
    unlistedDemozoo();
    directDownload();
    container.classList.remove(`hidden`);
  }

  // Commands the Lucee server to remotely fetch and save a file.
  // The file save is to be used as the file download for the Defacto2 file item.
  //
  // The results are returned as a JSON page that is handled by the fetch API.
  // The Lucee trigger function is httprequest() that's found at /controllers/Files.cfc.
  // The Lucee download function is downloadBin() in /events/function.cfm.
  // The trigger URL used by the fetch API is set to `triggerLink`.
  // The record UUID is supplied via the `id` query string.
  // The remote file location is supplied via the `url` query string.

  /**
   * Creates an event listener for swapDownload().
   * Command the Lucee server to remotely fetch an save the URL and use it
   * as the download offering for the local file record.
   *
   * @param {*} [index=-1]
   * @param {string} [url=``]
   */
  function swapDownloadEvent(index = 0, url = ``) {
    const downloads = document.getElementById(`list-of-external-downloads`),
      uuid = document.getElementById(`uuid`);
    if (downloads == null) return;
    if (uuid == null) return;

    const p = document.createElement(`p`);

    const replaceDownloadButton = () => {
      let request = index;
      request--;
      p.id = `httprequest${request}`;
      p.classList.add(`eclipse`);
      const a = document.createElement(`a`);
      a.classList.add(`btn`, `btn-xs`, `btn-warning`);
      a.title = `Replace the download with this file?`;
      const i = document.createElement(`i`);
      i.classList.add(`fal`, `fa-copy`);
      i.style.color = `#fff`;
      const small0 = document.createElement(`small`);
      small0.style.display = `none`;
      small0.textContent = `${uuid.value}`;
      a.append(i);
      p.append(a, small0);
    };

    const resetSmall = () => {
      const small1 = document.createElement(`small`);
      small1.textContent = ` ${url}`;
      p.append(small1, document.createElement(`br`));
      downloads.append(p);
      downloads.classList.remove(`hidden`);
    };

    const fetchDownload = () => {
      if (linkID !== `0`) return;
      if (document.getElementById(`formOnFile[filename]`).value !== ``) return;
      // If record on the database is missing a filename, so there is no
      // file download available. But there is an external link, then trigger
      // it to download to the server.
      console.info(`Automatic download started`);
      document.getElementById(`httprequest${linkID}`).click();
    };

    replaceDownloadButton();
    resetSmall();
    fetchDownload();

    let linkID;
    for (linkID in extLinks) {
      // a loop is necessary for creating listeners,
      // otherwise only the last element is set
      document
        .getElementById(`httprequest${linkID}`)
        .addEventListener(`click`, swapDownload, false);
    }
    fetchDownload();
  }

  /**
   * Commands the Lucee server to remotely fetch and save a file.
   * The file save is to be used as the file download for the Defacto2 file item.
   *
   * @this swapDownload
   */
  function swapDownload() {
    const auto = document.getElementById(`formOnFile[filename]`).value === ``,
      a = this.getElementsByTagName(`a`)[0],
      svg = this.getElementsByTagName(`svg`)[0],
      uuid = this.getElementsByTagName(`small`)[0].innerText.trim();

    let link = this.getElementsByTagName(`small`)[1].innerText.trim();
    const domain = link.split(`/`)[2],
      proto = link.split(`/`)[0],
      form = document.getElementById(`form6field`);

    const internal = () => {
      if (location.pathname === `/index.cfm`)
        return `${location.protocol}//${location.host}/index.cfm?controller=file&action=httprequest&id=${uuid}&url=`;
      return `${location.protocol}//${location.host}/file/httprequest?id=${uuid}&url=`;
    };

    const buttonColors = () => {
      if (typeof a !== `undefined`) {
        a.classList.remove(`btn-warning`, `btn-danger`);
        a.classList.add(`btn-primary`);
      }
      if (typeof svg !== `undefined`) {
        svg.classList.remove(`btn-warning`, `btn-danger`);
        svg.classList.add(`btn-primary`);
      }
    };

    /**
     * Changes the swapDownload() toggle button colour.
     * If the feedback contains the word `error` then it is assumed it is
     * an error response.
     *
     * @param {string} [error=``] Warning message to send to the browser console
     */
    const changeButton = (error = ``) => {
      form.disabled = true;
      if (typeof a !== `undefined`) a.classList.remove(`btn-primary`);
      if (typeof svg !== `undefined`)
        svg.classList.remove(`btn-primary`, `fa-cog`, `fa-spin`);
      if (error.length !== 0) {
        if (typeof a !== `undefined`) a.classList.add(`btn-danger`);
        if (typeof svg !== `undefined`)
          svg.classList.add(`btn-danger`, `fa-exclamation-circle`);
        return console.warn(`${error}. Transfer link: ${link}`);
      }
      if (typeof a !== `undefined`) a.classList.add(`btn-success`);
      if (typeof svg !== `undefined`)
        svg.classList.add(`btn-success`, `fa-check`);
    };

    /**
     * Create a new Bootstrap alert for use as page feedback.
     *
     * @param {string} [context=``] Context of the alert, either `success`, `info`, `warning`, `danger`
     * @param {string} [message=``] Alert message
     * @returns
     */
    const flash = (context = ``, message = ``) => {
      const date = new Date(),
        time = date.toLocaleTimeString(`en-GB`, { hour12: false });
      return (
        `<div class="alert alert-${context} alert-dismissible">` +
        `<button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>` +
        `<span class="alert-link"> <small><code style="float:right;">${time}</code>` +
        `</small> ${message}</span></div>`
      );
    };

    const parseDownload = (response) => {
      const feedback = () => {
        if (auto) {
          flashes.innerHTML += flash(
            `success`,
            `<i class="fal fa-check fa-fw fa-lg"></i>` +
              ` The automatic download was successful so now the ` +
              `<a href="/file/edit?uuid=${uuid}&rescanpackage=true" id="refreshArchiveContent">archive content needs to be refreshed</a>` +
              ` <i class="fal fa-archive fa-lg fa-fw"></i><i class="fal fa-redo fa-lg fa-fw"></i>`
          );
          return;
        }
        flashes.innerHTML += flash(
          `success`,
          `<i class="fal fa-check fa-fw fa-lg"></i>` +
            ` The <strong>replacement download</strong> was successful<br>` +
            `<i class="fal fa-redo fa-lg fa-fw"></i> But the ` +
            `<a href="/file/edit?uuid=${uuid}&rescanpackage=true" id="refreshArchiveContent">archive content needs to be refreshed</a>`
        );
      };

      const updateForm = () => {
        const fileSize = document.getElementById(`fSize`),
          filename = document.getElementById(`formOnFile[filename]`),
          title = document.getElementById(`filename`),
          lastModified = document.getElementById(`fLastModValue`),
          mda5 = document.getElementById(`fHashValue`),
          platform = document.getElementById(`formOnFile-platform`),
          sha384 = document.getElementById(`fSha384Value`);
        if (response.filename.length) {
          if (filename !== null) filename.value = response.filename;
          if (title !== null) title.value = response.filename;
        }
        if (response.filemd5.length && mda5 !== null)
          mda5.textContent = response.filemd5;
        if (response.filesha384.length && sha384 !== null)
          sha384.textContent = response.filesha384;
        if (response.filesize.length && fileSize !== null)
          fileSize.textContent = response.filesize;
        if (response.lastModified.length && lastModified !== null)
          lastModified.textContent = response.lastModified;
        if (response.platform.length && platform !== null)
          platform.value = response.platform;
        form.disabled = false;
      };

      const reloadPage = () => {
        const refresh = document.getElementById(`refreshArchiveContent`);
        if (refresh !== null) {
          refresh.disabled = false;
          refresh.click();
        }
      };

      // Parse JSON reply created by the File.cfc httprequest() function.
      if (typeof svg !== `undefined`)
        svg.classList.remove(`btn-danger`, `btn-warning`, `btn-primary`);
      if (response.length === 0) return;
      feedback();
      changeButton();
      updateForm();
      reloadPage();
    };

    const transfer = () => {
      const url = internal() + link.trim();
      console.info(`Pinging ${url}`);
      fetch(url, {
        method: `GET`,
        headers: {
          "Content-Type": `application/json charset=UTF-8`,
        },
      })
        .then((response) => {
          if (!response.ok) {
            changeButton(
              `Transfer failed. The server did not return any useful information`
            );
            flashes.innerHTML += flash(
              `danger`,
              `The transfer of the <strong>replacement download</strong>` +
                ` failed with HTTP Error ${response.status}`
            );
            const error = `A network "${response.status}" error occurred requesting transfer`;
            throw new Error(
              `${error}: ${response.statusText} ${response.status}`
            );
          }
          return response.json();
        })
        .then((result) => parseDownload(result))
        .catch((err) => {
          changeButton(`A controller error occurred`);
          const error = `An error occurred requesting transfer`;
          console.error(`${error}: ${err}`);
        });
    };

    const validate = () => {
      switch (proto) {
        case `ftp:`:
        case `http:`:
        case `https:`:
          // protocol okay, do nothing
          break;
        default:
          return changeButton(
            `Transfer failed. Protocol ${proto.toUpperCase()}// ` +
              `used by the link ${link} is unsupported`
          );
      }
      switch (domain) {
        case `files.scene.org`:
          link = link.replace(
            `://files.scene.org/view/`,
            `://archive.scene.org/pub/`
          );
          return (link = link.replace(`https://`, `http://`));
        default:
        // domain okay, do nothing
      }
    };

    if (auto) {
      flashes.innerHTML += flash(
        `info`,
        `<i class="fal fa-download fa-fw fa-lg"></i>` +
          ` Automatically fetching <a href="${link}">${link}</a>`
      );
    } else if (!confirm(`Replace the download file with ${link} ?`)) return;

    form.disabled = true;
    buttonColors();
    validate();
    transfer();
  }

  /**
   * Returns the numeral and ordinal indictor of an integer.
   * Source: https://www.w3resource.com/javascript-exercises/javascript-string-exercise-15.php
   *
   * @param {number} [int=0] An integer
   * @returns string
   */
  function ordinalInt(int = 0) {
    const n = parseInt(int);
    if (isNaN(n)) return `${int}`;
    const hundred = 100,
      ten = 10,
      forteen = 14;
    if (n % hundred > ten && n % hundred < forteen) return `${n}th`;
    const first = 1,
      second = 2,
      third = 3;
    switch (n % ten) {
      case first:
        return `${n}st`;
      case second:
        return `${n}nd`;
      case third:
        return `${n}rd`;
      default:
        return `${n}th`;
    }
  }
})();
