
extends Spatial

# Unique names are needed for every node added to the
# tree.
var uniqueID = 0
var PuzzleManScript = preload( "res://scripts/PuzzleManager.gd" )
var puzzleMan

# Called for initialization
func _ready():
	# Generate the puzzle.

	puzzleMan = PuzzleManScript.new()
	var puzzle = puzzleMan.generatePuzzle( puzzleMan.PUZZLE_5x5 )
	var n = puzzle.puzzleType
	
	# Compute the offset.
	var offset = Vector3( float( -n * 2.0 / 2.0 ) + .5, float( -n * 2.0 ) / 2.0 + .5, float( -n * 2.0 / 2.0 ) + .5 )
	
	print( puzzle.blocks.size() )
	
	# Place the blocks in the puzzle.
	for block in puzzle.blocks:
		# Create a block node, add it to the tree
		var node = block.toNode(self)
		get_node( "GridView/GridMan" ).add_child( node )
		get_node( "GridView/GridMan/" + block.name ) \
			.set_translation(block.blockPos * 2 + offset )


