@tool
extends EditorScript

# For one-off initial generation of the LocationTres events 
# https://gamedev.stackexchange.com/questions/192488/is-there-a-way-to-run-a-tool-script-without-attaching-it-to-a-node-in-the-scene
# https://simondalvai.org/blog/godot-custom-resources/

# Called when the script is executed (using File -> Run in Script Editor).
func _run():
	var my_resource:LocationEvent = LocationEvent.new()
	# assign values
	my_resource.name = "Hello Resources"
	my_resource.values = [0, 3, 12]

	# save it
	ResourceSaver.save(my_resource, "res://Resources/LocationEvents/my_resource.tres")

	# load it
	var my_resource_from_disk:LocationEvent = load("res://Resources/LocationEvents/my_resource.tres")

	# prints "Hello Resources"
	print(my_resource_from_disk.name)


	# prints "15"
	print(my_resource_from_disk.sum())

