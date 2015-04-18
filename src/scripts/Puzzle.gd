extends Spatial

# proposed script manager:
# var PuzzleManScript = get_node("Globals").get("PuzzleManScript")

var PuzzleManScript = preload( "res://scripts/PuzzleManager.gd" )
var puzzleMan

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



