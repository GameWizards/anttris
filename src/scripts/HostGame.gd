
extends Button

# member variables here, example:

func _ready():
	connect("pressed", self, "pressed")
	connect("released", self, "released")
	
func pressed():
	var network = get_node("/root/Network")
	
	if !network.is_host and !network.is_network:
		print("calling!")
		network.host(network.port)
		get_tree().get_root().get_node("GUIManager/HostGame/Panel/Waiting").set_text("Waiting for player to join on port " + str(network.port) + "...")

func released():
	print("released!")