extends Node

var BLANK_CHANGES = { "wit": 0, "pride": 0, "obs": 0, "delivery": 50, "jokes": [] }
var stored_changes = BLANK_CHANGES


func get_event_effects():
	return stored_changes

func store_event_effects(wit=0, pride=0, obs=0, delivery=0, jokes=[]):
	# Override previous event changes
	stored_changes = { "wit": wit, "pride": pride, "obs": obs, "delivery": delivery, "jokes": jokes }
