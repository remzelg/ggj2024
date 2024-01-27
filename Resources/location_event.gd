class_name LocationEvent
extends Resource

signal such_signal

enum SuchEnum { Hello, Custom, Resources }

@export var name:String
@export var id:int = 0
@export var values:Array[int]
@export var enumValue:SuchEnum

func get_sum() -> int:
	var sum:int = 0
	for value in values:
		sum += value
	return sum
	
func special_effect() -> void:
	if randi() % 10 == 1:
		such_signal.emit()
