
extends Button

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	connect("pressed", self, "pressed")

func pressed():
	var field = get_tree().get_root().get_node("GUIManager/OptionsMenu/Panel/PortField/LineEdit")
	get_node("/root/Network").set_port(field.get_text())