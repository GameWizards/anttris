extends Spatial

# Is there a better way to do this?
const BLOCK_LASER	= 0
const BLOCK_WILD	= 1
const BLOCK_PAIR	= 2
const BLOCK_GOAL	= 3
const BLOCK_BLOCK   = 4

# Shape dictionary to access blocks quickly by position.
var puzzle.shape = {}

# Block selection handling.
var offClick = false
var selectedBlocks = []

# Puzzle vars.
var puzzle
var puzzleLoaded = false

# Beam stuff.
const beamScn = preload( "res://blocks/block.scn" )
const Beam = preload("res://scripts/Blocks/Beam.gd")

# sounds
var samplePlayer = SamplePlayer.new()

func addPickledBlock(block):
	var b = block.toNode()

	puzzle.shape[b.blockPos] = b

	# TODO  any special treatment for the wild blocks?
	# TODO  keep track of puzzle.lasers ? How to?

	if puzzleLoaded:
		# keep pickled block
		puzzle.blocks.append(block)

		# keep track of puzzle.pairCounts
		var layer = calcBlockLayerVec(b.blockPos)
		if b.getBlockType() == 2:
			while puzzle.pairCount.size() <= layer:
				puzzle.pairCount.append(0)
			puzzle.pairCount[layer] += 0.5


	add_child(b)
	return b

func get_block(pos):
	if puzzle.shape.has(pos):
		return puzzle.shape[pos]
	else:
		return null

# unused key argument needed for the tween_complete signal
func remove_block(block_node, key=null):
	if block_node == null:
		return

	# need better way
	for i in range(puzzle.blocks.size()):
		if block_node.blockPos == puzzle.blocks[i].blockPos:
			puzzle.blocks.remove(i)

	puzzle.shape[block_node.blockPos] = null
	for child in block_node.get_children():
		block_node.remove_and_delete_child(child)
	remove_and_delete_child(block_node)

# Sets the puzzle for this GridMan.
func set_puzzle(puzz):
	# verify puzzle
	if puzz == null:
		print("INVALID PUZZLE")
		return

	# delete all current nodes
	for pos in puzzle.shape:
		remove_block(puzzle.shape[pos])
	puzzleLoaded = false

	# Store the puzzle.
	puzzle = puzz

		# # I can do my own counting!
	# needed for adding blocks in the editor
	for block in puzzle.blocks:
		# Create a block node, add it to the tree
		addPickledBlock(block)
	puzzleLoaded = true

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
	puzzle.shape[pos].forceClick()

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
	puzzle.pairCount[blayer] -= 1

	if( puzzle.pairCount[blayer] == 0 ):
		print("LAYER CLEARED")
		if blayer == 1:
			print( "GAME OVER!" )
			var pauseMenu = get_tree().get_root().get_node( "Spatial" ).get_node( "Camera" ).pauseMenu
			pauseMenu.set_text("GAME OVER\nSCORE:1,000,000")
			# TODO set timeout!!!
			pauseMenu.popup_centered()

		for b in puzzle.shape:
			if not ( puzzle.shape[b] == null ):
				if calcBlockLayerVec( b ) == blayer:
					if puzzle.shape[b].getBlockType() == BLOCK_LASER:
						puzzle.shape[b].forceActivate()

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


func _init():
	# Load sound
	samplePlayer.set_voice_count(10)
	samplePlayer.set_sample_library(ResourceLoader.load("new_samplelibrary.xml"))
	print("GridMan initialized")

func _ready():
	setupCam()

func setupCam():
	var cam = get_tree().get_root().get_node( "Spatial/Camera" )
	if cam == null or puzzle == null:
		return
	var totalSize = ( puzzle.puzzleLayers * 2 + 1 )
	cam.distance.val = 4.5 * totalSize
	cam.distance.min_ = 3 * totalSize
	cam.distance.max_ = 10 * totalSize
	cam.recalculate_camera()


