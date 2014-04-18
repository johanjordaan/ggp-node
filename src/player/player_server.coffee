http = require('http')
express = require('express')
bodyParser = require('body-parser')
gdlparser = require("../ast/gdl_parser.js")

app = express()

app.use (req, res, next) ->
  data = ''
  req.setEncoding 'utf8'
  req.on 'data', (chunk) -> 
    data += chunk
  req.on 'end', () ->
    req.raw_body = data
    next()

app.use bodyParser()

app.use (req, res, next) ->
  console.log(req.raw_body)
  next()

#app.get '/',(req, res) ->  
#
#  res.send('<form method="post"><input type="submit" value="Submit"><input type="text" name="Something"/></form>')

app.post '/',(req, res) ->
  p = gdlparser.parse(req.raw_body)
  
  if p.statements[0].name == 'info'
    res.send '((status available)(name nodeplayer))'
  if p.statements[0].name == 'start'
    res.send 'ready'  
  if p.statements[0].name == 'play'
    res.send 'noop'
  if p.statements[0].name == 'stop'
    res.send 'done'
  if p.statements[0].name == 'abort'
    res.send 'done'



  

app.listen(8000)