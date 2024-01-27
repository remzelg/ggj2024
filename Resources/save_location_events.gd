@tool
extends EditorScript

# For one-off initial generation of the LocationTres events 
# https://gamedev.stackexchange.com/questions/192488/is-there-a-way-to-run-a-tool-script-without-attaching-it-to-a-node-in-the-scene
# https://simondalvai.org/blog/godot-custom-resources/

const Bar = "Bar"
const LionTag = "character:Lion"

# Called when the script is executed (using File -> Run in Script Editor).
func _run():
	var bar_root = _build_bar()
	# only save the roots, since it will serialize other nodes via Events
	ResourceSaver.save(bar_root, "res://Resources/LocationEvents/Bar.tres")

	# load it
	var bar_from_disk:LocationEvent = load("res://Resources/LocationEvents/Bar.tres")
	print(bar_from_disk.tags)
	var n = bar_from_disk.for_tags([])
	print(n.tags)

func _build_bar():
	var bar_lion = _build_event(Bar, [], [LionTag])
	var bar_root = _build_event(Bar, [bar_lion], [])
	return bar_root

func _build_event(location_name:String, events:Array[LocationEvent], tags:Array[String]):
	var candidate:LocationEvent = LocationEvent.new()
	candidate.location_name = location_name
	candidate.events = events
	candidate.tags = tags
	# sanity check that relevant dialogue exists
	print("needs file: Resources/LocationsEvents/" + location_name + ".tres\n\tneeds: " + candidate.dialogue_title())
	return candidate
