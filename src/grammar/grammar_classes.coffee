class Relation
  constructor : (@name,@terms) ->
    @type = "Relation"
    console.log "#{@type} : constructed ... #{@name}"

module.exports = 
  Relation : Relation