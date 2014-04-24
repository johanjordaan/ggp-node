_ = require('underscore')
grammar_classes = require('./grammar_classes.js')

class InfoCommand
  constructor : () ->
    @_type = "InfoCommand"

  execute : (player) ->
    info = player.info()
    return "((status #{info.status})(name #{info.name}))"

  toString : () ->
    return "(info)"
      
class StartCommand
  constructor : (@match_id,@player,@game_definition,@start_clock,@play_clock) ->
    @_type = "StartCommand"

  execute : (player) ->
    return player.start(@match_id,@player,@game_definition,@start_clock,@play_clock)  

  toString : () ->
    return "(start #{@match_id} #{@game_definition.as_str()} #{@start_clock} #{@play_clock})"

class PlayCommand
  constructor : (@match_id,@moves) ->
    @_type = "PlayCommand"

  execute : (player) ->
    return player.play(@match_id,@moves)  

  toString : () ->
    return "(play #{@match_id} #{@moves.as_str()})"


class StopCommand
  constructor : (@match_id,@moves) ->
    @_type = "PlayCommand"

  execute : (player) ->
    return player.stop(@match_id,@moves)  

  toString : () ->
    return "(stop #{@match_id} #{@moves.as_str()})"

class AbortCommand
  constructor : (@match_id) ->
    @_type = "AbortCommand"

  execute : (player) ->
    return player.abort(@match_id)  

  toString : () ->
    return "(abort #{@match_id})"

construct = (statement) ->
  if !statement._type?
    throw "Not a statement"

  if !statement._type instanceof grammar_classes.Relation
    throw "Not a relation.Commands need to be ralations"

  #n = 'x'
  #z =
  #  n : InfoCommand


  commands = {
    'info' : InfoCommand
    'start' : StartCommand
    'play' : PlayCommand
    'stop' : StopCommand
    'abort' : AbortCommand
  }

  cls =  commands[statement.name.name.toLowerCase()] 

  if cls?
    return new cls()
  else
    throw "Not a valid command"  



module.exports = 
  construct : construct
  #InfoCommand : InfoCommand
  #StartCommand : StartCommand
  #PlayCommand : PlayCommand
  #StopCommand : StopCommand


