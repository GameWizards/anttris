extends "res://scripts/gut.gd".Test

var puzzleManScript = load("res://scripts/PuzzleManager.gd")
var abstractScript = load("res://scripts/Blocks/AbstractBlock.gd")

func setup():
	gut.p("ran setup", 2)

func teardown():
	gut.p("ran teardown")

func test_unpickled_paired_block():
	var pMan = puzzleManScript.new()
	var pickle = pMan.PickledBlock.new()
	var aB = abstractScript
	pickle.setName(1) \
		.setBlockClass(pMan.BLOCK_PAIR) \
		.setPairName("TestPickledBlock_BUDDY") \
		.setTextureName("Blue")
	var node = pickle.toNode()
	gut.assert_eq(node.name, aB.nameToNodeName(pickle.name), "toName(Pickled name) = node name")
	gut.assert_eq(node.pairName,  aB.nameToNodeName(pickle.pairName), "toName(Pickled pair name) = node pair name")
	gut.assert_eq(node.textureName, pickle.textureName, "Pickled texture = node texture")

	# test AbstractBlock.pairActivate
	gut.assert_eq(node.selected, false, "Abstract.activate starts as false")
	var pairNode = node.pairActivate(null, null, null)
	gut.assert_eq(pairNode, null, "pairActivate returns null for invalid pair")
	gut.assert_eq(node.selected, true, "Abstract.activate is true after activation")

func test_unpickled_laser_block():
	var pMan = puzzleManScript.new()
	var pickle = pMan.PickledBlock.new()
	var aB = abstractScript
	pickle.setName(0) \
		.setBlockClass(pMan.BLOCK_LASER) \
		.setPairName("TestPickledBlock_BUDDY") \
		.setLaserExtent(Vector3(1,1,1)) \
		.setTextureName("Blue")
	var node = pickle.toNode()
	gut.assert_eq(node.name, aB.nameToNodeName(pickle.name), "toName(Pickled name) = node name")
	gut.assert_eq(node.pairName,  aB.nameToNodeName(pickle.pairName), "toName(Pickled pair name) = node pair name")
	gut.assert_eq(node.laserExtent, pickle.laserExtent, "Pickled laser extent = node laser extent")

func test_puzzleMan_generatePuzzle():
	var pMan = puzzleManScript.new()
	for layers in [0,1,2,5]:
		for diff in [pMan.DIFF_HARD, pMan.DIFF_MEDIUM, pMan.DIFF_EASY]:
			var puzzle = pMan.generatePuzzle(layers, diff)
			gut.assert_eq(puzzle.puzzleLayers, layers, "puzzleMan layers = layers. difficulty=" + str(diff))
			gut.assert_eq(float(puzzle.blocks.size()), pow(layers * 2 + 1,3) - 1, "puzzleMan blocks.size = (layers*2 + 1)**3 - 1. difficulty=" + str(diff))
			gut.assert_eq(puzzle.solvePuzzle(), true, "Puzzle solveable")

func test_network():
	# test start
	# test transmit blocks
	# test end
	gut.assert_eq(true, true, "TRUE")
	pass
