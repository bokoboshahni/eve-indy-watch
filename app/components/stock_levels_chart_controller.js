import { Controller } from "@hotwired/stimulus";

import * as d3 from 'd3'
import { scaleBand } from "d3";
import * as fc from 'd3fc'

export default class extends Controller {
  static targets = ["chart"];

  static values = {
    canvasId: String,
    url: String,
    minimumLevel: Number
  };

  connect() {
    this.load().then(data => this.render(data))
  }

  load() {
    return d3.json(this.urlValue);
  }

  render(json) {
    var data = json.map(d => ({
      time: d3.isoParse(d.time),
      quantity: Number(d.total_quantity),
    }))

    // console.log(data)

    const xExtent = fc.extentTime()
      .accessors([d => d.time]);
    const yExtent = fc.extentLinear()
      .pad([0, 0.3])
      .accessors([d => d.quantity])
      .include([0])

    // console.log(yExtent(data))

    const quantityColor = d3.scaleThreshold()
      .domain([this.minimumLevelValue])
      .range(["#7f1d1d", "#14532d"])

    // console.log(quantityColor(data[0]))

    const quantitySeries = fc
      .seriesSvgLine()
      .mainValue(d => d.quantity)
      .crossValue(d => d.time)
      .decorate(sel =>
        sel.enter()
          .attr("stroke-width", 1.5)
      )

    const minLevelBand = fc
      .annotationSvgBand()
      .fromValue(0)
      .toValue(this.minimumLevelValue)
      .decorate(sel =>
        sel.enter()
          .style('fill', '#fecaca')
      )

    const goodLevelBand = fc
      .annotationSvgBand()
      .fromValue(this.minimumLevelValue)
      .toValue(yExtent(data)[1])
      .decorate(sel =>
        sel.enter()
          .style('fill', '#bbf7d0')
      )

    const legend = () => {
      const labelJoin = fc.dataJoin("text", "legend-label");
      const valueJoin = fc.dataJoin("text", "legend-value");

      const instance = selection => {
        selection.each((data, selectionIndex, nodes) => {
          labelJoin(d3.select(nodes[selectionIndex]), data)
            .attr("transform", (_, i) => "translate(50, " + (i + 1) * 15 + ")")
            .text(d => d.name);

          valueJoin(d3.select(nodes[selectionIndex]), data)
            .attr("transform", (_, i) => "translate(60, " + (i + 1) * 15 + ")")
            .text(d => d.value);
        });
      };

      return instance;
    };

    const legendData = datum => [
      { name: "Total Qty", value: datum.total_quantity },
      { name: "Contract Qty", value: datum.contract_match_quantity },
      { name: "Market Qty", value: datum.market_quantity },
    ];

    const multi = fc
      .seriesSvgMulti()
      .series([minLevelBand, goodLevelBand, quantitySeries])

    const chart = fc
      .chartCartesian(d3.scaleTime(), d3.scaleLinear())
      .yOrient("right")
      .yDomain(yExtent(data))
      .xDomain(xExtent(data))
      .svgPlotArea(multi)
      .decorate(sel => {
        sel
          .datum(legendData(data[data.length - 1]))
          .append("svg")
          .style("grid-column", 3)
          .style("grid-row", 3)
          .classed("legend", true)
          .call(legend);
      });

    d3.select(this.canvasIdValue).datum(data).call(chart);
  }
}
