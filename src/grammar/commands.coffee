_ = require('underscore')
grammar_classes = require('./grammar_classes.js')

class InfoCommand
  @command = 'info'

  constructor : () ->
    @_type = "InfoCommand"

  execute : (player) ->
    info = player.info()
    return "((status #{info.status})(name #{info.name}))"

  toString : () ->
    return "(info)"
      
class StartCommand
  constructor : (@match_id,@game_definition,@start_clock,@play_clock) ->
    @_type = "StartCommand"

  execute : (player) ->
    return player.start(@match_id,@game_definition,@start_clock,@play_clock)  

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

construct = (statement) ->
  if !statement._type?
    throw "Not a statement"

  if !statement._type instanceof grammar_classes.Relation
    throw "Not a relation.Commands need to be ralations"

  if statement.name.name.toLowerCase() == InfoCommand.command.toLowerCase()
    return new InfoCommand()




module.exports = 
  construct : construct
  #InfoCommand : InfoCommand
  #StartCommand : StartCommand
  #PlayCommand : PlayCommand
  #StopCommand : StopCommand


