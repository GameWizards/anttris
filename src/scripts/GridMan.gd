extends Spatial

# Is there a better way to do this?
const BLOCK_LASER	= 0
const BLOCK_WILD	= 1
const BLOCK_PAIR	= 2
const BLOCK_GOAL	= 3
const BLOCK_BLOCK   = 4

# Block selection handling.
var offClick = false
var selectedBlocks = []

# Puzzle vars.
var puzzle
var puzzleLoaded = false
var blockNodes = {}

var puzzleScn

# Beam stuff.
const beamScn = preload( "res://blocks/block.scn" )
const Beam = preload("res://scripts/Blocks/Beam.gd")

# sounds
var samplePlayer = SamplePlayer.new()

func addPickledBlock(block):
	var b = block.toNode()

	# TODO  any special treatment for the wild blocks?
	# TODO  keep track of puzzle.lasers ? How to?
	blockNodes[block.blockPos] = b

	if puzzleLoaded:
		# keep pickled block
		puzzle.shape[block.blockPos] = block

		# keep track of puzzle.pairCounts
		var layer = calcBlockLayerVec(b.blockPos)
		if b.getBlockType() == 2:
			while puzzle.pairCount.size() <= layer:
				puzzle.pairCount.append(0)
			puzzle.puzzleLayers = puzzle.pairCount.size() - 1
			puzzle.pairCount[layer] += 0.5


	add_child(b)
	return b

func get_block(pos):
	if blockNodes.has(pos):
		return blockNodes[pos]
	else:
		return null

# unused key argument needed for the tween_complete signal
func remove_block(block=null, key=null):
	var block_node = blockNodes[block.blockPos]
	puzzle.shape[block_node.blockPos] = null

	if block_node == null:
		return

	blockNodes[block_node.blockPos] = null

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
	if puzzle != null:
		for pos in puzzle.shape:
			remove_block(puzzle.shape[pos])
	puzzleLoaded = false
	#print( puzzDict.type() )
	print("This is puzz: ", puzz )

	puzzle = puzz

	# Load in the puzzle from dictionary
	#puzzle.fromDict(puzzDict)

		# # I can do my own counting!
	# needed for adding blocks in the editor
	for k in puzzle.shape:
		# Create a block node, add it to the tree
		addPickledBlock(puzzle.shape[k])
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
	blockNodes[pos].forceClick()

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

func beatenWithScore(othersScore):
	print( "BEATEN!" )
	var pauseMenu = get_tree().get_root().get_node( "Spatial" ).get_node( "Camera" ).pauseMenu
	pauseMenu.set_title("Game Over")
	pauseMenu.set_text("GAME OVER\nYou've been beaten with time: " + puzzleScn.formatTime(othersScore))
	pauseMenu.popup_centered()

func win():
	print( "GAME OVER!" )
	var pauseMenu = get_tree().get_root().get_node( "Spatial" ).get_node( "Camera" ).pauseMenu
	pauseMenu.set_title("Game Over")
	pauseMenu.set_text("GAME OVER\nYou win with time: " + puzzleScn.formatTime(get_parent().get_parent().time.val))
	pauseMenu.popup_centered()


# Handles keeping track of pairs being removed.
func popPair( pos ):
	var blayer = calcBlockLayerVec( pos )
	puzzle.pairCount[blayer] -= 1

	if( puzzle.pairCount[blayer] == 0 ):
		print("LAYER CLEARED")
		if blayer == 1:
			win()

		for b in puzzle.shape:
			if not ( puzzle.shape[b] == null ):
				if calcBlockLayerVec( b ) == blayer:
					if blockNodes[b].getBlockType() == BLOCK_LASER:
						blockNodes[b].forceActivate()

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

	puzzleScn = get_parent().get_parent()


func setupCam():
	var cam = get_tree().get_root().get_node( "Spatial/Camera" )
	if cam == null or puzzle == null:
		return
	var totalSize = ( puzzle.puzzleLayers * 2 + 1 )
	cam.distance.val = 4.5 * totalSize
	cam.distance.min_ = 3 * totalSize
	cam.distance.max_ = 10 * totalSize
	cam.recalculate_camera()


