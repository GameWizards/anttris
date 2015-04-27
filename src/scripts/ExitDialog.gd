# exit dialog
extends Node

var SceneLoader = preload( "res://scripts/SceneSwitcher.gd" )
var Dialog

func _on_ok_button_pressed():
	goto_scene("res://menus.scn")



func _ready():
	print("Got ready call in exit script")
	Dialog = ConfirmationDialog.new()
	#Dialog.set_script(self)
	Dialog.set_text("Really quit? All unsaved progress will be lost!")
	Dialog.get_ok().connect("pressed", self, "_on_ok_button_pressed")
	print("showing dialog...")
	Dialog.show()
