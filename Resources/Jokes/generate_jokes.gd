@tool
extends EditorScript

# For one-off initial generation of the LocationTres events 
# https://gamedev.stackexchange.com/questions/192488/is-there-a-way-to-run-a-tool-script-without-attaching-it-to-a-node-in-the-scene
# https://simondalvai.org/blog/godot-custom-resources/

# Called when the script is executed (using File -> Run in Script Editor).
func _run():
	var csv = preload("res://Resources/Jokes/jokes.csv").records
	
	for r in range(csv.size()):
		if r == 0: # skip headers
			continue
		var my_resource:GenericJoke = GenericJoke.new()
		
		var name = csv[r][0]
		my_resource.name = name
		my_resource.wit_compatability = int(csv[r][1])
		my_resource.pride_compatability = int(csv[r][2])
		my_resource.wit_compatability = int(csv[r][3])
		my_resource.difficulty = int(csv[r][4])
		# save it
		var path_to_save = "res://Resources/Jokes/" + name +".tres"
		ResourceSaver.save(my_resource, path_to_save)
