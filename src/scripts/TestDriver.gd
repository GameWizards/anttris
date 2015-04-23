extends Node

func _ready():
	#get an instance of gut
	var tester = load('res://scripts/gut.gd').new()
	add_child(tester)
	tester.set_should_print_to_console(true)
	tester.add_script('res://scripts/sean_tests.gd')
	tester.test_scripts()

	# close on test end
	print("\n\tResources in use:")
	OS.print_resources_in_use(true)
	OS.get_main_loop().quit()
