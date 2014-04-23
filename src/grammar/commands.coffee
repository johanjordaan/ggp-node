_ = require("underscore")

class InfoCommand
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

module.exports = 
  InfoCommand : InfoCommand
  StartCommand : StartCommand
  PlayCommand : PlayCommand