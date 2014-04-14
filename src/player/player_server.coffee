http = require('http')
express = require('express')
bodyParser = require('body-parser')

app = express()

app.use bodyParser()

app.use (req, res, next) ->
  console.log(req.body)
  next()

app.get '/',(req, res) ->
  res.send('<form method="post"><input type="submit" value="Submit"><input type="text" name="Something"/></form>')

app.post '/',(req, res) ->
  res.redirect '/'
  

app.listen(8000)