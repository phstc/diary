$ ->
  hash = {}

  buildEvent = (text) ->
    return {
      title: text,
      quantity: 1
    }

  tweets.map (el) ->
    date = new Date(el.created_at)
    month = date.getMonth() + 1
    day = date.getDate()
    formattedDate = date.getFullYear() + "-" + (if month > 9 then month else "0" + month) + "-" + (if day > 9 then day else "0" + day)
    if hash[formattedDate] 
      hash[formattedDate].push buildEvent(el.text)
    else
      hash[formattedDate] = [buildEvent(el.text)]

  console.log(hash)
  new app.models.Calendar(hash)
