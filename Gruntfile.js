module.exports = function (grunt) {
  // Project configuration.
  grunt.initConfig({
    pkg: grunt.file.readJSON(`package.json`),
    // JS 2015 minify (JavaScript compression)
    terser: {
      options: {
        compress: true,
        mangle: false,
      },
      apisExternal: {
        src: `ROOT/javascripts/src/apis-external.js`,
        dest: `ROOT/javascripts/apis-external.min.js`,
      },
      chiptuneui: {
        src: `ROOT/javascripts/src/chiptune-ui.js`,
        dest: `ROOT/javascripts/chiptune-ui.min.js`,
      },
      chiptune: {
        src: `lib/static/chiptune2.js`,
        dest: `ROOT/javascripts/chiptune2.min.js`,
      },
      footer: {
        src: `ROOT/javascripts/src/footer.js`,
        dest: `ROOT/javascripts/footer.min.js`,
      },
      functions: {
        src: `ROOT/javascripts/src/functions.js`,
        dest: `ROOT/javascripts/functions.min.js`,
      },
      infiniteScroll: {
        src: `ROOT/javascripts/src/infinite-scroll.js`,
        dest: `ROOT/javascripts/infinite-scroll.min.js`,
      },
      inputExternal: {
        src: `ROOT/javascripts/src/upload-input-production-id.js`,
        dest: `ROOT/javascripts/upload-input-production-id.min.js`,
      },
      inputReferences: {
        src: `ROOT/javascripts/src/upload-input-references.js`,
        dest: `ROOT/javascripts/upload-input-references.min.js`,
      },
      inputReferences: {
        src: `ROOT/javascripts/src/upload-input-references.js`,
        dest: `ROOT/javascripts/upload-input-references.min.js`,
      },
      operatorCharts: {
        src: `ROOT/javascripts/src/operator-charts.js`,
        dest: `ROOT/javascripts/operator-charts.min.js`,
      },
      operatorDialog: {
        src: `ROOT/javascripts/src/operator-dialog.js`,
        dest: `ROOT/javascripts/operator-dialog.min.js`,
      },
      operator: {
        src: `ROOT/javascripts/src/operator.js`,
        dest: `ROOT/javascripts/operator.min.js`,
      },
      retrotxtAdvert: {
        src: `ROOT/javascripts/src/retrotxt-advert.js`,
        dest: `ROOT/javascripts/retrotxt-advert.min.js`,
      },
      retrotxtcf: {
        src: `ROOT/javascripts/src/retrotxtcf.js`,
        dest: `ROOT/javascripts/retrotxtcf.min.js`,
      },
      retrotxtcolor: {
        src: `ROOT/javascripts/src/retrotxt-color.js`,
        dest: `ROOT/javascripts/retrotxt-color.min.js`,
      },
      upload: {
        src: `ROOT/javascripts/src/upload.js`,
        dest: `ROOT/javascripts/upload.min.js`,
      },
      uploadInputs: {
        src: `ROOT/javascripts/src/upload-inputs.js`,
        dest: `ROOT/javascripts/upload-inputs.min.js`,
      },
      doseeFunctions: {
        src: `ROOT/javascripts/src/dosee/dosee-functions.js`,
        dest: `ROOT/javascripts/dosee-functions.min.js`,
      },
      doseeInit: {
        src: `ROOT/javascripts/src/dosee/dosee-init.js`,
        dest: `ROOT/javascripts/dosee-init.min.js`,
      },
      doseeLoader: {
        src: `ROOT/javascripts/src/dosee/dosee-loader.js`,
        dest: `ROOT/javascripts/dosee-loader.min.js`,
      },
      canvasToBlob: {
        src: `lib/static/canvas-toBlob.js`,
        dest: `ROOT/javascripts/canvas-toBlob.min.js`,
      },
      liteYT: {
        src: `lib/frontend/lite-yt-embed.js`,
        dest: `lib/frontend/lite-yt-embed.min.js`,
      },
    },
    // Less language extension for CSS converter
    less: {
      build: {
        files: {
          "ROOT/stylesheets/layout.css": "ROOT/stylesheets/src/layout.less",
        },
      },
    },
    // CSS minify (compression)
    cssmin: {
      build: {
        files: {
          "ROOT/stylesheets/layout.min.css": ["ROOT/stylesheets/layout.css"],
          "ROOT/stylesheets/layout-error.min.css": [
            "ROOT/stylesheets/src/layout-error.css",
          ],
          "ROOT/stylesheets/hamburgers.min.css": ["lib/static/hamburgers.css"],
          "ROOT/stylesheets/dosee.min.css": ["ROOT/stylesheets/src/dosee.css"],
          "lib/frontend/lite-yt-embed.min.css": [
            "lib/frontend/lite-yt-embed.css",
          ],
        },
      },
    },
    // Delete files
    clean: {
      css: ["ROOT/stylesheets/layout.css"],
    },
    // Duplicate files
    copy: {
      bootstrap: {
        files: {
          "lib/bootstrap/bootstrap.min.css": [
            "node_modules/bootstrap/dist/css/bootstrap.min.css",
          ],
          "lib/bootstrap/bootstrap.min.css.map": [
            "node_modules/bootstrap/dist/css/bootstrap.min.css.map",
          ],
          "lib/bootstrap/bootstrap.min.js": [
            "node_modules/bootstrap/dist/js/bootstrap.min.js",
          ],
          "lib/bootstrap/jquery.slim.min.js": [
            "node_modules/jquery/dist/jquery.slim.min.js",
          ],
        },
      },
      choices: {
        files: {
          "lib/choices/choices.min.js": [
            "node_modules/choices.js/public/assets/scripts/choices.min.js",
          ],
          "lib/choices/base.min.css": [
            "node_modules/choices.js/public/assets/styles/choices.min.css",
          ],
          "lib/choices/choices.min.css": [
            "node_modules/choices.js/public/assets/styles/choices.min.css",
          ],
        },
      },
      upload: {
        files: {
          "lib/upload/localforage.min.js": [
            "node_modules/localforage/dist/localforage.nopromises.min.js",
          ],
        },
      },
      dosee: {
        files: {
          "lib/dosee/browserfs.min.js": [
            "node_modules/browserfs/dist/browserfs.min.js",
          ],
          "lib/dosee/browserfs-zipfs-extras.js": [
            "node_modules/browserfs-zipfs-extras/dist/browserfs-zipfs-extras.js", // TODO: minify
          ],
          "lib/dosee/clipboard.min.js": [
            "node_modules/clipboard/dist/clipboard.min.js",
          ],
          "lib/dosee/es6-promise.min.js": [
            "node_modules/es6-promise/dist/es6-promise.min.js",
          ],
          "lib/dosee/FileSaver.min.js": [
            "node_modules/file-saver-fixed/dist/FileSaver.min.js",
          ],
        },
      },
      frontend: {
        files: {
          "lib/frontend/infinite-scroll.pkgd.min.js": [
            "node_modules/infinite-scroll/dist/infinite-scroll.pkgd.min.js",
          ],
          "lib/frontend/moment.min.js": [
            "node_modules/moment/min/moment.min.js",
          ],
          "lib/frontend/headroom.min.js": [
            "node_modules/headroom.js/dist/headroom.min.js",
          ],
          "lib/frontend/lite-yt-embed.min.css": [
            "node_modules/lite-youtube-embed/src/lite-yt-embed.min.css",
          ],
          "lib/frontend/lite-yt-embed.min.js": [
            "node_modules/lite-youtube-embed/src/lite-yt-embed.min.js",
          ],
          "lib/frontend/chart.min.js": [
            "node_modules/chart.js/dist/chart.min.js",
          ],
        },
      },
    },
  });

  // Load all grunt tasks matching the ['grunt-*', '@*/grunt-*'] patterns
  require(`load-grunt-tasks`)(grunt, { scope: `devDependencies` });

  // Default tasks, compile CSS and minify JS.
  grunt.registerTask(`default`, [`css`, `js`]); // , `cacheKiller`

  // Compile LESS to CSS, minify and remove formatted CSS
  grunt.registerTask(`css`, [`less`, `cssmin`, `clean`]);

  // Minify JS
  grunt.registerTask(`js`, [`terser`]);

  // Update dependencies
  grunt.registerTask(`update`, [`copy`]);
};
