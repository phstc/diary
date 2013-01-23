class app.models.Twitter

  constructor: (@data = {}) ->

  hashtags = (eventText) ->
    eventText.split(" ").filter (el) -> el[0] == "#"

  callback: (@tweets) =>

    @tweets.map (el) =>
      date = new Date(el.created_at)
      month = date.getMonth() + 1
      day = date.getDate()

      formattedDate = date.getFullYear() + "-" + (if month > 9 then month else "0" + month) + "-" + (if day > 9 then day else "0" + day)

      if @data[formattedDate]
        @data[formattedDate].push { text: el.text }
      else
        @data[formattedDate] = [{ text: el.text }]

    tags = []
    d3.map(@data).values().forEach (eventArray) =>
      eventArray.forEach (event) =>
        tags.push hashtags(event.text) if hashtags(event.text).length > 0

    window.tags = if tags.length > 0 then $.unique(tags.reduce (a,b) -> a.concat(b)) else tags
    window.tags.unshift("problema", "manutenção", "volta", "correios") if window.username == "elo7status" # demo purpose
    window.tags.unshift("", "#", "@")
    window.calendar = new app.models.Calendar(@data)

    window.tags.forEach (el) ->
      $("body").append("<span onClick='window.calendar.update(\""+el+"\");'>" + el + "</span>")

    $("span:nth(0)").html("Todos")

$ ->
  window.twitter = new app.models.Twitter()

  $.ajax({ url: "https://api.twitter.com/1/statuses/user_timeline.json?include_entities=false&include_rts=true&screen_name="+window.username+"&count=200&trim_user=true&callback=window.twitter.callback", dataType: "jsonp", method: "get" })
