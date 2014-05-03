#http = require('http')
express = require('express')
#bodyParser = require('body-parser')

parser = require('../grammar/parser')
commands = require('../grammar/commands')

app = express()

app.use (req, res, next) ->
  data = ''
  req.setEncoding 'utf8'
  req.on 'data', (chunk) -> 
    data += chunk
  req.on 'end', () ->
    req.raw_body = data
    next()

#app.use bodyParser()

#app.get '/',(req, res) ->  
#
#  res.send('<form method="post"><input type="submit" value="Submit"><input type="text" name="Something"/></form>')

Player = require('../player/base_player').Player

player = new Player()

app.post '/',(req, res) ->
  console.log req.raw_body
  context = parser.parse(req.raw_body)
  cmd = commands.construct(context.relations[context.relations.length-1])
  ret_val = cmd.execute player
  res.send ret_val

app.listen(8000)