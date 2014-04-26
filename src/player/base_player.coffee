
class Player
  constructor : () ->
    @name = "node_base_player"
    @current_match_id = null
    @status = 'available'

  info : () ->
    return ret_val =
      name : @name
      status : @status

  start : (match_id,player,game_definition,start_clock,play_clock) ->
    if @status != 'available'
      return @status

    console.log '---->',game_definition.relation

    @current_match_id = match_id
    @status = 'busy'

    return 'Ready'

  play : (match_id,moves) ->
    return '(move 1 2)'

  stop : (match_id,moves) ->
    if match_id != @current_match_id
      return 'done'
    
    @current_match_id = null
    @status = 'available'
    return 'done'

  abort : (match_id) ->
    if match_id != @current_match_id
      return 'done'
    
    @current_match_id = null
    @status = 'available'
    return 'done'

module.exports = 
  Player : Player


