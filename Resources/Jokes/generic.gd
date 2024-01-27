extends Resource

class_name GenericJoke

@export var name:String = ""
@export var wit_compatability:int = 0
@export var pride_compatability:int = 0
@export var observation_compatability:int = 0
@export var difficulty:int = 0
@export var tags:Array[String]
@export var category:String
@export var display_name:String

@export_file var dialogue
