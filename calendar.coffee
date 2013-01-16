window.app = {
  models: {}
}

class app.models.Calendar
  hashtag = /(#[a-zA-Z]*)/g

  width = 1240
  height = 660
  cellSize = 38

  colorScale = [
    "rgb(200,200,200)",
    "rgb(165,0,38)",
    "rgb(215,48,39)",
    "rgb(244,109,67)",
    "rgb(253,174,97)",
    "rgb(254,224,139)",
    "rgb(255,255,191)",
    "rgb(217,239,139)",
    "rgb(166,217,106)",
    "rgb(102,189,99)",
    "rgb(26,152,80)",
    "rgb(0,104,55)"
  ]

  getDay = d3.time.format("%d")
  getMonth = d3.time.format("%m")
  getMonthName = d3.time.format("%b")
  format = d3.time.format("%Y-%m-%d")

  pickColor = (index) ->
    return colorScale[index % colorScale.length]


  constructor: (@data) ->
    @prepareHTML()
    @drawMonthLabels()
    @drawDayLabels()
    @padCalendarData()
    @redraw()

  prepareHTML: ->
    @svg = d3.select("body").selectAll("svg")
      .data(d3.range(2012, 2013)) # FIXME: Should come from data
      .enter().append("svg")
      .attr("width", width)
      .attr("height", height)
      .append("g")

  drawMonthLabels: ->
    @svg.selectAll(".text")
      .data((year) -> return d3.time.months(new Date(year, 0, 1), new Date(year + 1, 0, 1)); )
      .enter().append("text")
      .attr("x", (date) -> return -23 + cellSize )
      .attr("y", (date) -> return 22 + getMonth(date) * cellSize )
      .attr("class", "month-name")
      .datum(getMonthName)
      .text((monthName) -> return monthName )

  drawDayLabels: ->
    @svg.selectAll(".text")
      .data((year) -> return d3.time.days(new Date(year, 0, 1), new Date(year + 1, 0, 1)) )
      .enter().append("text")
      .attr("x", (date) -> return 10 + getDay(date) * cellSize )
      .attr("y", (date) -> return 35 + getMonth(date) * cellSize )
      .attr("class", "month-name")
      .datum(getDay)
      .text((day) -> return day)

  padCalendarData: =>
    d3.time.days(new Date(2012, 0, 1), new Date(2013, 0, 1)).map (date) =>
        @data[format(date)] = null unless @data[format(date)]

  redraw: () =>
    @svg.selectAll(".day")
      .data((d) => return d3.keys(@data) )
      .enter().append("rect")
      .attr("height", cellSize)
      .attr("class", "day")
      .attr("fill", @chooseColor)
      .attr("x", (d) -> return parseInt(d.split("-")[2]) * cellSize )
      .attr("y", (d) -> return parseInt(d.split("-")[1]) * cellSize ) # FIXME: Octal
      .attr("width", cellSize)
      .transition()
      .duration(500)
      .attr("fill-opacity", 1)

  chooseColor: (d) =>
    if @data[d]
      colorIndex = d3.sum(@data[d], (d) -> d.quantity)
    else
      colorIndex = 0
    return pickColor(colorIndex)


$ ->

  sampleEventData = {
    title: "Test",
    created_at: new Date(),
    quantity: 1
  }

  sampleData = {
    "2012-01-01" : [sampleEventData],
    "2012-01-02" : [sampleEventData],
    "2012-01-03" : [sampleEventData, sampleEventData],
    "2012-01-04" : [sampleEventData],
    "2012-01-05" : [sampleEventData, sampleEventData, sampleEventData],
    "2012-01-06" : [sampleEventData, sampleEventData, sampleEventData, sampleEventData],
    "2012-03-03" : [sampleEventData],
    "2012-04-03" : [sampleEventData, sampleEventData, sampleEventData, sampleEventData, sampleEventData, sampleEventData],
    "2012-05-03" : [sampleEventData]
  }


  d3.select(self.frameElement).style("height", "910px")
