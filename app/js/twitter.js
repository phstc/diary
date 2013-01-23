// Generated by CoffeeScript 1.4.0
(function() {

  window.teste = function(tweets) {
    var buildEvent, hasHashTags, hash, hashtags, tags,
      _this = this;
    hash = {};
    buildEvent = function(text) {
      return {
        text: text
      };
    };
    hashtags = function(eventText) {
      return eventText.split(" ").filter(function(el) {
        return el[0] === "#";
      });
    };
    hasHashTags = function(tweet) {
      return hashtags(tweet).length > 0;
    };
    tweets.map(function(el) {
      var date, day, formattedDate, month;
      date = new Date(el.created_at);
      month = date.getMonth() + 1;
      day = date.getDate();
      formattedDate = date.getFullYear() + "-" + (month > 9 ? month : "0" + month) + "-" + (day > 9 ? day : "0" + day);
      if (hash[formattedDate]) {
        return hash[formattedDate].push(buildEvent(el.text));
      } else {
        return hash[formattedDate] = [buildEvent(el.text)];
      }
    });
    console.log(hash);
    tags = [];
    d3.map(hash).values().forEach(function(eventArray) {
      return eventArray.forEach(function(event) {
        if (hashtags(event.text).length > 0) {
          return tags.push(hashtags(event.text));
        }
      });
    });
    window.data = hash;
    window.tags = $.unique(tags.reduce(function(a, b) {
      return a.concat(b);
    }));
    window.tags.unshift("", "#", "@");
    window.calendar = new app.models.Calendar(hash);
    window.tags.forEach(function(el) {
      return $("body").append("<span onClick='window.calendar.update(\"" + el + "\");'>" + el + "</span>");
    });
    return $("span:nth(0)").html("Todos");
  };

  $(function() {
    return $.ajax({
      url: "https://api.twitter.com/1/statuses/user_timeline.json?include_entities=false&include_rts=true&screen_name="+window.username+"&count=200&trim_user=true&callback=window.teste",
      dataType: "jsonp",
      method: "get"
    });
  });

}).call(this);