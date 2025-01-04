/*
  Send your files.
  path: javascript/src/upload.js

  For Demozoo and Pouet lookup services,
  see: upload-input-production-id.js, upload-input-references.js

*/
(() => {
  ("use strict");
  const version = new Map()
    .set(`date`, new Date(`15,June,2022`))
    .set(`minor`, `8`)
    .set(`major`, `4`)
    .set(`display`, ``);

  version.set(
    `display`,
    `${version.get(`major`)}.${version.get(`minor`)} (${version
      .get(`date`)
      .toLocaleDateString()})`
  );

  // set verbose to true to enable console debugging
  const verbose = false,
    storage = storageAvailable(`local`),
    missing = -1,
    okay = 200,
    URLRewrite = `/index.cfm`;
  // This object is used with transfer calculations and client status updates
  const transfer = {
    // Bytes upload (event.loaded)
    bytes: 0,
    // Cap the maximum number of files for transfer
    cap: 100,
    // Queued uploads
    count: 0,
    // Completed uploads
    completed: 0,
    // Upload failed?
    error: false,
    // Total number of bytes to transfer
    sum: 0,
    // Time counter in milliseconds
    timer: null,
  };
  // Array container that's used for multiple XMLHttpRequest() instances
  const xhr = [];

  // Event listeners
  const initButtons = () => {
    const subFiles = document.getElementById(`upload-files-button`);
    if (subFiles === null) {
      // Demozoo, Pouët tab selection (/upload/external)
      const subId = document.getElementById(`upload-id-button`);
      return subId.addEventListener(`click`, submitID);
    }
    resetSwap(`clear`);
    const abort = document.getElementById(`abort-button`),
      reset = document.getElementById(`reset-button`),
      select = document.getElementById(`select-files-js`);
    abort.addEventListener(`click`, transferAbort);
    reset.addEventListener(`click`, clearForm);
    select.addEventListener(`change`, () => {
      formReset(true);
      filesStore();
      chooseFiles();
    });
    // reveal the form elements
    formInit();
    // when files have been selected by browser tab is refreshed (F5)
    displayFiles();
    subFiles.addEventListener(`click`, uploadFiles);
  };

  const initStorage = () => {
    // Local storage to save and restore form input values
    if (storage !== true) return;
    filesRestore();
    // Inputs
    const autoclear = document.getElementById(`autoClear`),
      comment = document.getElementById(`new-file-comment`),
      code = document.getElementById(`newFile-credit_program`),
      gfx = document.getElementById(`newFile-credit_illustration`),
      music = document.getElementById(`newFile-credit_audio`),
      writer = document.getElementById(`newFile-credit_text`),
      d = document.getElementById(`newFile-web_id_demozoo`),
      platform = document.getElementById(`newFile-platform`),
      p = document.getElementById(`newFile-web_id_pouet`),
      title = document.getElementById(`newFile-record_title`),
      groupBy = document.getElementById(`newFile-group_brand_by`),
      groupFor = document.getElementById(`newFile-group_brand_for`),
      year = document.getElementById(`newFile-date_issued_year`),
      month = document.getElementById(`newFile-date_issued_month`),
      day = document.getElementById(`newFile-date_issued_day`),
      section = document.getElementById(`newFile-section`),
      y = document.getElementById(`newFile-web_id_youtube`);
    // Event listener to update local storage when inputs change
    const listen = (name = ``, elm) => {
      if (typeof elm === `undefined`)
        throw Error(`storage event listen ${name} elm argument is required`);
      const notUsed = null;
      if (elm === notUsed) return;
      const store = localStorage.getItem(`upload${name}`);
      if (store !== null) elm.value = store;
      // cannot use arrow functions due to this.value requirement.
      elm.addEventListener(`change`, () => {
        const item = `upload${name}`,
          val = elm.value;
        if (val.length === 0) return localStorage.removeItem(item);
        localStorage.setItem(item, val);
      });
    };
    // checks for and handles change events for the element.
    const checks = (name = ``, elm) => {
      if (typeof elm === `undefined`)
        throw Error(`storage event listen ${name} elm argument is required`);
      const notUsed = null;
      if (elm === notUsed) return;
      const store = localStorage.getItem(`${name}`);
      if (store === `true`) elm.checked = true;
      // cannot use arrow functions due to this.value requirement.
      elm.addEventListener(`change`, () => {
        const item = `${name}`,
          val = elm.checked;
        if (val.length === 0) return localStorage.removeItem(item);
        localStorage.setItem(item, val);
      });
    };
    // pasterDz monitors for production URLs that are pasted into the Demozoo ID form input
    const pasterDz = () => {
      d.addEventListener(`paste`, (event) => {
        const paste = (event.clipboardData || window.clipboardData).getData(
          `text`
        );
        const url = new URL(paste);
        if (url.hostname !== `demozoo.org`) return;
        let paths = url.pathname.split(`/`);
        paths = paths.filter((path) => path);
        if (paths.length !== 2) return;
        if (paths[0] !== `productions`) return;
        d.addEventListener(
          `input`,
          () => {
            d.value = `${paths[1]}`;
          },
          { once: true }
        );
      });
    };
    // pasterP monitors for production URLs that are pasted into the Pouet ID form input
    const pasterP = () => {
      p.addEventListener(`paste`, (event) => {
        const paste = (event.clipboardData || window.clipboardData).getData(
          `text`
        );
        const url = new URL(paste);
        if (url.hostname !== `pouet.net` && url.hostname !== `www.pouet.net`)
          return;
        let paths = url.pathname.split(`/`);
        paths = paths.filter((path) => path);
        if (paths.length !== 1) return;
        if (paths[0] !== `prod.php`) return;
        const which = url.searchParams.get(`which`);
        if (which === null) return;
        p.addEventListener(
          `input`,
          () => {
            p.value = `${which}`;
          },
          { once: true }
        );
      });
    };
    // Input event listeners
    checks(`clear_on_upload`, autoclear);
    listen(`comment`, comment);
    listen(`credit_program`, code);
    listen(`credit_illustration`, gfx);
    listen(`credit_audio`, music);
    listen(`credit_text`, writer);
    listen(`web_id_demozoo`, d);
    listen(`section`, section);
    listen(`platform`, platform);
    listen(`web_id_pouet`, p);
    listen(`group_brand_by`, groupBy);
    listen(`record_title`, title);
    listen(`group_brand_for`, groupFor);
    listen(`date_issued_year`, year);
    listen(`date_issued_month`, month);
    listen(`date_issued_day`, day);
    listen(`web_id_youtube`, y);
    pasterDz();
    pasterP();
  };

  const initDropZone = () => {
    // Drag and drop files
    const zone = document.getElementById(`uploadController`);
    zone.addEventListener(`dragstart`, start, false);
    zone.addEventListener(`dragend`, end, false);
    zone.addEventListener(`dragenter`, enter, false);
    zone.addEventListener(`dragover`, over, false);
    zone.addEventListener(`drop`, drop, false);

    // Dragging a file into the browser from the operating system
    // will mean start() and end() functions are not fired.
    function start() {
      // do nothing
    }
    function end() {
      // do nothing
    }
    function enter(event) {
      event.stopPropagation();
      event.preventDefault();
    }
    function over(event) {
      event.stopPropagation();
      event.preventDefault();
    }
    function drop(event) {
      event.stopPropagation();
      event.preventDefault();
      const data = event.dataTransfer,
        files = data.files;
      document.getElementById(`select-files-js`).files = files;
      formReset(true);
      filesStore(files);
      chooseFiles();
    }
  };

  initButtons();
  initStorage();
  initDropZone();

  // Use localForage to save the file selections to IndexedDB
  function filesStore() {
    const files = document.getElementById(`select-files-js`);
    if (files === null) throw Error(`fileStore files cannot be null`);
    if (!files.length) return;
    localforage
      .setItem(`fileUploads`, files)
      .then(() => {
        console.log(`The saved the selection of uploads are stored`);
      })
      .catch((err) => {
        console.error(`store localforage`, err);
      });
  }

  function filesRestore() {
    localforage
      .getItem(`fileUploads`)
      .then((files) => {
        if (typeof files !== `object`) throw new Error(`are broken`);
        if (files === null) return;
        if (!files.length) throw new Error(`no stored files were saved`);
        document.getElementById(`select-files-js`).files = files;
        formReset(true);
        chooseFiles();
      })
      .catch((err) => {
        console.error(`restore localforage`, err);
      });
  }

  function filesClear() {
    localforage
      .removeItem(`fileUploads`)
      .then(() => {
        console.log(`Stored files have been cleared`);
      })
      .catch((err) => {
        console.warn(`Stored files could not be cleared,`, err);
      });
  }

  function clearForm(quiet = false) {
    console.log(`Reset the upload form`);
    clientListReset();
    formReset(quiet);
    storageItemsReset();
    filesClear();
  }

  function submitID() {
    console.log(`Submitting record`);
    postID(document.getElementById(`form1`));
  }

  function uploadFiles() {
    console.log(
      `Uploading ${transfer.count} file${transfer.count === 1 ? `` : `s`}`
    );
    startUpload(document.getElementById(`form1`));
  }

  function chooseFiles() {
    const hide = (id, elm = null) => {
      if (typeof id === `undefined`)
        throw Error(`choose files hide id argument is required`);
      if (elm === null) throw Error(`choose files hide elm is missing`);
      if (storage && elm.value !== ``)
        localStorage.setItem(`upload${id}id`, elm.value);
      elm.value = ``;
      elm.disabled = true;
      const span = document.getElementById(`check-${id}-span`);
      span.style.display = `none`;
    };
    const restore = (id, elm = null) => {
      if (typeof id === `undefined`)
        throw Error(`choose files restore id argument is required`);
      if (elm === null) throw Error(`choose files restore elm is missing`);
      if (storage) elm.value = localStorage.getItem(`upload${id}id`);
      elm.disabled = false;
      const span = document.getElementById(`check-${id}-span`);
      span.style.display = `inline`;
    };

    transfer.count = 0;
    transfer.bytes = 0;
    transfer.sum = 0;
    displayFiles();
    const d = document.getElementById(`newFile-web_id_demozoo`),
      p = document.getElementById(`newFile-web_id_pouet`),
      y = document.getElementById(`newFile-web_id_youtube`),
      singleFile = 1;
    if (transfer.count > singleFile) {
      // disable form inputs when multiple files are selected for upload
      if (d !== null) hide(`demozoo`, d);
      if (p !== null) hide(`pouet`, p);
      if (y !== null) hide(`youtube`, y);
      return console.log(`Selected ${transfer.count} files`);
    }
    // restore form inputs when only a single file is selected for upload
    if (d !== null) restore(`demozoo`, d);
    if (p !== null) restore(`pouet`, p);
    if (y !== null) restore(`youtube`, y);
    console.log(`Selected a file`);
  }

  /**
   * Swap between the Abort transfer and Clear form buttons.
   *
   * @param {string} [button=`clear`] Button name to swap to, either: `abort`, `clear`
   */
  function resetSwap(button = `clear`) {
    const abort = document.getElementById(`abort-button`).style,
      reset = document.getElementById(`reset-button`).style;
    switch (button) {
      case `abort`:
        abort.display = `inline`;
        reset.display = `none`;
        break;
      case `clear`:
        abort.display = `none`;
        reset.display = `inline`;
        break;
      default:
        throw Error(`invalid reset button choice '${button}'`);
    }
  }

  /**
   * Display status messages to the console log if verbose = `true`.
   *
   * @param {string} [message=``] Console message to display
   */
  function print(message = ``) {
    if (verbose !== true) return;
    if (message === ``) return;
    console.log(message);
  }

  /**
   * Display status updates to the client using the feedBack div tag.
   *
   * @param {string} [color=``] Bootstrap3 Alerts colour name
   * @param {string} [message=``] Console message to display
   */
  function alert(color = ``, message = ``) {
    switch (color.toLowerCase()) {
      case `success`:
      case `info`:
      case `warning`:
      case `danger`:
        // do nothing
        break;
      default:
        throw Error(`invalid Bootstrap 3 color choice: ${color}`);
    }
    const feedback = document.getElementById(`feedBack`);
    feedback.classList.remove(
      `hidden`,
      `alert-danger`,
      `alert-info`,
      `alert-success`,
      `alert-warning`
    );
    feedback.classList.add(`alert-${color}`);
    // hack to allow embedded HTML tags
    feedback.innerHTML = `${message}`;
  }

  /**
   * Reset the display of queued uploads
   *
   */
  function clientListReset() {
    document.getElementById(`status-of-uploads`).textContent = ``;
    document.getElementById(`list-of-uploads`).textContent = ``;
  }

  /**
   * Describe a XMLHttpRequest.readyState status code.
   * https://developer.mozilla.org/en-US/docs/Web/API/XMLHttpRequest/readyState
   *
   * @param {*} [rs=-1] readyState value, `0`,`1`,`2`,`3`,`4`
   * @returns
   */
  function describeReadyState(value = missing) {
    const descriptions = [
      `Request not initialized`,
      `Server connection established`,
      `Request received`,
      `Processing request`,
      `Request finished and response is ready`,
    ];
    const unset = 0,
      done = 4;
    if (value < unset && value > done) return `Unknown`;
    return descriptions[value];
  }

  /**
   * Converts a computer size measured as bytes into a readable format.
   *
   * @param {number} [size=0] bytes
   * @returns string Humanized size
   */
  function fileHumanizeSize(size = 0) {
    const three = 3,
      round = 100,
      kB = 1000,
      MB = Math.pow(kB, 2),
      GB = Math.pow(kB, three);
    if (size > GB)
      return `${(Math.round((size * round) / GB) / round).toFixed(2)} GB`;
    if (size > MB)
      return `${(Math.round((size * round) / MB) / round).toFixed(1)} MB`;
    if (size > kB)
      return `${(Math.round((size * round) / kB) / round).toFixed()} kB`;
    return `${Math.round(size).toFixed()} `;
  }

  /**
   * Attempt to find and extract an issue number from a file's name.
   * I.e filename=`example-magazine-issue-53.zip` would return `53`.
   * magazineIssue() should only run with the Magazines tab.
   *
   * @param {string} [filename=``] Name of the file
   * @returns An issue number or an empty string
   */
  function magazineIssue(filename = ``) {
    const type = document.getElementById(`newFile-uploadtype`);
    if (type === null)
      throw Error(`magazine issue could not get newFile-uploadtype element`);
    if (type.value !== `magazine`) return ``;

    const dropYear = (name = ``) => {
      // `file-01-2015-zip` will become `file-01-zip`
      const parts = name.split(`-`),
        yearLength = 4;
      if (parts.length < yearLength) return name;
      // file-01-[X]-zip
      const part = parts[2],
        test = parseInt(part),
        earliestYear = 1979;
      if (!isNaN(test) && test > earliestYear) {
        // assume 1980+ is a year and drop it from the name
        parts.splice(2, 1);
      }
      const newFilename = parts.toString();
      return newFilename.replace(/(_|\.|,)/g, `-`);
    };

    const issueValue = (name = ``) => {
      const parts = name.split(`-`),
        value = parts.slice(1, 2).toString();
      // returns either a digit or NaN
      return parseInt(value);
    };

    const file = filename.replace(/(_|\.|,)/g, `-`),
      newName = dropYear(file),
      issue = issueValue(newName);
    if (isNaN(issue)) return ``;
    return `${issue}`;
  }

  /**
   * Displays the files that have been queued for upload.
   *
   */
  function displayFiles() {
    const userSelection = document.getElementById(`select-files-js`);
    if (userSelection.value.length === 0) return;

    const errNoID = Error(`id argument cannot be empty`),
      errNoFile = Error(`file argument object cannot be empty`),
      errNoHTML = Error(`html argument element cannot be empty`);

    const elms = (id = ``) => {
      if (id === ``) throw errNoID;
      const html = {
        // table row to be applied to <tbody> block
        tr: document.createElement(`tr`),
        td: document.createElement(`td`),
        br: document.createElement(`br`),
        name: document.createElement(`code`),
        issue: document.createElement(`small`),
        mag: document.createElement(`em`),
        err: document.createElement(`span`),
      };
      html.tr.id = `${id}`;
      return html;
    };

    const magazine = (html, issue = ``) => {
      if (typeof html === `undefined`) throw errNoHTML;
      if (issue === ``) return;
      html.issue.textContent = `Issue `;
      html.mag.textContent = `${issue}`;
      html.issue.insertAdjacentElement(`beforeend`, html.mag);
      html.td.append(html.br, html.issue);
      return html;
    };

    const fileName = (html, id = ``, name = ``) => {
      if (typeof html === `undefined`) throw errNoHTML;
      if (id === ``) throw errNoID;
      html.td.textContent = `${count.toString()}. `;
      html.name.id = `${id}Name`;
      html.name.textContent = `${name}`;
      html.td.append(html.name);
      html.tr.append(html.td);
      return html;
    };

    const fileSize = (html, id = ``, bytes = 0) => {
      if (typeof html === `undefined`) throw errNoHTML;
      if (id === ``) throw errNoID;
      const size = {
        td: document.createElement(`td`),
        span: document.createElement(`span`),
      };
      size.span.id = `${id}Size`;
      size.span.textContent = `${fileHumanizeSize(bytes)}`;
      size.td.append(size.span);
      html.tr.append(size.td);
      return html;
    };

    const fileType = (html, id = ``, mimeType = ``) => {
      if (typeof html === `undefined`) throw errNoHTML;
      if (id === ``) throw errNoID;
      const type = {
        td: document.createElement(`td`),
        var: document.createElement(`var`),
        small: document.createElement(`small`),
      };
      type.small.textContent = `${mimeType}`;
      type.var.id = `${id}Type`;
      type.var.append(type.small);
      type.td.append(type.var);
      html.tr.append(type.td);
      return html;
    };

    const icon = (html, id = ``) => {
      if (typeof html === `undefined`) throw errNoHTML;
      if (id === ``) throw errNoID;
      const ico = document.createElement(`td`);
      const glyph = document.createElement(`span`);
      ico.id = `${id}BG`;
      glyph.id = `${id}Glyph`;
      glyph.classList.add(`fal`, `fa-upload`, `fa-fw`);
      ico.append(glyph);
      html.tr.append(ico);
      table.append(html.tr);
      return html;
    };

    const textPreview = (file, id = ``) => {
      if (typeof file === `undefined`) throw errNoFile;
      if (id === ``) throw errNoID;
      if (file.type !== `text/plain`) return;
      const text = {
        tr: document.createElement(`tr`),
        td: document.createElement(`td`),
        em: document.createElement(`em`),
      };
      text.em.id = `${id}Text`;
      text.td.style.borderTop = `none`;
      text.td.colSpan = `4`;
      text.td.append(text.em);
      text.tr.append(text.td);
      table.append(text.tr);
      textDisplay(file, text.em);
    };

    const textDisplay = (file, em = null) => {
      if (typeof file === `undefined`) throw errNoFile;
      // Loads a text file and partially displays it in an `em` element
      const reader = new FileReader();
      reader.onload = (element) => {
        const start = 0,
          end = 50,
          text = element.target.result.trim();
        em.textContent = text.substr(start, end);
      };
      reader.readAsText(file);
    };

    const photoPreview = (file) => {
      if (typeof file === `undefined`) throw errNoFile;
      const prev = {
        tr: document.createElement(`tr`),
        td: document.createElement(`td`),
        img: document.createElement(`img`),
        max: `15em`,
      };
      prev.img.classList.add(`obj`);
      prev.img.file = file;
      prev.img.style.margin = `0 auto`;
      prev.img.style.borderRadius = `1em`;
      prev.img.style.width = `auto`;
      prev.img.style.height = `auto`;
      prev.img.style.maxWidth = prev.max;
      prev.img.style.maxHeight = prev.max;
      prev.td.id = ``;
      prev.td.style.borderTop = `none`;
      prev.td.colSpan = `4`;
      prev.td.append(prev.img);
      prev.tr.append(prev.td);
      table.append(prev.tr);
      photoDisplay(file, prev.img);
    };

    const photoDisplay = (file, img = null) => {
      if (typeof file === `undefined`) throw errNoFile;
      // Loads a image from a form file object and displays it in an `img` element
      const reader = new FileReader();
      reader.onload = ((element) => {
        return (elm) => {
          element.src = elm.target.result;
        };
      })(img);
      reader.readAsDataURL(file);
    };

    const label = document.getElementById(`progressBarLabel`),
      files = userSelection.files,
      singleUpload = 1;
    // resets
    formProgressReset();
    clientListReset();
    label.textContent = `Transfer`;
    if (files.length > singleUpload) label.textContent = `Uploads transferred`;

    const update = (file) => {
      transfer.sum += file.size;
      transfer.count++;
      print(
        `Selection ${count}: transfer.count=${transfer.count} transfer.completed=${transfer.completed}`
      );
      // id syntax fileItem0, fileItem1, ...
      const id = `fileItem${count.toString()}`,
        magIssue = magazineIssue(file.name);
      let html = fileName(elms(id), id, file.name);
      if (magIssue.length) html = magazine(html, magIssue);
      html.err.id = `${id}Errors`;
      html.td.append(html.err);
      html = fileSize(html, id, file.size);
      // format meta-data
      let mimeType = `application/octet-stream`;
      if (file.type.length) mimeType = file.type;
      html = fileType(html, id, mimeType);
      html = icon(html, id);
      textPreview(file, id);
      if (!imageCheck.test(file.type)) return;
      photoPreview(file);
    };
    // loop through individual files contained in files selection
    const table = document.getElementById(`list-of-uploads`),
      imageCheck = /^image\//;
    let count = 0;
    for (const file of files) {
      count += 1;
      update(file);
      if (count > transfer.cap) break;
    }
    // get queued uploads list
    const tableBody = document.getElementById(`status-of-uploads`),
      fileLabel = document.getElementById(`file-label`).childNodes[1];
    // prefix file section count and total size to feedBack block
    const noun = `file${count === 1 ? `` : `s`}`,
      sum = `${fileHumanizeSize(transfer.sum)}`;
    tableBody.textContent = `${count} ${noun}, ${sum} in total`;
    // display a warning if too many files have been selected
    if (files.length > transfer.cap) {
      const tooMany = document.createElement(`div`);
      tooMany.textContent = `Too many files selected, there is a limit of ${
        transfer.cap + 1
      }`;
      tableBody.append(tooMany);
    }
    if (fileLabel !== null) {
      const original = fileLabel.textContent,
        threeSeconds = 3000;
      fileLabel.textContent = `${count} ${noun} at ${sum}`;
      window.setTimeout(() => {
        fileLabel.textContent = `${original}`;
      }, threeSeconds);
    }
    // enable feedBack block
    document.getElementById(`listupload-container`).classList.toggle(`hidden`);
  }

  /**
   * Demozoo, Pouët tab Submit ID button fetch.
   *
   */
  function postID() {
    const url = () => {
      if (location.pathname === URLRewrite)
        return `/index.cfm?controller=upload&action=submit-file`;
      return `submit-file`;
    };
    fetch(url(), {
      method: `POST`,
      body: formDataGenerator(),
    })
      .then((response) => {
        if (!response.ok) {
          alert(
            `warning`,
            `Submission failed due to the server side error ${response.status}`
          );
          print(
            `Submission failed as the server returned a ${response.status} response`
          );
          const error = `A network error occurred while submitting id`;
          throw new Error(
            `${error}: ${response.statusText} ${response.status}`
          );
        }
        return response.json();
      })
      .then((reply) => {
        if (reply.wasstored)
          return alert(`success`, `Thank you for the submission`);
        let errors = ``;
        for (const err in reply.errors) {
          if (err === `0`) {
            errors = reply.errors[err];
            continue;
          }
          errors += `, ${reply.errors[err]}`;
        }
        alert(`warning`, errors);
      });
  }

  /**
   * POST the selected files to the server using XMLHttpRequest() in asynchronous mode.
   *
   * @param {*} form Form element containing the file upload data
   */
  function startUpload(form) {
    // As of Jan 2021, the fetch API does not support `progress`
    // so XMLHttpRequest must be used to allow for transfer and speed updates.
    if (typeof form === `undefined`) throw Error(`startUpload form is missing`);
    if (formValidate(form) === false) return;

    const request = () => {
      // create a new XMLHttpRequest instance
      const http = new XMLHttpRequest();
      // create listeners for the XMLHttpRequest instance
      http.upload.addEventListener(`progress`, updateProgress, false);
      http.upload.addEventListener(`abort`, transferCancelled, false);
      http.upload.addEventListener(`error`, transferFailed, false);
      http.upload.addEventListener(`timeout`, transferFailed, false);
      http.upload.addEventListener(`loadend`, endProgress, false);
      // these events must NOT be attached to http.upload
      http.addEventListener(`load`, transferComplete, false);
      http.addEventListener(`readystatechange`, transferStateChange, false);
      return http;
    };

    const appendFile = (data, file) => {
      if (typeof data === `undefined`)
        throw Error(`startUpload appendFile data argument is missing`);
      if (typeof file === `undefined`)
        throw Error(`startUpload appendFile file argument is missing`);

      // append the `file` variable data to our new form variable data as fieldname file0
      data.set(`file0`, file);
      const title = data.get(`newFile[record_title]`);
      if (title !== null) return data;
      const type = data.get(`newFile[uploadtype]`);
      if (type !== `magazine`) return data;
      if (typeof file.name === `undefined`) return data;

      let issue = magazineIssue(file.name);
      if (issue.length === 0) issue = `left blank`;
      data.set(`newFile[record_title]`, issue);
      return data;
    };

    const open = (http, file, count = 0) => {
      if (typeof http === `undefined`)
        throw Error(`startUpload open http argument is missing`);
      if (typeof file === `undefined`)
        throw Error(`startUpload open file argument is missing`);
      // open a connection to the server controller Upload.submitFile()
      http.open(`POST`, `submit-file?format=json`, true);
      if (location.pathname === URLRewrite) {
        const url = `/index.cfm?controller=upload&action=submit-file&format=json`;
        // HTTP method, relative URL, use asynchronous connection?
        http.open(`POST`, url, true);
      }
      // pass additional data using http headers that will be parsed by the server
      http.setRequestHeader(`X-File-Count`, count);
      const date = new Date(file.lastModified);
      // needed format by the server
      // X-File-Last-Modified: Wed, 17 Aug 1994 06:36:58 GMT
      // Headers do not support Unicode characters with codepoints higher than 255
      // usAscii is a fix for Firefox 88+
      const usAscii = new RegExp(/[\u{0080}-\u{FFFF}]/gu);
      //const latin = new RegExp(/[^\u0000-\u00FF]/g);
      http.setRequestHeader(`X-File-Last-Modified`, date.toUTCString());
      http.setRequestHeader(`X-File-Name`, file.name.replace(usAscii, ``));
      http.setRequestHeader(`X-File-Size`, file.size);
      http.setRequestHeader(`X-File-Type`, file.type);
      return http;
    };

    let data = formDataGenerator();
    const files = document.getElementById(`select-files-js`).files;
    resetSwap(`abort`);
    formProgressReset();
    formLabel(0);
    // loop through fileInput.files data that has been saved to the `file` variable
    // note: files is an Object not an array so for-in and for-of loops do not work
    const update = (i) => {
      xhr[i] = request();
      data = appendFile(data, files[i]);
      xhr[i] = open(xhr[i], files[i], i);
      try {
        xhr[i].send(data);
      } catch (error) {
        alert(
          `danger`,
          `There is a browser problem and the upload could not begin<br>${error}`
        );
        formProgressReset();
        formLabel(0);
        resetSwap(`clear`);
        throw Error(`${error}`);
      }
    };
    for (let i = 0; i < files.length; i++) {
      update(i);
      if (i > transfer.cap) break;
    }
    filesClear();
  }

  /**
   * Progress transfers sent by the browser to the server.
   *
   * @param {*} event Upload event
   */
  function updateProgress(event) {
    if (typeof event === `undefined`)
      throw Error(`update progress event is missing`);
    if (!event.lengthComputable) return;
    const finished = 100;
    transfer.bytes = event.loaded;
    const percentage = ((transfer.bytes / transfer.sum) * finished).toFixed(0);
    if (percentage < finished) {
      // make sure combined HTTP Header and file content sizes
      // are not bigger than transfer.sum
      if (transfer.bytes > transfer.sum) transfer.bytes = transfer.sum;
      return formProgressUpdate(event.loaded, event.total);
    }
    const pleaseWait = `Please wait while the server processes the files`,
      feedback = document.getElementById(`feedBack`).innerHTML;
    if (feedback.indexOf(pleaseWait)) {
      // make sure combined HTTP Header and file content sizes are not bigger than transfer.sum
      if (transfer.bytes > transfer.sum) transfer.bytes = transfer.sum;
      formProgressUpdate(event.loaded, event.total);
      alert(`info`, pleaseWait);
    }
  }

  /**
   * Run after the file transfer has completed, regardless if successful or failed.
   *
   */
  function endProgress() {
    print(`Completed: ${transfer.completed} Count: ${transfer.count}`);
  }

  /**********************************
   * File transfer (upload) functions
   **********************************/

  /**
   * Intermediately stop all active transfers.
   *
   */
  function transferAbort() {
    const unsent = 0,
      done = 4,
      abort = -1;
    for (const request of xhr) {
      // cannot abort unsent or completed requests
      if ([unsent, done].indexOf(request.readyState) > abort) continue;
      request.abort();
    }
  }

  /**
   * Run after file transfer has been aborted.
   *
   */
  function transferCancelled() {
    resetSwap(`clear`);
    alert(`warning`, `The transfer was aborted by you`);
    formLabel(2);
  }

  /**
   * Run after file transfer is complete and the server has responded.
   *
   */
  function transferComplete(event) {
    if (typeof event === `undefined`)
      throw Error(`transfer complete event is missing`);
    const server = event.target;
    if (server.status !== okay) {
      transfer.error = true;
      print(
        `Server error, upload failed due to a server error ${server.status}`
      );
    }
    print(JSON.parse(server.response));
    if (transfer.completed < transfer.count) {
      // there are still active transfers
      return print(`Completed: ${transfer.completed} Count: ${transfer.count}`);
    }
    // all transfers are complete
    resetSwap(`clear`);
    if (transfer.error) {
      // there was an error with at least one of the transferred files
      formLabel(2);
      let feedback = ``;
      if (transfer.count === 1) feedback = `The upload was not successful`;
      else feedback = `Not all the uploads were successful`;
      feedback += `<br><small>See your Browser Console for the server response Errors</small>`;
      formProgressUpdate(0, 0);
      return alert(`danger`, feedback);
    }
    // all transfers were successful
    formLabel(1);
    const noun = `upload${transfer.count === 1 ? ` is` : `s are`}`,
      feedback = `Thank you, the ${noun} done`;
    alert(`success`, feedback);
    if (localStorage.getItem(`clear_on_upload`) === `true`) {
      clearForm(true);
      document.getElementById(`form1`).reset();
    }
  }

  /**
   * Run after the file transfer failed due to a connection,
   * client browser or client file system issue.
   *
   */
  function transferFailed() {
    formLabel(2);
    alert(`danger`, `Due to a network error the upload was not successful`);
  }

  /**
   *  Calculates and displays the active transfer speed.
   *
   * @param {number} [loaded=0] Current number of bytes that have been transferred so far
   * @returns HTML element
   */
  function transferSpeed(loaded = 0) {
    const bit = 0.125,
      second = 1000,
      split = new Date().getTime(),
      tc = (split - transfer.timer) / second,
      speed = Math.round(loaded / tc);
    return `${fileHumanizeSize(speed / bit)}it/s <small>(${fileHumanizeSize(
      speed
    )}/s)</small> `;
  }

  /**
   * Handles and runs when the transfer the status changes.
   *
   */
  function transferStateChange(event) {
    if (typeof event === `undefined`)
      throw Error(`transfer state change event is missing`);
    const serverError = 500,
      opened = 1,
      done = 4,
      reply = event.target;
    let message = ``;
    print(`onreadystatechange: ${describeReadyState(reply.readyState)}`);
    switch (reply.readyState) {
      case opened:
        // start millisecond tick count
        transfer.timer = new Date().getTime();
        return alert(`info`, `Please wait while the browser send the files`);
      case done:
        switch (reply.status) {
          case okay:
            return transferState200(reply.responseText);
          default:
            // Handle unexpected HTTP errors sent by the server
            transfer.error = true;
            formLabel(2);
            resetSwap(`clear`);
            switch (reply.status) {
              case serverError:
                message = `Something broke on the backend of website`;
                if (document.getElementById(`systemMenus`)) {
                  message = transferState500(reply.responseText, message);
                }
                break;
              default:
                message = `The server responded with the HTTP error`;
                message += ` <u>${reply.status} ${reply.statusText}</u>`;
                break;
            }
            formProgressUpdate(0, 0);
            return alert(`danger`, message);
        }
      default:
    }
  }

  /**
   * Handle server response code 200 (OK) and then gives feedback to the user.
   *
   * @param {string} [responseText=``] Response text returned by the server
   */
  function transferState200(responseText = ``) {
    const bg = document.getElementById(`BG`),
      glyph = document.getElementById(`Glyph`);
    let response = {};
    try {
      response = JSON.parse(responseText);
    } catch (err) {
      return print(`Server JSON parse error of ${responseText}`);
    }
    // User feedback
    if (response.wassaved === true && response.wasstored === true) {
      // Upload is saved
      if (bg !== null) bg.className = `success`;
      if (glyph !== null) glyph.className = `fa fa-check fa-fw`;
      return;
    }
    // Upload was not saved
    if (typeof response.errors === `undefined`) {
      transfer.error = true;
      return console.error(
        `The server response is missing some data, so this upload probably failed`
      );
    }
    // Get the first error and abort
    const [key, message] = Object.entries(response.errors)[0];
    if (message === `Thanks, but it seems this file is already on the site.`) {
      return console.info(
        `Upload ${response.item}: '${response.name}' ${message}`
      );
    }
    transfer.error = true;
    console.error(
      `Upload ${response.item}: '${response.name}' was not saved to the database`
    );
    return console.error(response.errors[key]);
  }

  /**
   * Handle 500 Internal Server errors.
   *
   * @param {string} [feedBack=``] HTML feedback
   * @returns HTML feedback to be displayed to the user
   */
  function transferState500(feedBack = ``, responseText = ``) {
    const error = JSON.parse(responseText);
    let html = `${feedBack}`;
    // error message
    if (typeof error.MESSAGE === `undefined`)
      html += `<br>missing error message`;
    else html += `<br><u>${error.MESSAGE}</u>`;
    // error trace
    if (typeof error.TRACE === `undefined`) html += `<br>missing trace message`;
    else {
      const start = error.TRACE.indexOf(`/controllers/Upload.cfc:`),
        end = error.TRACE.indexOf(`)`, start);
      // highlight the error location
      if (start && end) {
        html += `<br><code>${error.TRACE.substring(0, start)}`;
        html += `<mark>${error.TRACE.substring(start, end)}</mark>`;
        html += `${error.TRACE.substring(end)}</code>`;
      } else html += `<br><code>${error.TRACE}</code>`;
    }
    // error variables
    if (typeof error.VARIABLES.newFile === `undefined`)
      html += `<br>missing variables message`;
    else {
      html += `<p>Variables<p><br>`;
      for (const [key, value] of Object.entries(error.VARIABLES.newFile)) {
        html += `<code>${key}</code> "${value}"<br>`;
      }
    }
    return `${html}`;
  }

  /***********************
   * Upload form functions
   ***********************/

  /**
   * Initialise the form when the page first loads.
   *
   */
  function formInit() {
    const date = document.getElementById(`today-date-button`),
      submit = document.getElementById(`upload-files-submit`),
      upload = document.getElementById(`upload-files-button`),
      sel = document.getElementById(`select-files-js`);
    if (sel !== null) {
      sel.style.display = `initial`;
      sel.disabled = false;
      sel.required = true;
    }
    if (date !== null) date.disabled = false;
    if (submit !== null) {
      submit.style.display = `none`;
      submit.disabled = true;
    }
    if (upload !== null) {
      upload.style.display = `inline`;
      upload.disabled = false;
    }
    document.getElementById(`progress-container`).classList.remove(`hidden`);
    formLabel();
  }

  /**
   * Uses FormAPI to create a customize form that will be passed onto the server.
   *
   * @returns FormData object
   */
  function formDataGenerator() {
    const inputs = [
      `new-file-comment`,
      `newFile-record_title`,
      `newFile-platform`,
      `newFile-section`,
      `newFile-group_brand_for`,
      `newFile-group_brand_by`,
      `newFile-date_issued_year`,
      `newFile-date_issued_month`,
      `newFile-date_issued_day`,
      `newFile-credit_text`,
      `newFile-credit_program`,
      `newFile-credit_illustration`,
      `newFile-credit_audio`,
      `newFile-web_id_youtube`,
      `newFile-web_id_pouet`,
      `newFile-web_id_demozoo`,
      `newFile-list_links`,
      `newFile-uploadtype`,
    ];
    const radios = [`newFile[platform]`],
      formData = new FormData();
    // loop through the HTML form inputs and injects their values into the FormAPI form.
    const update = (id) => {
      const input = document.getElementById(id);
      if (input === null) return;
      const value = input.value;
      if (value.length) {
        // if value is not empty, append it to formData.
        if (id.indexOf(`-`))
          return formData.append(`${id.replace(`-`, `[`)}]`, value);
        // replace newFile-x with newFile[x]
        formData.append(`${id.replace(`newFile`, `newFile[`)}]`, value);
      }
    };
    for (const id of inputs) {
      update(id);
    }
    // loop through the HTML form radio inputers and inject their values into the FormAPI form.
    for (const name of radios) {
      const input = document.querySelector(`input[name="${name}"]:checked`);
      if (input === null) continue;
      const value = input.value;
      if (value.length) formData.append(name, value);
    }
    // tell the server to return the appropriate response
    formData.append(`operator[xhr2]`, true);
    // return form object
    return formData;
  }

  /**
   * Changes the icon used by the form `Transfer` label.
   *
   * @param {*} [state=-1]
   */
  function formLabel(state = missing) {
    const progressbar = document.getElementById(`progressBarLabel`),
      open = 0,
      done = 1,
      abort = 2;
    const label = () => {
      switch (state) {
        case open:
          return `<span class="fal fa-circle-notch fa-spin fa-fw"></span> Transfer `;
        case done:
          return `<span class="fal fa-check fa-fw"></span> Transferred `;
        case abort:
          return `<span class="fal fa-times fa-fw"></span> Transfer `;
        default:
          // idle status
          return `Transfer `;
      }
    };
    progressbar.innerHTML = label();
  }

  /**
   * Resets the form.
   *
   * @param {boolean} [quiet=false] Display a Form was reset message to the user?
   */
  function formReset(quiet = false) {
    const date = document.getElementById(`blank-date-button`),
      fileContainer = document.getElementById(`file-container`),
      publication = document.getElementById(`publication-container`),
      title = document.getElementById(`titleContainer`),
      note = document.getElementById(`note-container`),
      selects = document.getElementById(`select-files-js`),
      uploadList = document.getElementById(`listupload-container`),
      youtube = document.getElementById(`check-demozoo-span`),
      pouet = document.getElementById(`check-pouet-span`),
      demozoo = document.getElementById(`check-youtube-span`);
    formLabel();
    formProgressReset();
    document.getElementById(`file-label`).className = `col-sm-12`;
    resetSwap(`clear`);
    if (date !== null) date.disabled = true;
    // reset the feedback block
    if (!quiet) {
      alert(`warning`, `The form is reset`);
      const twoSeconds = 2000;
      window.setTimeout(() => {
        const feedback = document.getElementById(`feedBack`);
        feedback.classList.add(`hidden`);
        feedback.textContent = ``;
      }, twoSeconds);
    }
    if (fileContainer !== null) fileContainer.className = `navbar`;
    if (publication !== null) publication.className = `form-group`;
    if (title !== null) title.className = `form-group`;
    if (note !== null) note.className = `form-group`;
    if (selects !== null)
      selects.classList.replace(`btn-danger`, `btn-default`);
    if (uploadList !== null) uploadList.classList.add(`hidden`);
    if (youtube !== null) youtube.textContent = ``;
    if (pouet !== null) pouet.textContent = ``;
    if (demozoo !== null) demozoo.textContent = ``;
  }

  /**
   * Resets the progress form and transfer variables.
   *
   */
  function formProgressReset() {
    const reset = 0;
    transfer.completed = reset;
    transfer.error = false;
    formProgressUpdate(reset, reset);
  }

  /**
   * Updates the transfer progress bar.
   *
   * @param {number} [load=0] Bytes transferred so far
   * @param {number} [total=0] Total bytes to be transferred
   */
  function formProgressUpdate(load = 0, total = 0) {
    const done = 100,
      bar = document.getElementById(`progress-bar`),
      progress = document.getElementById(`progressPercentage`),
      speed = document.getElementById(`progressSpeed`);
    let percentage = 0;

    if (bar === null || progress === null || speed === null)
      throw Error(
        `cannot update transfer progress bar due to missing elements`
      );

    const reset = () => {
      formLabel();
      bar.value = `0`;
      progress.textContent = `0`;
      speed.textContent = ``;
    };

    const progressBar = () => {
      // process bar shows the current upload, rather than queued multiple uploads
      percentage = (load / total) * done;
      const l = fileHumanizeSize(load),
        t = fileHumanizeSize(total),
        s = transferSpeed(load);
      speed.innerHTML = `<small>${l} of ${t}</small> ${s}`;
    };

    if (total === 0) return reset();
    progressBar();
    if (total - load === 0) {
      transfer.completed++;
      if (transfer.count === 1) {
        speed.innerHTML = `<small>${fileHumanizeSize(
          total
        )}</small> ${transferSpeed(load)}`;
      }
    }
    if (transfer.count === transfer.completed) {
      bar.value = `100`;
      return (progress.textContent = `100`);
    }
    bar.value = percentage;
    progress.textContent = `${Math.round(percentage).toString()}`;
  }

  /**
   * Validate the form before its submission to the server.
   *
   * @returns boolean Is the form valid
   */
  function formValidate() {
    formReset(true);
    let errors = 0;
    // if no files are selected
    const select = document.getElementById(`select-files-js`);
    if (select !== null && select.value.length === 0) {
      errors++;
      const label = document.getElementById(`file-label`);
      if (label !== null) label.className += ` has-error`;
      select.classList.replace(`btn-default`, `btn-danger`);
    }
    const type = document.getElementById(`newFile-uploadtype`),
      summary = document.getElementById(`new-file-comment`),
      summaryGroup = document.getElementById(`note-container`),
      publisher = document.getElementById(`newFile-group_brand_for`),
      publisherGroup = document.getElementById(`publication-container`);
    // site tab vars
    const endIndex4 = -4,
      endIndex5 = -5;
    let end4 = ``,
      end5 = ``;
    // validate form depending on the tab selection
    let tab = ``;
    if (type !== null) tab = type.value;
    switch (tab) {
      case `note`:
        if (summary === null) break;
        if (summary.value.length) break;
        errors++;
        if (summaryGroup !== null)
          summaryGroup.className = `form-group has-error`;
        break;
      case `art`:
      case `document`:
      case `intro`:
      case `magazine`:
      case `other`:
        if (publisher === null) break;
        if (publisher.value.length) break;
        errors++;
        if (publisherGroup !== null)
          publisherGroup.className = `form-group has-error`;
        break;
      case `site`:
        if (publisher === null) break;
        if (publisher.value.length === 0) {
          errors++;
          if (publisherGroup !== null)
            publisherGroup.className = `form-group has-error`;
          break;
        }
        end4 = publisher.value.slice(endIndex4);
        end5 = publisher.value.slice(endIndex5);
        if (end4.toUpperCase() === ` BBS`) break;
        if (end4.toUpperCase() === ` FTP`) break;
        if (end5.toUpperCase() === ` BBS)`) break;
        if (end5.toUpperCase() === ` FTP)`) break;
        errors++;
        if (publisherGroup !== null)
          publisherGroup.className = `form-group has-error`;
        break;
      default:
    }
    // if any validation errors exist display the notifications in the feedBack block
    if (errors === 1) {
      alert(`danger`, `Please fix the marked issue`);
      return false;
    }
    if (errors) {
      alert(`danger`, `Please fix the ${errors} marked issues`);
      return false;
    }
    return true;
  }

  /**
   * Delete all stored local stored upload items.
   *
   */
  function storageItemsReset() {
    if (storage !== true) return;
    const keys = Object.keys(localStorage),
      upl = `upload`;
    for (const key of keys) {
      if (key.substr(0, upl.length) === upl) {
        localStorage.removeItem(`${key}`);
      }
    }
  }

  console.info(`Loaded upload toolkit ${version.get(`display`)} (upload.js)`);
})();
