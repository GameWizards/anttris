extends Spatial

# Is there a better way to do this?
const BLOCK_LASER	= 0
const BLOCK_WILD	= 1
const BLOCK_PAIR	= 2
const BLOCK_GOAL	= 3
const BLOCK_BLOCK   = 4

# Shape dictionary to access blocks quickly by position.
var shape = {}

# Block selection handling.
var offClick = false
var selectedBlocks = []

# Puzzle vars.
var puzzle
var pairCount = []

# Beam stuff.
const beamScn = preload( "res://blocks/block.scn" )
const Beam = preload("res://scripts/Blocks/Beam.gd")

# sounds
var samplePlayer = SamplePlayer.new()

func add_block(b):
	shape[b.blockPos] = b

	if b.getBlockType() == 2:
		var layer = calcBlockLayerVec(b.blockPos)
		while pairCount.size() <= layer:
				pairCount.append(0)
	
		# preload("res://trust")
		pairCount[layer] += 0.5

	add_child(b)

func get_block(pos):
	if shape.has(pos):
		return shape[pos]
	else:
		return null

func remove_block(block_node):
	shape[block_node.blockPos] = null
	# TODO scan_layer, fire lasers if empty
	for child in block_node.get_children():
		block_node.remove_and_delete_child(child)
	remove_and_delete_child(block_node)

# TODO wild block selected? can click any pair. can deselect wild block.
var wildBlockSelected = null

# Sets the puzzle for this GridMan.
func set_puzzle(puzz):
	# TODO delete current puzzle
	
	# Store the puzzle.
	puzzle = puzz

	# Initalization here
	samplePlayer.set_voice_count(puzzle.puzzleLayers * 2)
	samplePlayer.set_sample_library(ResourceLoader.load("new_samplelibrary.xml"))

	# Set the camera range to be relative to the layer count.
	var cam = get_parent().get_parent().get_node( "Camera" )
	var totalSize = ( puzzle.puzzleLayers * 2 + 1 )
	cam.distance.val = 4.5 * totalSize
	cam.distance.min_ = 3 * totalSize
	cam.distance.max_ = 10 * totalSize
	cam.recalculate_camera()
	
	for block in puzzle.blocks:
		# Create a block node, add it to the tree
		add_block(block.toNode())

# Clears any selected blocks. WE SHOULD FIX THIS, THERE CAN ONLY BE ONE BLOCK SELECTED AT ANY ONE TIME, NO NEED FOR AN ARRAY!
func clearSelection():
	for bl in selectedBlocks:
		var blo = get_node( bl )
		blo.setSelected(false)
		blo.scaleTweenNode(1.0).start()
	selectedBlocks = []

# Add the selected block to the selected list. WE SHOULD FIX THIS, IT ONLY NEEDS TO STORE IT, NOT AN ARRAY!
func addSelected(bl):
	selectedBlocks.append(bl)

# Used for the multiplayer mode to force click a block on their side.
func forceClickBlock( pos ):
	shape[pos].forceClick()

func clickBlock( name ):
	#now check if that was the second block we picked. If it was, we want to
	#unselect the blocks again
	if (offClick):
		offClick = false
		addSelected(name)
		clearSelection()
	else:
		offClick = true;
		addSelected(name)

# Calculates the layer that a block is on.
# COPY OF FUNCTION IN PUZZLEMAN, IS THERE A BETTER WAY TO DO THIS?!
func calcBlockLayer( x, y, z ):
	return max( max( abs( x ), abs( y ) ), abs( z ) )
func calcBlockLayerVec( pos ):
	return max( max( abs( pos.x ), abs( pos.y ) ), abs( pos.z ) )

# Handles keeping track of pairs being removed.
func popPair( pos ):
	var blayer = calcBlockLayerVec( pos )
	pairCount[blayer] -= 1

	if( pairCount[blayer] == 0 ):
		print("LAYER CLEARED")
		if blayer == 1:
			print( "GAME OVER!" )

		for b in shape:
			if not ( shape[b] == null ):
				if calcBlockLayerVec( b ) == blayer:
					if shape[b].getBlockType() == BLOCK_LASER:
						shape[b].forceActivate()

		# Fire beams.
		var beamNum = 0
		for l in range( puzzle.lasers.size() ):
			if calcBlockLayerVec( puzzle.lasers[l][0] ) == blayer:
				# Firin mah lazerz!
				var beam = beamScn.instance()

				beam.set_name( str(blayer) + "_beam_" + str(beamNum) )
				beamNum += 1
				beam.set_script( Beam )

				add_child( beam )
				beam.fire( puzzle.lasers[l][0], puzzle.lasers[l][1] )

				samplePlayer.play( "soundslikewillem_hitting_slinky" )

