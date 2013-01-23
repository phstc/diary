$ ->
  hash = {}

  buildEvent = (text) ->
    return {
      text: text
    }

  hashtags = (eventText) ->
    eventText.split(" ").filter (el) -> el[0] == "#"

  hasHashTags = (tweet) ->
    hashtags(tweet).length > 0

  tweets.map (el) =>
    date = new Date(el.created_at)
    month = date.getMonth() + 1
    day = date.getDate()
    formattedDate = date.getFullYear() + "-" + (if month > 9 then month else "0" + month) + "-" + (if day > 9 then day else "0" + day)
    if hash[formattedDate]
      hash[formattedDate].push buildEvent(el.text)
    else
      hash[formattedDate] = [buildEvent(el.text)]

  console.log(hash)

  tags = []
  d3.map(hash).values().forEach (eventArray) =>
    eventArray.forEach (event) =>
      tags.push hashtags(event.text) if hashtags(event.text).length > 0

  window.data = hash
  window.tags = $.unique(tags.reduce (a,b) -> a.concat(b))
  window.tags.unshift("", "#", "@")
  window.calendar = new app.models.Calendar(hash)

  window.tags.forEach (el) ->
    $("body").append("<span onClick='window.calendar.update(\""+el+"\");'>" + el + "</span>")

  $("span:nth(0)").html("Todos")
