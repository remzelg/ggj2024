class_name Joke
extends Resource

# options: `obs` `ro` `out` `
@export var category:String
# unique name
@export var id:String = ""
# display name
@export var name:String = ""
# wit compat
@export var wit:int = 0
# pride compat
@export var pride:int = 0
# observational compat
@export var obs:int = 0
# ???
@export var difficulty:int = 0
# filters
@export var tags:Array[String]

@export var target:String
# ???
@export_file var dialogue
