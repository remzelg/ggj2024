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
	if events == []:
		return self
	for candidate in events:
		var tag_matches = 0
		var seeking = len(tags)
		for t in tags:
			for c in candidate.tags:
				if t == c:
					tag_matches += 1
					if tag_matches == seeking:
						return candidate.for_tags(tags)
	return self # TODO: fallback/default if no all matching tags found
	
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
