extends "res://scripts/gut.gd".Test

var puzzleManScript = load("res://scripts/PuzzleManager.gd")

func setup():
	gut.p("ran setup", 2)

func teardown():
	gut.p("ran teardown")

func test_assert_eq_block_name_is_equal():
	var pMan = puzzleManScript.new()
	var pickle = pMan.PickledBlock.new()
	pickle.setName("TestPickledBlock")
	var node = pickle.toNode()
	gut.assert_eq(node.name, 'TestPickledBlock', "Should pass")
