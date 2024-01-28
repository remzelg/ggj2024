class_name LocationEvent
extends Resource

@export var location_name:String
# Events are all the children nodes of the LocationEvent
@export var events:Array[LocationEvent]
# Tags are like `key:value`
# `character:Foo`
@export var tags:Array[String]
var tags_sorted = false

# returns the depth-first first found LocationEvent with no leaves that matches all tags
func for_tags(tags:Array[String]) -> LocationEvent:
	var matching = _for_tags(tags)
	return matching[randi() % matching.size()] # select one of the unfiltered mfs

func _for_tags(tags:Array[String]) -> Array[LocationEvent]:
	var matching:Array[LocationEvent] = []
	if events == []:
		var res:Array[LocationEvent] = [self]
		return res
	for candidate in events:
		for t in tags:
			for c in candidate.tags:
				if t == c:
					matching.append(candidate)
					matching.append(candidate.for_tags(tags))
	return matching
		

func dialogue_target():
	return load("res://Resources/Dialogues/" + location_name + ".dialogue")

# e.g. `Bar__character_lion__target_possum`
# TODO: return a random option
func dialogue_title():
	var title = location_name
	if !tags_sorted:
		tags.sort()
		tags_sorted = true
	for tag in tags:
		title += "__" + tag.replace(":", "_")
	return title
