# exit dialog
extends Node

var SceneLoader = preload( "res://scripts/SceneSwitcher.gd" )
var Dialog

func _on_ok_button_pressed():
	SceneLoader.goto_scene("res://menus.scn")

func show_dialog():
	print("Got ready call in exit script")
	Dialog = ConfirmationDialog.new()
	Dialog.set_title("Are you sure?")
	Dialog.set_text("Really quit? All unsaved progress will be lost!")
	Dialog.get_ok().connect("pressed", self, "_on_ok_button_pressed")
	print("showing dialog...")
	Dialog.popup_centered()
