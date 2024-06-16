//
// Client side code used on Monitor.cshtml page
//

const DATA_INTERVAL = 3000;
var wsChart, cpuCHart;

// START HERE - Called on window load by Monitor.cshtml
function startMonitoring() {
  // Initialize working set chart
  wsChart = new Chart(document.getElementById("wsChart"), {
    type: "line",
    data: {
      labels: [],
      datasets: [
        {
          label: "Working Set (MBytes)",
          data: [],
          borderColor: "rgba(0, 156, 220, 1.0)",
          backgroundColor: "rgba(0, 156, 220, 0.4)",
          borderWidth: 3,
          lineTension: 0.3,
        },
      ],
    },
    options: {},
  });

  // Initialize CPU load chart
  cpuChart = new Chart(document.getElementById("cpuChart"), {
    type: "line",
    data: {
      labels: [],
      datasets: [
        {
          label: "Processor Load (%)",
          data: [],
          borderColor: "rgba(19, 185, 85, 1.0)",
          backgroundColor: "rgba(19, 185, 85, 0.4)",
          borderWidth: 3,
          lineTension: 0.3,
        },
      ],
    },
    options: {},
  });

  // Initial data load
  getData();

  // Then fetch data every 3 seconds
  setInterval(getData, DATA_INTERVAL);
}

//
// Helper to dynamically add data to a chart
//
function addData(chart, label, data) {
  chart.data.labels.push(label);
  chart.data.datasets.forEach((dataset) => {
    dataset.data.push(data);
  });

  // Limit the charts at 30 data points, otherwise it would just fill up
  if (chart.data.datasets[0].data.length > 30) {
    chart.data.datasets[0].data.shift();
    chart.data.labels.shift();
  }
  chart.update();
}

//
// Call API to get data
//
function getData() {
  fetch("/api/monitor")
    .then((response) => {
      // fetch handles errors strangely, we need to trap non-200 codes here
      if (!response.ok) {
        throw Error(response.statusText + " " + response.status);
      }
      return response.json();
    })
    .then((data) => {
      let d = new Date();

      // Add results to the two charts
      addData(
        wsChart,
        d.getHours() + ":" + d.getMinutes() + ":" + d.getSeconds(),
        data.workingSet / (1024 * 1024)
      );
      addData(
        cpuChart,
        d.getHours() + ":" + d.getMinutes() + ":" + d.getSeconds(),
        data.cpuPercentage
      );
    })
    .catch((err) => {
      console.log(err);
    });
}
