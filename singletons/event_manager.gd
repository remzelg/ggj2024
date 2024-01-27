extends Node

var stored_changes = {}

func get_event_effects():
	return stored_changes

func store_event_effects(changes):
	stored_changes = {} # wipe previous data
	
	stored_changes = changes

