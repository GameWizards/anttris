extends Spatial

# proposed script manager:
# var PuzzleManScript = get_node("Globals").get("PuzzleManScript")

var PuzzleManScript = preload( "res://scripts/PuzzleManager.gd" )
var PuzzleScn = preload("res://puzzle.scn")
var puzzleMan
var mainPuzzle = true

# Called for initialization
func _ready():
	puzzleMan = PuzzleManScript.new()
	var puzzle = puzzleMan.generatePuzzle( 2, puzzleMan.DIFF_EASY )

	print("Generated ", puzzle.blocks.size(), " blocks." )

	# Place the blocks in the puzzle.
	var gridMan = get_node( "GridView/GridMan" )
	gridMan.shape = puzzleMan.shape
	gridMan.set_puzzle(puzzle)
	for block in puzzle.blocks:
		# Create a block node, add it to the tree
		var b = block.toNode()
		gridMan.shape[b.blockPos] = b
		gridMan.add_block(b)
		gridMan.get_child(block.name) \
			.set_translation(block.blockPos * 2 )
	
	if mainPuzzle:
		var p = PuzzleScn.instance()
		p.mainPuzzle = false
		p.set_scale(Vector3(0.5, 0.5, 0.5))
		p.set_translation(Vector3(20, 0, 0))
		
		var v = Viewport.new()
		v.set_as_render_target(true)
		v.set_world(p.get_world())
		v.set_rect(Rect2(0, 0, 100, 100))
		v.set_physics_object_picking(false)
		v.add_child(p)
		add_child(v)
		

