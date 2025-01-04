/*
  Charts.
  path: javascript/src/operator-dialog.js

*/
(() => {
  ("use strict");
  const version = new Map()
    .set(`date`, new Date(`30,May,2022`))
    .set(`minor`, `6`)
    .set(`major`, `1`)
    .set(`display`, ``);

  version.set(
    `display`,
    `${version.get(`major`)}.${version.get(`minor`)} (${version
      .get(`date`)
      .toLocaleDateString()})`
  );

  const form1 = document.getElementById(`form1`);

  // Tag label
  const labelJS = document.getElementById(`fofLabelJS`),
    labelRadios = form1.elements[`formOnFile[section]`],
    labelChoice = new Choices(labelJS, {
      choices: [
        {
          value: `bbs`,
          label: `BBS<br><small>Files pertaining to the Scene using telephone Bulletin Board Systems</small>`,
          customProperties: {
            keywords: `online ftp`,
          },
        },
        {
          value: `forsale`,
          label: `For sale<br><small>Adverts for commercial physical goods or online services</small>`,
          customProperties: {
            keywords: `ad`,
          },
        },
        {
          value: `ftp`,
          label: `FTP<br><small>Files pertaining to the Scene operating over Internet based File Transfer Protocol servers</small>`,
          customProperties: {
            keywords: `online bbs`,
          },
        },
        {
          value: `groupapplication`,
          label: `Group role or job<br><small>Documents used by scene groups to advertise positions or enrol new members</small>`,
          customProperties: {
            keywords: `app ad`,
          },
        },
        {
          value: `logo`,
          label: `Brand art or logo<br><small>Logos used by scene groups or organisations</small>`,
          customProperties: {
            keywords: `trademark tm seal monogram`,
          },
        },
        {
          value: `magazine`,
          label: `Magazine<br><small>Reports and articles written about the Scene</small>`,
          customProperties: {
            keywords: `text txt mag news`,
          },
        },
        {
          value: `releaseadvert`,
          label: `Cracktro or intro<br><small>A multimedia program designed to promote a scene group or organisation</small>`,
          customProperties: {
            keywords: `demo loader app`,
          },
        },
        {
          value: `releaseinformation`,
          label: `NFO file or scene release text<br><small>Text file or readme used to describe a scene release, group or organisation</small>`,
          customProperties: {
            keywords: `rls txt doc diz fileid`,
          },
        },
        {
          value: `announcements`,
          label: `Announcement<br><small>Public announcement by a scene group or organisation</small>`,
          customProperties: {
            keywords: `news`,
          },
        },
        {
          value: `ansieditor`,
          label: `ANSI tool<br><small>Program to create and edit ANSI or ASCII art</small>`,
          customProperties: {
            keywords: `app`,
          },
        },
        {
          value: `appleii`,
          label: `Apple II<br><small>Files pertaining to the Scene on the Apple II platform</small>`,
          customProperties: {
            keywords: `apple2`,
          },
        },
        {
          value: `atarist`,
          label: `Atari ST<br><small>Files pertaining to the Scene on the Atari ST platform</small>`,
          customProperties: {
            keywords: ``,
          },
        },
        {
          value: `demo`,
          label: `Demo<br><small>An artistic multimedia program that is designed to promote a demo group or collective</small>`,
          customProperties: {
            keywords: `intro app`,
          },
        },
        {
          value: `gamehack`,
          label: `Game hack<br><small>Trainers, dox, cheats, and walk-throughs, which include guides, how-to documents and tools to complete games</small>`,
          customProperties: {
            keywords: `howto doc walkthrough`,
          },
        },
        {
          value: `guide`,
          label: `Guide or how-to<br><small>Guides and how-to documents on how to hack and crack or on the workings of the Scene</small>`,
          customProperties: {
            keywords: `howto doc`,
          },
        },
        {
          value: `internaldocument`,
          label: `Restricted<br><small>Internal documents created by scene groups that were often never intended to be public</small>`,
          customProperties: {
            keywords: `text txt doc inside`,
          },
        },
        {
          value: `interview`,
          label: `Interview<br><small>Conversations conducted with scene personalities</small>`,
          customProperties: {
            keywords: `chat log text txt doc`,
          },
        },
        {
          value: `newsmedia`,
          label: `Mainstream news<br><small>Mainstream media outlets reports on the Scene</small>`,
          customProperties: {
            keywords: ``,
          },
        },
        {
          value: `nfotool`,
          label: `NFO tool<br><small>Program to create or view a NFO text file</small>`,
          customProperties: {
            keywords: `app`,
          },
        },
        {
          value: `package`,
          label: `Filepack<br><small>A curated bundle of scene related files stored and distributed in a compressed archive file</small>`,
          customProperties: {
            keywords: `zip tar`,
          },
        },
        {
          value: `politics`,
          label: `Community drama<br><small>Used for anything political that doesn't fall into the other categories. Usually contains documents where people, groups or organisations are complaining</small>`,
          customProperties: {
            keywords: ``,
          },
        },
        {
          value: `programmingtool`,
          label: `Computer tool<br><small>Miscellaneous tools including fixes, intro generators and BBS software</small>`,
          customProperties: {
            keywords: `app hack`,
          },
        },
        {
          value: `releaseinstall`,
          label: `Scene software installer<br><small>A program to help an end-user install a scene release</small>`,
          customProperties: {
            keywords: `app`,
          },
        },
        {
          value: `releaseproof`,
          label: `Release proof<br><small>Evidence of the source media for a scene release, usually a photo or scanned image</small>`,
          customProperties: {
            keywords: ``,
          },
        },
        {
          value: `scenerules`,
          label: `Community standard<br><small>Various codes of conduct and agreements created by scene groups and organisations</small>`,
          customProperties: {
            keywords: `rule`,
          },
        },
        {
          value: `takedown`,
          label: `Bust or takedown<br><small>Accounts and third party reports on the arrest, bust or takedown of the Scene community</small>`,
          customProperties: {
            keywords: `person people organisation`,
          },
        },
      ],
      removeItemButton: true,
      searchFields: [`label`, `value`, `customProperties.keywords`],
      searchFloor: 2,
      searchResultLimit: 6,
      shouldSort: false,
      searchPlaceholderValue: `search`,
    });

  // Tag a platform or the program operating system
  const platformJS = document.getElementById(`fofPlatformJS`),
    platformRadios = form1.elements[`formOnFile[platform]`],
    platformChoice = new Choices(platformJS, {
      choices: [
        {
          value: `ansi`,
          label: `ANSI<br><small>Coloured, text based computer art form widely used on Bulletin Board Systems</small>`,
          customProperties: {
            keywords: `bbs color`,
          },
        },
        {
          value: `dos`,
          label: `DOS<br><small>Microsoft DOS or an IBM PC program</small>`,
          //selected: true,
          customProperties: {
            keywords: `app`,
          },
        },
        {
          value: `image`,
          label: `Image<br><small>Digital art, pixel art or a photo</small>`,
          customProperties: {
            keywords: `bbm bmp jpg jpeg gif iff lbm pcx pic png tga tiff webp`,
          },
        },
        {
          value: `text`,
          label: `Text or ASCII<br><small>Text document or text based computer art</small>`,
          customProperties: {
            keywords: `art bbs`,
          },
        },
        {
          value: `textamiga`,
          label: `Text for Amiga<br><small>Text document or text based computer art for the Commodore Amiga</small>`,
          customProperties: {
            keywords: `ascii art bbs`,
          },
        },
        {
          value: `windows`,
          label: `Windows<br><small>Microsoft Windows program</small>`,
          customProperties: {
            keywords: `app exe`,
          },
        },
        {
          value: `audio`,
          label: `Music<br><small>Music or audio sound clip</small>`,
          customProperties: {
            keywords: `aac aiff flac mp3 mp4 m4a ogg pcm wav wma mod okt mtm med ahx s3m xm it`,
          },
        },
        {
          value: `database`,
          label: `Database or spreadsheet<br><small>A structured collection of data</small>`,
          customProperties: {
            keywords: `db mysql excel postgres server`,
          },
        },
        {
          value: `java`,
          label: `Java<br><small>Java program</small>`,
          customProperties: {
            keywords: `app applet jvm class`,
          },
        },
        {
          value: `linux`,
          label: `Linux<br><small>Linux program</small>`,
          customProperties: {
            keywords: `app unix`,
          },
        },
        {
          value: `mac10`,
          label: `MacOS<br><small>macOS, Mac OS X or Macintosh program</small>`,
          customProperties: {
            keywords: `app apple osx os-x`,
          },
        },
        {
          value: `markup`,
          label: `HTML<br><small>Web page or a document in HTML format</small>`,
          customProperties: {
            keywords: `webpage site webapp server`,
          },
        },
        {
          value: `pcb`,
          label: `PCBoard<br><small>Coloured encoded text mainly used on Bulletin Board Systems</small>`,
          customProperties: {
            keywords: `ansi art bbs color`,
          },
        },
        {
          value: `pdf`,
          label: `PDF<br><small>A document compiled in PDF (Portable Document Format)</small>`,
          customProperties: {
            keywords: `adobe`,
          },
        },
        {
          value: `php`,
          label: `Script<br><small>Script or interpreted program</small>`,
          customProperties: {
            keywords: `app shell bash mirc`,
          },
        },
        {
          value: `video`,
          label: `Video<br><small>A film, video or multimedia animation</small>`,
          customProperties: {
            keywords: `mp4 divx avi wmv flv mov`,
          },
        },
      ],
      removeItemButton: true,
      searchFields: [`label`, `value`, `customProperties.keywords`],
      searchFloor: 2,
      searchResultLimit: 6,
      shouldSort: false,
      searchPlaceholderValue: `search`,
    });

  // Tag events
  labelJS.addEventListener(
    `addItem`,
    (event) => {
      labelRadios.value = event.detail.value;
    },
    false
  );
  labelJS.addEventListener(
    `removeItem`,
    () => {
      labelRadios.value = ``;
    },
    false
  );
  platformJS.addEventListener(
    `addItem`,
    (event) => {
      platformRadios.value = event.detail.value;
    },
    false
  );
  platformJS.addEventListener(
    `removeItem`,
    () => {
      platformRadios.value = ``;
    },
    false
  );
  window.onload = () => {
    const label = metaContent(`tag:label`),
      plat = metaContent(`tag:platform`);
    if (label.length) labelChoice.setChoiceByValue(`${label}`);
    if (plat.length) platformChoice.setChoiceByValue(`${plat}`);
  };

  // Form buttons
  const form = {
      blankDates: document.getElementById(`blank-date-button`),
      comment: document.getElementById(`formOnFile[comment]`),
      commentURL: document.getElementById(`commentUrlBtn`),
      dateY: document.getElementById(`date_issued_year`),
      dateM: document.getElementById(`date_issued_month`),
      dateD: document.getElementById(`date_issued_day`),
      deleteNotes: document.getElementById(`btn-del-notes`),
      lastModDate: document.getElementById(`btn-last-mod`),
      previewUpload: document.getElementById(`filePreviewUpload`),
      replaceDownload: document.getElementById(`replaceDownload`),
    },
    form5 = {
      form: document.getElementById(`form5`),
      previewImage: document.getElementById(`formOnFile-preview_image`),
    },
    clipboard = new ClipboardJS(`.btn`),
    year = metaContent(`filemod:y`),
    month = metaContent(`filemod:m`),
    day = metaContent(`filemod:d`);

  // Event listeners for the form buttons
  const tmp = document.getElementById(`deleteThumb`);
  if (tmp !== null) {
    const e = document.getElementById(`deleteThumbAlt`);
    if (e !== null) e.addEventListener(`click`, () => tmp.click());
  }
  const tmp1 = document.getElementById(`refresh_thumbs`);
  if (tmp1 !== null) {
    const e = document.getElementById(`refreshThumbsAlt`);
    if (e !== null) e.addEventListener(`click`, () => tmp1.click());
  }
  form.blankDates.addEventListener(`click`, () => {
    blankDates();
  });
  form.deleteNotes.addEventListener(`click`, () => {
    form.comment.value = ``;
  });
  // note: arrow functions do not support `this`
  document.getElementById(`autofmt-ed`).addEventListener(`click`, () => {
    autoFormat(`autofmt-ed`);
  });
  document.getElementById(`autofmt-fn`).addEventListener(`click`, () => {
    autoFormat(`autofmt-fn`);
  });
  document.getElementById(`autofmt-pf`).addEventListener(`click`, () => {
    autoFormat(`autofmt-pf`);
  });
  document.getElementById(`autofmt-pb`).addEventListener(`click`, () => {
    autoFormat(`autofmt-pb`);
  });
  document.getElementById(`swapGroups`).addEventListener(`click`, () => {
    swapGroup();
  });
  form.previewUpload.addEventListener(`change`, () => {
    form.previewUpload.classList.replace(`btn-primary`, `btn-info`);
    form5.form.submit();
  });
  document.getElementById(`saveEditsTop`).addEventListener(`click`, () => {
    clickFeedback(`saveEditsTop`);
  });
  document.getElementById(`saveEditsBtm`).addEventListener(`click`, () => {
    clickFeedback(`saveEditsBtm`);
  });
  document.getElementById(`saveImages`).addEventListener(`click`, () => {
    clickFeedback(`saveImages`);
  });
  form.replaceDownload.addEventListener(`click`, () => {
    clickFeedback(`replaceDownload`, `warning`);
  });
  form.lastModDate.addEventListener(`click`, () => {
    document.getElementById(`date_issued_year`).value = year;
    document.getElementById(`date_issued_month`).value = month;
    document.getElementById(`date_issued_day`).value = day;
  });
  document.getElementById(`reDownloadConfirm`).addEventListener(`click`, () => {
    toggleSubmit();
  });
  document.getElementById(`file-replace`).addEventListener(`change`, () => {
    toggleSubmit();
  });
  document.getElementById(`resetReDownload`).addEventListener(`click`, () => {
    document.getElementById(`replaceDownload`).disabled = true;
  });
  [...document.querySelectorAll(`.dosee-link`)].map((element) =>
    element.addEventListener(`click`, swapDosee)
  );

  document
    .getElementById(`thirdPartyAll`)
    .addEventListener(`click`, toggleLinks);
  document
    .getElementById(`thirdPartyHide`)
    .addEventListener(`click`, toggleLinks);

  const youtube = `formOnFile[web_id_youtube]`,
    github = `formOnFile[web_id_github]`,
    unwanted = `formOnFile[file_security_alert_url]`;

  if (document.getElementById(youtube).value !== ``)
    document.getElementById(`thirdPartyAll`).click();
  else if (document.getElementById(github).value !== ``)
    document.getElementById(`thirdPartyAll`).click();
  else if (document.getElementById(unwanted).value !== ``)
    document.getElementById(`thirdPartyAll`).click();

  document.getElementById(github).addEventListener(`paste`, (event) => {
    const paste = `${(event.clipboardData || window.clipboardData).getData(
      `text`
    )}`;
    const match = `github.com`,
      index = paste.lastIndexOf(match);
    if (index < 0) return;
    document.getElementById(github).value = paste.substring(
      index + match.length
    );
    event.preventDefault();
  });

  // Scan the additional notes for URL links
  const scanComment = () => {
    if (form.commentURL === null) return;
    const value = form.comment.value,
      url = form.commentURL;
    if (value.indexOf(`https://`)) url.disabled = false;
    if (value.indexOf(`http://`)) url.disabled = false;
    if (value.indexOf(`ftp://`)) url.disabled = false;
    url.addEventListener(`click`, () => {
      // In search of the perfect URL validation regex:
      // https://mathiasbynens.be/demo/url-regex
      //
      // Regular Expression for URL validation:
      // https://gist.github.com/dperini/729294
      const firstURL = value.match(
        /(?:(?:https?|ftp):\/\/)(?:\S+(?::\S*)?@)?(?:(?!(?:10|127)(?:\.\d{1,3}){3})(?!(?:169\.254|192\.168)(?:\.\d{1,3}){2})(?!172\.(?:1[6-9]|2\d|3[0-1])(?:\.\d{1,3}){2})(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|(?:(?:[a-z\u00a1-\uffff0-9]-*)*[a-z\u00a1-\uffff0-9]+)(?:\.(?:[a-z\u00a1-\uffff0-9]-*)*[a-z\u00a1-\uffff0-9]+)*(?:\.(?:[a-z\u00a1-\uffff]{2,}))\.?)(?::\d{2,5})?(?:[/?#]\S*)?$/i
      );
      if (form5.previewImage === null) return;
      if (!firstURL) return;
      if (firstURL.length === 0) return;
      console.log(`Using URL ${firstURL[0]} as the preview image`);
      form5.previewImage.value = firstURL[0];
    });
  };
  scanComment();

  clipboard.on(`success`, function (event) {
    // clipboard.JS https://github.com/zenorocha/clipboard.js
    event.clearSelection();
  });

  // DOSee screencapture and upload
  const doseeCanvas = function (blob, button) {
    if (typeof blob === `undefined`)
      throw Error(`doseeCanvas requires a blob object`);
    if (typeof button === `undefined`)
      throw Error(`doseeCanvas requires a button element`);
    if (`size` in blob === false) {
      return console.error(`expected a 'size' property in the blob object`);
    }
    if (blob.size === 0)
      return console.error(
        `the screenshot image size of ${blob.size} is incorrect, it should not be less than 1 byte in size`
      );
    if (`type` in blob === false)
      return console.error(`Expected a 'type' property in the blob object`);
    if (blob.type !== `image/png`)
      return console.error(
        `The screenshot image mime type '${blob.type}' is incorrect, it should be 'image/png'`
      );
    const filename = metaContent(`dosee:capture:filename`),
      uuid = document.getElementById(`uuid`).value;
    if (filename === null)
      throw new Error(`meta element dosee:capture:filename is required`);
    const data = new FormData();
    data.append(`uuid`, uuid);
    data.append(`filePreviewUpload`, blob, filename);

    fetch(`/file/images${window.location.search}#hamburgers`, {
      method: `POST`,
      body: data,
    })
      .then((response) => {
        if (!response.ok) {
          button.classList.replace(`btn-info`, `btn-danger`);
          console.log(
            `DOSee screenshot capture upload error '${response.status}'`
          );
          const serverError = 500;
          if (response.status === serverError) {
            // dump the Lucee debug output to the page
            const flashes = document.getElementById(`flashCollection`);
            flashes.innerHTML = response;
          }
          return;
        }
        button.classList.replace(`btn-info`, `btn-success`);
        console.log(
          `DOSee screenshot capture was uploaded, now reloading this page`
        );
        return window.location.reload();
      })
      .catch((err) => {
        const error = `An error occurred uploading the DOSee screenshot`;
        console.error(`${error}: ${err}`);
      });
  };
  const doseeScreenshot = () => {
    const check = Boolean(new Blob());
    if (typeof check === `undefined`)
      throw Error(
        `doseeScreenshot requires a browser that supports the Blob web api`
      );
    const button = document.getElementById(`doseeCaptureUpload`);
    if (button === null) return;
    button.addEventListener(`click`, () => {
      button.classList.replace(`btn-primary`, `btn-info`);
      const canvas = document.getElementById(`doseeCanvas`);
      canvas.toBlob((blob) => {
        doseeCanvas(blob, button);
      });
    });
  };
  try {
    // DOSee capture screenshot and upload button
    // for the server-side handling, see: File.cfc - images() {}
    doseeScreenshot();
  } catch (err) {
    console.error(err);
  }

  // Auto-format buttons
  function autoFormat(id = ``) {
    const formats = () => {
      switch (id) {
        case `autofmt-ed`:
          return `formOnFile[record_title]`;
        case `autofmt-fn`:
          return `formOnFile[filename]`;
        case `autofmt-pf`:
          return `formOnFile[group_brand_for]`;
        case `autofmt-pb`:
          return `formOnFile[group_brand_by]`;
        default:
          throw Error(`autoformat id ${id} is unknown`);
      }
    };
    const title = () => {
      switch (id) {
        case `autofmt-fn`:
          return document.getElementById(format).value.toLowerCase();
        default:
          return capitalizeWords(document.getElementById(format).value);
      }
    };
    const format = formats();
    document.getElementById(format).value = title();
  }

  // Blank the dates of custom date input forms
  const blankDates = () => {
    form.dateY.value = ``;
    form.dateM.value = ``;
    form.dateD.value = ``;
  };

  // Capitalise each word in a string
  const capitalizeWords = (words) => {
    return words.replace(/\w\S*/g, (word) => {
      return word.charAt(0).toUpperCase() + word.substr(1).toLowerCase();
    });
  };

  // Swap the values of group_brand_for and group_brand_by group inputs
  function swapGroup() {
    const groupFor = document.getElementById(`formOnFile[group_brand_for]`),
      groupBy = document.getElementById(`formOnFile[group_brand_by]`);
    if (groupFor.value === null && groupBy.value === null) return;
    const forValue = groupFor.value;
    groupFor.value = groupBy.value;
    groupBy.value = forValue;
  }

  // DOSee toggles
  function swapDosee() {
    document.getElementById(`showDoseeHardware`).classList.toggle(`hidden`);
    document.getElementById(`hideDoseeHardware`).classList.toggle(`hidden`);
    [...document.querySelectorAll(`.dosee-hardware`)].map((element) =>
      element.classList.toggle(`hidden`)
    );
  }

  // Third party links toggles
  function toggleLinks() {
    const ids = document.getElementById(`thirdPartyIds`),
      all = document.getElementById(`thirdPartyAll`),
      hide = document.getElementById(`thirdPartyHide`);
    ids.classList.toggle(`hidden`);
    all.classList.toggle(`hidden`);
    hide.classList.toggle(`hidden`);
  }

  // Changes the colour of the form submit buttons
  // @id = element id
  // @colour = is a bootstrap colour name (danger,primary,warning,success)
  function clickFeedback(id, colour = `primary`) {
    if (typeof id === `undefined`)
      throw Error(`click feedback requires an element id`);
    switch (colour) {
      case `danger`:
      case `primary`:
      case `warning`:
      case `success`:
        return document
          .getElementById(id)
          .classList.replace(`btn-${colour}`, `btn-info`);
      default:
        throw Error(`unknown click feedback colour "${colour}`);
    }
  }

  function toggleSubmit() {
    const button = document.getElementById(`file-replace`),
      confirm = document.getElementById(`reDownloadConfirm`).checked;
    if (confirm && button.value.length) {
      form.replaceDownload.disabled = false;
      return;
    }
    form.replaceDownload.disabled = true;
  }

  console.info(
    `Loaded admin dialogs ${version.get(`display`)} (operator-dialog.js)`
  );
})();
