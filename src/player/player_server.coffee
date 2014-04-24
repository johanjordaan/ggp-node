#http = require('http')
express = require('express')
#bodyParser = require('body-parser')
parser = require('../grammar/grammar_parser').parser
parser.yy = require('../grammar/grammar_classes')
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

#app.use (req, res, next) ->
#  console.log(req.raw_body)
#  next()

#app.get '/',(req, res) ->  
#
#  res.send('<form method="post"><input type="submit" value="Submit"><input type="text" name="Something"/></form>')

Player = require('../player/base_player').Player

player = new Player()

app.post '/',(req, res) ->
  console.log req.raw_body
  parser.parse(req.raw_body)
  cmd = commands.construct(parser.yy.program[0])
  ret_val = cmd.execute player

  console.log ret_val

  res.send ret_val

app.listen(8000)