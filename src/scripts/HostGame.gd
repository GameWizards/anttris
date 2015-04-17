
extends Button

# member variables here, example:

func _ready():
	connect("pressed", self, "pressed")
	
func pressed():
	get_node("/root/Network").host(get_node("/root/Network").port)

