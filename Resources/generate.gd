@tool
extends EditorScript

# For one-off initial generation of the LocationTres events 
# https://gamedev.stackexchange.com/questions/192488/is-there-a-way-to-run-a-tool-script-without-attaching-it-to-a-node-in-the-scene
# https://simondalvai.org/blog/godot-custom-resources/

const Bar = "Bar"
const BarTag:Array[String] = ["location:Bar"]
const Cafe = "Cafe"
const CafeTag:Array[String] = ["location:Cafe"]
const Library = "Library"
const LibraryTag:Array[String] = ["location:Library"]
const Apartment = "Apartment"
const ApartmentTag:Array[String] = ["location:Apartment"]


const base_character_tags:Array[String] = LionTag + PossumTag + BirdTag + DolphinTag
const LionTag:Array[String] = ["character:Lion"]
const PossumTag:Array[String] = ["character:Possum"]
const BirdTag:Array[String] = ["character:Bird"]
const DolphinTag:Array[String] = ["character:Dolphin"]

# Called when the script is executed (using File -> Run in Script Editor).
func _run():
	print("\n\n\n\n")
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

var base_bar_tags:Array[String] = BarTag + base_character_tags
var free_drink_tag:Array[String] = ["dialogue:free_drink"]
var bar_bounce_tag:Array[String] = ["dialogue:bar_bounce"]
func _build_bar():
	var free_drink = _build_event(Bar, [], base_bar_tags + free_drink_tag)
	var bar_bounce = _build_event(Bar, [], base_bar_tags + bar_bounce_tag)
	var bar = _build_event(Bar, [], base_bar_tags)
	var bar_root = _build_event(Bar, [bar, free_drink, bar_bounce], base_bar_tags)
	return bar_root

var cafe_base_tags:Array[String] = CafeTag + base_character_tags
func _build_cafe():
	var cafe = _build_event(Cafe, [], cafe_base_tags)
	var cafe_root = _build_event(Cafe, [cafe], cafe_base_tags)
	return cafe_root

var apartment_base_tags:Array[String] = ApartmentTag + base_character_tags
func _build_apartment():
	var apt = _build_event(Apartment, [], apartment_base_tags)
	var apt_root = _build_event(Apartment, [apt], apartment_base_tags)
	return apt_root

var library_base_tags:Array[String] = LibraryTag + base_character_tags
var quieted_tag:Array[String] = ["dialogue:quieted"]
func _build_library():
	var quieted = _build_event(Library, [], library_base_tags + quieted_tag)
	var lib = _build_event(Library, [], library_base_tags)
	var lib_root = _build_event(Library, [lib, quieted], library_base_tags)
	return lib_root

func _build_event(location_name:String, events:Array[LocationEvent], tags:Array[String]):
	var candidate:LocationEvent = LocationEvent.new()
	candidate.location_name = location_name
	candidate.events = events
	candidate.tags = tags
	# sanity check that relevant dialogue exists
	print("needs file: Resources/Dialogues/" + location_name + ".tres\n\tneeds: " + candidate.dialogue_title())
	return candidate
