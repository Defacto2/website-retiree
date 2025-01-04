/*
  Charts.
  path: javascript/src/operator-charts.js

  API and docs https://www.chartjs.org/docs/3.7.0/
  New chart colors can be generated using https://colorbrewer2.org/
*/
(() => {
  ("use strict");

  const monthlyCfg = {
    type: `line`,
    data: {
      datasets: [
        {
          label: `Monthly uploads`,
          backgroundColor: `rgb(255, 99, 132)`,
          borderColor: `rgb(255, 99, 132)`,
          data: chartJSMonths(`fspm`),
          fill: false,
          cubicInterpolationMode: `monotone`,
          tension: 0.4,
        },
      ],
    },
    options: {
      noramlized: true,
      interaction: {
        intersect: false,
        mode: `index`,
      },
      plugins: {
        title: {
          display: true,
          text: `Monthly file submissions`,
          font: {
            size: 16,
          },
        },
      },
    },
  };

  const yearlyCfg = {
    type: `line`,
    data: {
      datasets: [
        {
          label: `Annual uploads`,
          backgroundColor: `rgb(54, 162, 235)`,
          borderColor: `rgb(54, 162, 235)`,
          data: chartJSYears(`fspy`),
          fill: false,
          cubicInterpolationMode: `monotone`,
          tension: 0.4,
        },
      ],
    },
    options: {
      noramlized: true,
      interaction: {
        intersect: false,
        mode: `index`,
      },
      plugins: {
        title: {
          display: true,
          text: `Annual file submissions`,
          font: {
            size: 16,
          },
        },
      },
    },
  };

  const groupCol = chartDough(`group`);
  const groupCfg = {
    type: `doughnut`,
    data: {
      datasets: [
        {
          label: `Groups`,
          data: groupCol.data,
          backgroundColor: [
            `rgb(228,26,28)`,
            `rgb(55,126,184)`,
            `rgb(77,175,74)`,
            `rgb(152,78,163)`,
            `rgb(255,127,0)`,
            `rgb(255,255,51)`,
            `rgb(166,86,40)`,
            `rgb(247,129,191)`,
          ],
        },
      ],
      labels: groupCol.labels,
    },
    options: {
      responsive: true,
      plugins: {
        legend: {
          position: `top`,
        },
        title: {
          display: true,
          text: `8 groups with the most releases`,
          font: {
            size: 16,
          },
        },
      },
    },
  };

  const typeCol = chartDough(`platform`);
  const typeCfg = {
    type: `doughnut`,
    data: {
      datasets: [
        {
          label: `Types`,
          data: typeCol.data,
          backgroundColor: [
            `rgb(8,81,156)`,
            `rgb(49,130,189)`,
            `rgb(107,174,214)`,
            `rgb(158,202,225)`,
            `rgb(198,219,239)`,
            `rgb(239,243,255)`,
          ],
        },
      ],
      labels: typeCol.labels,
    },
    options: {
      responsive: true,
      plugins: {
        legend: {
          position: `top`,
        },
        title: {
          display: true,
          text: `Common platforms`,
          font: {
            size: 16,
          },
        },
      },
    },
  };

  const tagCol = chartDough(`section`);
  const tagCfg = {
    type: `doughnut`,
    data: {
      datasets: [
        {
          label: `Types`,
          data: tagCol.data,
          backgroundColor: [
            `rgb(0,90,50)`,
            `rgb(35,139,69)`,
            `rgb(65,171,93)`,
            `rgb(116,196,118)`,
            `rgb(161,217,155)`,
            `rgb(199,233,192)`,
            `rgb(237,248,233)`,
          ],
        },
      ],
      labels: tagCol.labels,
    },
    options: {
      responsive: true,
      plugins: {
        legend: {
          position: `top`,
        },
        title: {
          display: true,
          text: `Common tags`,
          font: {
            size: 16,
          },
        },
      },
    },
  };

  const mc = new Chart(document.getElementById(`monthlyChart`), monthlyCfg),
    yc = new Chart(document.getElementById(`yearlyChart`), yearlyCfg),
    gc = new Chart(document.getElementById(`groupChart`), groupCfg),
    tc = new Chart(document.getElementById(`typeChart`), typeCfg),
    tgc = new Chart(document.getElementById(`tagChart`), tagCfg);

  function chartJSMonths(name = ``) {
    const results = [],
      months = 12;
    for (let i = months; i > 0; i--) {
      const result = { x: ``, y: 0 };
      result.x = moment()
        .subtract(i - 1, `months`)
        .format(`MMMM`);
      result.y = parseInt(metaContent(`chart:${name}:${i}`), 10);
      results.push(result);
    }
    return results;
  }

  function chartJSYears(name = ``) {
    const results = [],
      years = 11;
    for (let i = years; i > 0; i--) {
      const result = { x: ``, y: 0 };
      result.x = moment()
        .subtract(i - 1, `years`)
        .format(`YYYY`);
      result.y = parseInt(
        metaContent(
          `chart:${name}:${moment()
            .subtract(i - 1, `years`)
            .format(`YYYY`)}`
        ),
        10
      );
      results.push(result);
    }
    return results;
  }

  /**
   * Creates an array of data used as values for a Chart.JS doughnut chart
   *
   * @param {string} [name=``] Name of the chart
   * @returns an array of chart values and labels
   */
  function chartDough(name = ``) {
    // number of chart slices to display
    const groups = 8,
      platforms = 6,
      sections = 7;
    const total = () => {
      switch (name) {
        case `group`:
          return groups;
        case `platform`:
          return platforms;
        case `section`:
          return sections;
        default:
          throw Error(`unknown chart pie name ${name}`);
      }
    };
    const results = { data: [], labels: [] };
    const update = (i) => {
      let dump;
      switch (name) {
        case `group`:
        case `platform`:
        case `section`:
          dump = metaContent(`chart:${name}:${i}`);
          results.data.push(parseInt(dump.split(`;`)[1], 10));
          results.labels.push(`${dump.split(`;`)[0]}`);
          break;
        default:
          return results;
      }
    };
    for (let i = 1; i <= total(); i++) {
      update(i);
    }
    return results;
  }
})();
