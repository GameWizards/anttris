
extends Button

# member variables here, example:
const port=30041

func _ready():
	connect("pressed", self, "pressed")
	
func pressed():
	print("Listening on port " + str(port))
	get_node("/root/Network").host(port)

