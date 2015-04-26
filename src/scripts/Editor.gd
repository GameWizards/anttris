extends Spatial

var puzzleMan
var gridMan
var prevBlock = null

var puzzleScn = preload("res://puzzle.scn")

func shouldAddNeighbor():
	return not (gridMan.shape.keys().size() > 28)

func newPickledBlock():
	var b = puzzleMan.PickledBlock.new()\
		.setName(gridMan.shape.keys().size())\
	if prevBlock != null:
		b.setPairName(prevBlock.name)
		gridMan.get_node(prevBlock.toNode().name).setPairName(b.name)
		prevBlock = null
	else:
		prevBlock = b
	return b

func _ready():
	var pMan = puzzleScn.instance()
	gridMan = pMan.get_node("GridView/GridMan")
	pMan.mainPuzzle = false
	pMan.time.on = false
	pMan.set_as_toplevel(true)

	add_child(pMan)
	puzzleMan = pMan.puzzleMan

	set_process_input(true)


