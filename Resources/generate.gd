@tool
extends EditorScript

# For one-off initial generation of the LocationTres events 
# https://gamedev.stackexchange.com/questions/192488/is-there-a-way-to-run-a-tool-script-without-attaching-it-to-a-node-in-the-scene
# https://simondalvai.org/blog/godot-custom-resources/

const Bar = "Bar"
const Cafe = "Cafe"
const Library = "Library"
const Apartment = "Apartment"
const LionTag = "character:Lion"

# Called when the script is executed (using File -> Run in Script Editor).
func _run():
	var bar_root = _build_bar()
	var cafe_root = _build_cafe()
	var lib_root = _build_library()
	var apt_root = _build_apartment()
	# only save the roots, since it will serialize other nodes via Events
	ResourceSaver.save(bar_root, "res://Resources/LocationEvents/Bar.tres")
	ResourceSaver.save(cafe_root, "res://Resources/LocationEvents/Cafe.tres")
	ResourceSaver.save(apt_root, "res://Resources/LocationEvents/Apartment.tres")
	ResourceSaver.save(lib_root, "res://Resources/LocationEvents/Library.tres")

	var free_drink = _build_joke("obs", "free_drink", "free drink", 1, 5, 9, 5, [])
	var shushed = _build_joke("ro", "shushed", "shush!", 8, 1, 5, 5, [])
	
	ResourceSaver.save(free_drink, "res://Resources/Jokes/free_drink.tres")
	ResourceSaver.save(shushed, "res://Resources/Jokes/shushed.tres")

func _build_joke(category:String, id:String, name:String, wit:int, pride:int, obs:int, difficulty:int, tags:Array[String]):
	var candidate:Joke = Joke.new()
	candidate.category = category
	candidate.id = id
	candidate.name = name
	candidate.wit = wit
	candidate.pride = pride
	candidate.obs = obs
	candidate.difficulty = difficulty
	candidate.tags = tags

	return candidate


func _build_bar():
	var free_drink = _build_event(Bar, [], ["dialogue:free_drink"])
	var bar_bounce = _build_event(Bar, [], ["dialogue:bar_bounce"])
	var bar_lion = _build_event(Bar, [], [LionTag])
	var bar_root = _build_event(Bar, [bar_lion, free_drink], [])
	return bar_root

func _build_cafe():
	var cafe_root = _build_event(Cafe, [], [])
	return cafe_root

func _build_apartment():
	var apt_root = _build_event(Apartment, [], [])
	return apt_root

func _build_library():
	var quieted = _build_event(Library, [], ["dialogue:quieted"])
	var lib_root = _build_event(Library, [quieted], [])
	return lib_root

func _build_event(location_name:String, events:Array[LocationEvent], tags:Array[String]):
	var candidate:LocationEvent = LocationEvent.new()
	candidate.location_name = location_name
	candidate.events = events
	candidate.tags = tags
	# sanity check that relevant dialogue exists
	print("needs file: Resources/Dialogues/" + location_name + ".tres\n\tneeds: " + candidate.dialogue_title())
	return candidate