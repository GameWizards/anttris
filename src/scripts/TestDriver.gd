extends Node

func _ready():
	#get an instance of gut
	var tester = load('res://scripts/gut.gd').new()
	add_child(tester)
	tester.set_should_print_to_console(true)
	tester.add_script('res://scripts/sample_tests.gd')
	tester.add_script('res://scripts/sean_tests.gd')
	tester.test_scripts()
