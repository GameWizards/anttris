extends Node2D

func _ready():
	#get an instance of gut
	var tester = load('res://scripts/gut.gd').new()
	#Move it down some so you can see the dialog box bar at top
	print("wuuuut")
	add_child(tester)

	#stop it from printing to console, just because
	tester.set_should_print_to_console(true)


	tester.add_script('res://scripts/sample_tests.gd')

	tester.test_scripts()
