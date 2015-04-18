extends "res://scripts/gut.gd".Test



func setup():
	gut.p("ran setup", 2)

func teardown():
	gut.p("ran teardown", 2)

func test_assert_eq_number_equal():
    gut.assert_eq('asdf', 'asdf', "Should pass")
