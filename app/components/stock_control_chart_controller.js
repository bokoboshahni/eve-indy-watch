import { Controller } from "@hotwired/stimulus";

import * as d3 from 'd3'
import * as fc from 'd3fc'

export default class extends Controller {
  static targets = ["chart"];

  static values = { canvasId: String, url: String };

  connect() {
    this.load().then(data => this.render(data))
  }

  load() {
    return d3.json(this.urlValue);
  }

  render(json) {
    const parseDate = d3.timeParse("%Y-%m-%d");

    var data = json.map(d => ({
      date: parseDate(d.date),
      price: Number(d.price),
      volume: Number(d.volume)
    }))

    console.log(data)

    const xExtent = fc.extentDate()
      .accessors([d => d.date]);
    const yExtent = fc.extentLinear()
      .pad([0.1, 0.1])
      .accessors([d => d.price]);

    console.log(yExtent(data))

    const priceSeries = fc
      .seriesSvgLine()
      .mainValue(d => d.price)
      .crossValue(d => d.date)

    const priceAreaSeries = fc
      .seriesSvgArea()
      .baseValue(d => yExtent(data)[0])
      .mainValue(d => d.price)
      .crossValue(d => d.date)

    const priceGridlines = fc
      .annotationSvgGridline()
      .yTicks(5)
      .xTicks(0)

    const priceMovingAverage = fc
      .indicatorMovingAverage()
      .value(d => d.price)
      .period(7)

    const priceMovingAverageData = priceMovingAverage(data)
    data = data.map((d, i) => ({ ma: priceMovingAverageData[i], ...d }))

    const priceMovingAverageSeries = fc
      .seriesSvgLine()
      .mainValue(d => d.ma)
      .crossValue(d => d.date)
      .decorate(sel =>
        sel.enter()
          .classed("text-red", true)
      )

    const volumeExtent = fc
      .extentLinear()
      .include([0])
      .pad([0, 2])
      .accessors([d => d.volume]);
    const volumeDomain = volumeExtent(data);

    const volumeToPriceScale = d3
      .scaleLinear()
      .domain(volumeDomain)
      .range(yExtent(data));

    const volumeSeries = fc
      .seriesSvgBar()
      .bandwidth(2)
      .crossValue(d => d.date)
      .mainValue(d => volumeToPriceScale(d.volume))
      .decorate(sel =>
        sel
          .enter()
          .classed("volume", true)
          .attr("fill", d => (d.open > d.close ? "red" : "green"))
      );

    const multi = fc
      .seriesSvgMulti()
      .series([priceGridlines, priceAreaSeries, priceSeries, priceMovingAverageSeries, volumeSeries])

    const chart = fc
      .chartCartesian(d3.scaleTime(), d3.scaleLinear())
      .yOrient("right")
      .yDomain(yExtent(data))
      .xDomain(xExtent(data))
      .svgPlotArea(multi);

    d3.select(this.canvasIdValue).datum(data).call(chart);
  }
}
