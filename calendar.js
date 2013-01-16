// Generated by CoffeeScript 1.4.0
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  window.app = {
    models: {}
  };

  app.models.Calendar = (function() {
    var cellSize, colorScale, day, format, hashtag, height, month, monthName, pickColor, width;

    hashtag = /(#[a-zA-Z]*)/g;

    width = 1240;

    height = 660;

    cellSize = 38;

    colorScale = ["rgb(200,200,200)", "rgb(165,0,38)", "rgb(215,48,39)", "rgb(244,109,67)", "rgb(253,174,97)", "rgb(254,224,139)", "rgb(255,255,191)", "rgb(217,239,139)", "rgb(166,217,106)", "rgb(102,189,99)", "rgb(26,152,80)", "rgb(0,104,55)"];

    day = d3.time.format("%d");

    month = d3.time.format("%m");

    monthName = d3.time.format("%b");

    format = d3.time.format("%Y-%m-%d");

    pickColor = function(d) {
      return colorScale[d];
    };

    function Calendar(data) {
      this.data = data;
      this.chooseColor = __bind(this.chooseColor, this);

      this.redraw = __bind(this.redraw, this);

      this.padCalendarData = __bind(this.padCalendarData, this);

      this.prepareHTML();
      this.drawMonthLabels();
      this.drawDayLabels();
      this.padCalendarData();
      this.redraw();
    }

    Calendar.prototype.prepareHTML = function() {
      return this.svg = d3.select("body").selectAll("svg").data(d3.range(2012, 2013)).enter().append("svg").attr("width", width).attr("height", height).append("g");
    };

    Calendar.prototype.drawMonthLabels = function() {
      return this.svg.selectAll(".text").data(function(d) {
        return d3.time.months(new Date(d, 0, 1), new Date(d + 1, 0, 1));
      }).enter().append("text").attr("x", function(d) {
        return -23 + day(d) * cellSize;
      }).attr("y", function(d) {
        return 22 + month(d) * cellSize;
      }).attr("class", "month-name").datum(monthName).text(function(d) {
        return d;
      });
    };

    Calendar.prototype.drawDayLabels = function() {
      return this.svg.selectAll(".text").data(function(d) {
        return d3.time.days(new Date(d, 0, 1), new Date(d + 1, 0, 1));
      }).enter().append("text").attr("x", function(d) {
        return 10 + day(d) * cellSize;
      }).attr("y", function(d) {
        return 35 + month(d) * cellSize;
      }).attr("class", "month-name").datum(day).text(function(d) {
        return d;
      });
    };

    Calendar.prototype.padCalendarData = function() {
      var _this = this;
      return d3.time.days(new Date(2012, 0, 1), new Date(2013, 0, 1)).map(function(el) {
        if (!_this.data[format(el)]) {
          return _this.data[format(el)] = null;
        }
      });
    };

    Calendar.prototype.redraw = function() {
      var _this = this;
      return this.svg.selectAll(".day").data(function(d) {
        return d3.keys(_this.data);
      }).enter().append("rect").attr("height", cellSize).attr("class", "day").attr("fill", this.chooseColor).attr("x", function(d) {
        return parseInt(d.split("-")[2]) * cellSize;
      }).attr("y", function(d) {
        return parseInt(d.split("-")[1]) * cellSize;
      }).attr("width", cellSize).transition().duration(500).attr("fill-opacity", 1);
    };

    Calendar.prototype.chooseColor = function(d) {
      var colorIndex;
      if (this.data[d]) {
        colorIndex = d3.sum(this.data[d], function(d) {
          return d.quantity;
        });
      } else {
        colorIndex = 0;
      }
      return pickColor(colorIndex);
    };

    return Calendar;

  })();

  $(function() {
    var sampleData, sampleEventData;
    sampleEventData = {
      title: "Test",
      created_at: new Date(),
      quantity: 1
    };
    sampleData = {
      "2012-01-01": [sampleEventData],
      "2012-01-02": [sampleEventData],
      "2012-01-03": [sampleEventData, sampleEventData],
      "2012-01-04": [sampleEventData],
      "2012-01-05": [sampleEventData, sampleEventData, sampleEventData],
      "2012-01-06": [sampleEventData, sampleEventData, sampleEventData, sampleEventData],
      "2012-03-03": [sampleEventData],
      "2012-04-03": [sampleEventData, sampleEventData, sampleEventData, sampleEventData, sampleEventData, sampleEventData],
      "2012-05-03": [sampleEventData]
    };
    return d3.select(self.frameElement).style("height", "910px");
  });

}).call(this);
