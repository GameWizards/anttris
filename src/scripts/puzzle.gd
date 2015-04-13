
extends Spatial

# Cache the block scene
var blocks = []


# Unique names are needed for every node added to the
# tree.
var unique_id = 0

# Called for initialization
func _ready():
	# Load the blocks.
	blocks.append( preload("res://blocks/block_red.scn") )
	blocks.append( preload("res://blocks/block_green.scn") )
	blocks.append( preload("res://blocks/block_blue.scn") )
	blocks.append( preload("res://blocks/block_yellow.scn") )
	blocks.append( preload("res://blocks/block_orange.scn") )
	blocks.append( preload("res://blocks/block_purple.scn") )
	
	# Generate the puzzle.
	var PuzzleManScript = load( "res://scripts/PuzzleManager.gd" )
	var puzzleMan = PuzzleManScript.new()
	var puzzle = puzzleMan.generatePuzzle( puzzleMan.PUZZLE_5x5 )
	var n = puzzle.puzzleSize
	
	# Compute the offset.
	var offset = Vector3( float( -n * 2.0 / 2.0 ) + .5, float( -n * 2.0 ) / 2.0 + .5, float( -n * 2.0 / 2.0 ) + .5 )
	
	print( puzzle.blocks.size() )
	
	# Place the blocks in the puzzle.
	for i in range( puzzle.blocks.size() ):
		# Create a block, name it and add it to the tree
		var block = blocks[puzzle.blocks[i].blockType].instance()
		var block_name = "block" + str( unique_id )
		block.set_name( block_name )
		get_node( "GridView/GridMan" ).add_child( block )
		
		# Prepare for next block
		unique_id += 1
		
		# Configure block
		# Godot uses the forward slashes (/) on all platforms
		var pos = puzzle.blocks[i].blockPos * 2 + offset
		var node = get_node( "GridView/GridMan/" + block_name )
		node.set_translation( pos )


