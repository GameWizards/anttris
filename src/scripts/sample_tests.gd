extends "res://scripts/gut.gd".Test

var PuzzleManager = preload("res://scripts/PuzzleManager.gd")

func setup():
	gut.p("ran setup", 2)

func teardown():
	gut.p("ran teardown", 2)

func test_assert_eq_number_equal():
	gut.p(str(PuzzleManager.PickledBlock))
	gut.assert_eq('asf', 'asdf', "Should pass")

