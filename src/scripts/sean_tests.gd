extends "res://scripts/gut.gd".Test

func setup():
	gut.p("ran setup", 2)
	
func teardown():
	gut.p("ran teardown")
	
func test_assert_eq_number_is_equal():
	gut.assert_eq('asf', 'asdf', "Should pass")