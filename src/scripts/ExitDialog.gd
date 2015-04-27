# exit dialog
extends Node

var SceneLoader = preload( "res://scripts/SceneSwitcher.gd" )
var Dialog = ConfirmationDialog.new()

func _on_ok_button_pressed():
	goto_scene("res://menus.scn")

func _ready():
	Dialog.set_script(self)
	Dialog.set_text("Really quit? All unsaved progress will be lost!")
	Dialog.get_ok().connect("pressed", self, "_on_ok_button_pressed")