<script>
  import { onMount } from "svelte";
  import * as d3 from "d3";

  onMount(() => {
    // Generate fake data for the month
    const fakeData = [
      { date: "2023-05-01", count: 0 },
      { date: "2023-05-02", count: 1 },
      { date: "2023-05-03", count: 1 },
      { date: "2023-05-04", count: 1 },
      { date: "2023-05-05", count: 0 },
      { date: "2023-05-06", count: 1 },
      { date: "2023-05-07", count: 1 },
      { date: "2023-05-08", count: 1 },
      { date: "2023-05-09", count: 0 },
      { date: "2023-05-10", count: 1 },
      { date: "2023-05-11", count: 1 },
      { date: "2023-05-12", count: 1 },
      { date: "2023-05-13", count: 0 },
      { date: "2023-05-14", count: 0 },
      { date: "2023-05-15", count: 1 },
      { date: "2023-05-16", count: 1 },
      { date: "2023-05-17", count: 0 },
      { date: "2023-05-18", count: 1 },
      { date: "2023-05-19", count: 1 },
      { date: "2023-05-20", count: 1 },
      { date: "2023-05-21", count: 0 },
      { date: "2023-05-22", count: 1 },
      { date: "2023-05-23", count: 1 },
      { date: "2023-05-24", count: 0 },
      { date: "2023-05-25", count: 1 },
      { date: "2023-05-26", count: 1 },
      { date: "2023-05-27", count: 1 },
      { date: "2023-05-28", count: 1 },
      { date: "2023-05-29", count: 1 },
      { date: "2023-05-30", count: 1 },
      { date: "2023-05-31", count: 1 }
    ];
    // Dimensions of the heatmap
    const width = 400;
    const height = 200;

    // Create the SVG element
    const svg = d3
      .select("#heatmap")
      .append("svg")
      .attr("width", width)
      .attr("height", height);

    // Define the color scale
    const colorScale = d3
      .scaleSequential(d3.interpolateYlOrRd)
      .domain([0, d3.max(fakeData, (d) => d.count)]);

    // Calculate the size of each cell
    const cellSize = Math.floor(width / 7);

    // Parse the dates
    const parseDate = d3.timeParse("%Y-%m-%d");
    const formatDate = d3.timeFormat("%d");

    // Generate the calendar heatmap
    svg
      .selectAll("rect")
      .data(fakeData)
      .enter()
      .append("rect")
      .attr("x", (d, i) => Math.floor(i % 7) * cellSize)
      .attr("y", (d, i) => Math.floor(i / 7) * cellSize)
      .attr("width", cellSize)
      .attr("height", cellSize)
      .style("fill", (d) => colorScale(d.count));

    // Add the day labels
    svg
      .selectAll(".day-label")
      .data(d3.range(7))
      .enter()
      .append("text")
      .attr("class", "day-label")
      .attr("x", (d, i) => i * cellSize + cellSize / 2)
      .attr("y", -5)
      .attr("text-anchor", "middle")
      .text((d) => ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"][d]);

    // Add the date labels
    svg
      .selectAll(".date-label")
      .data(fakeData)
      .enter()
      .append("text")
      .attr("class", "date-label")
      .attr("x", (d, i) => Math.floor(i % 7) * cellSize + cellSize / 2)
      .attr("y", (d, i) => Math.floor(i / 7) * cellSize + cellSize / 2)
      .attr("text-anchor", "middle")
      .attr("dy", ".35em")
      .text((d) => formatDate(parseDate(d.date)));
  });
</script>

<div id="heatmap" />

<style>
  rect {
    stroke: #fff;
  }
  .day-label {
    font-size: 12px;
    fill: #888;
  }

  .date-label {
    font-size: 14px;
    fill: #555;
  }
</style>
