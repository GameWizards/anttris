
extends TextureFrame

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	get_node("StartButton").connect("pressed", self, "_start_pressed")
	pass

func _start_pressed():
	get_node("/root/global").goto_scene("res://puzzle.scn")
