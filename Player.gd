class_name player extends Resource

@export var character : Character
@export var device_number : int
@export var stats : Resource
@export var jokes:Array

func get_all_jokes():
	return jokes + character.jokes
