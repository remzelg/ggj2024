extends Button

var joke

func _ready():
	pass

func init(joke: Resource):
	self.joke = joke
	text = joke.name
