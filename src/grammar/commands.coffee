_ = require('underscore')

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
  cmd_terms = statement.terms 

  commands = {
    'info' : () -> 
      new InfoCommand()
    'start' : () ->
      new StartCommand(cmd_terms[1],cmd_terms[2],cmd_terms[3],cmd_terms[4],cmd_terms[5])
    'play' : () ->
      new PlayCommand(cmd_terms[0],cmd_terms[1])
    'stop' : () ->
      new StopCommand(cmd_terms[0],cmd_terms[1])
    'abort' : () ->
      new AbortCommand(cmd_terms[0])

  }

  factory =  commands[cmd_terms[0].name.toLowerCase()] 

  if factory?
    return factory()
  else
    throw "Not a valid command"  



module.exports = 
  construct : construct



