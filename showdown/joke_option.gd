extends Button

var joke

func _ready():
	pass

func init(new_joke: Resource):
	joke = new_joke
	text = joke.name
