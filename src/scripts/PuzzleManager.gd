const DIFF_EASY		= 0
const DIFF_MEDIUM	= 1
const DIFF_HARD		= 2

const BLOCK_LASER	= 0
const BLOCK_WILD	= 1
const BLOCK_PAIR	= 2
const BLOCK_GOAL	= 3
const BLOCK_BLOCK   = 4

const blockColors = ["Blue", "Orange", "Red", "Yellow", "Purple", "Green"]
const wildColors = ["WildBlue", "WildOrange", "WildRed", "WildYellow", "WildPurple", "WildGreen"]

# Preload paired blocks
const blockScn = preload( "res://blocks/block.scn" )
const blocks = [ preload( "Blocks/LaserBlock.gd" )
			   , preload( "Blocks/LaserBlock.gd" )
			   , preload( "Blocks/PairedBlock.gd" )
			   , preload( "Blocks/LaserBlock.gd" )
			   ]
const aBlock = preload( "Blocks/AbstractBlock.gd" )

# Hash map of all possible positions
var shape = {}

# Stores a puzzle in a convenient class.
class Puzzle:
	var puzzleName
	var puzzleLayers
	var blocks = []
	
	# Determines if a puzzle is solveable.
	func solvePuzzle():
		# Simply use the solvePuzzleSteps function and return the solveable part.
		var ps = self.solvePuzzleSteps()
		return ps.solveable
	
	# Determines if a puzzle is solveable and returns the steps needed to solve it.
	func solvePuzzleSteps():
		var puzzleSteps = PuzzleSteps.new()
		puzzleSteps.solveable = true
	
		# SOLVER
	
		return puzzleSteps
	
	# Holds all of the steps needed to solve a puzzle.
	class PuzzleSteps:
		var solveable

# Randomly shuffle an array.
func shuffleArray( arr ):
	for i in range( arr.size() - 1, 1, -1 ):
		# works great! print( "SWAP" )
		var swapVal = randi() % (i + 1)
		var temp = arr[swapVal]
		arr[swapVal] = arr[i]
		arr[i] = temp
		

# calculate the layer; move into a method so that it can be used elsewhere
func calcBlockLayer( x, y, z ):
	var layer = max( max( abs( x ), abs( y ) ), abs( z ) )
	return layer

# Determines the block type based on puzzle size and difficulty.
func getBlockType( difficulty, x, y, z ):
	# Determine if this is the goal block.
	if x == 0 and y == 0 and z == 0:
		return BLOCK_GOAL

	# Determine the layer this block is on.
	var layer = calcBlockLayer( x, y, z )

	# Determine how many blocks are on the outer part of the layer.
	var layerCount = 0
	if abs( x ) == layer:
		layerCount += 1
	if abs( y ) == layer:
		layerCount += 1
	if abs( z ) == layer:
		layerCount += 1

	# Determine if this block is a laser.
	if difficulty == DIFF_EASY or difficulty == DIFF_MEDIUM:
		if layerCount == 3:
			return BLOCK_LASER

	if difficulty == DIFF_HARD:
		if abs( x ) == abs( z ) and y == 0:
			return BLOCK_LASER

	# Determine if this block is a wild block.
	if difficulty == DIFF_EASY:
		if layerCount == 2:
			return BLOCK_WILD

	if difficulty == DIFF_MEDIUM:
		if layerCount == 2:
			if y == layer || y == -layer:
				return BLOCK_WILD

	if difficulty == DIFF_HARD:
		if layerCount == 1:
			if y == 0:
				return BLOCK_WILD

	# Otherwise it's a normal block.
	return BLOCK_PAIR

# Generates a solveable puzzle.
func generatePuzzle( layers, difficulty ):
	var blockID = 0
	var puzzle = Puzzle.new()
	puzzle.puzzleName = "RANDOM PUZZLE"
	puzzle.puzzleLayers = layers

	# Create all possible positions.
	var allblocks = []
	for x in range( -layers, layers + 1 ):
		for y in range( -layers, layers + 1 ):
			for z in range( -layers, layers + 1 ):
				allblocks.append(Vector3(x,y,z))
				shape[Vector3(x,y,z)] = null
				
	shuffleArray( allblocks )

	# Assign block types based on position.
	var prevBlock = null
	var even = false
	var prevLaser = null
	var laserEven = false
	for pos in allblocks:
		var x = pos.x
		var y = pos.y
		var z = pos.z

		var t = getBlockType( difficulty, x, y, z )

		if t == BLOCK_GOAL:
			continue

		var b = PickledBlock.new()
		b.blockPos = pos
		b.name = blockID

		blockID += 1
		puzzle.blocks.append( b )

		if t == BLOCK_LASER:
			b.setBlockClass(BLOCK_LASER)
			if laserEven:
				b.setPairName(prevLaser.name) \
				.setLaserExtent(prevLaser.blockPos - b.blockPos)

				prevLaser.setPairName(b.name) \
				.setLaserExtent(b.blockPos - prevLaser.blockPos)
			laserEven = not laserEven
			prevLaser = b
			continue

		if t == BLOCK_WILD:
			b.setBlockClass(BLOCK_PAIR) \
				.setTextureName(wildColors[randi() % wildColors.size()])
			continue

		if even:
			var randColor = blockColors[randi() % blockColors.size()]
			b.setBlockClass(BLOCK_PAIR) \
				.setPairName(prevBlock.name) \
				.setTextureName(randColor)

			prevBlock.setBlockClass(BLOCK_PAIR) \
				.setPairName(b.name) \
				.setTextureName(randColor)
		even = not even
		prevBlock = b

	return puzzle


class PickledBlock:
	var name
	var blockClass = BLOCK_PAIR
	var pairName
	var textureName = "Red"
	var blockPos
	var laserExtent

	func setName(n):
		name = n
		return self

	func setPairName(n):
		pairName = n
		return self

	func setLaserExtent(n):
		laserExtent = n
		return self

	func setBlockClass(c):
		blockClass = c
		return self

	func setTextureName(t):
		textureName = t
		return self

	func toString():
		return str(name) + ": " + str(blockClass)

	func toNode():
		# instantiate a block scene, assign the appropriate script to it
		var n = blockScn.instance()
		n.set_script(blocks[blockClass])

		# configure block node
		n.setName(str(name)).setTexture()
		n.blockPos = blockPos
		if blockClass == BLOCK_PAIR:
			n.setPairName(pairName).setTexture(textureName)

		if blockClass == BLOCK_LASER:
			n.setPairName(pairName).setExtent(laserExtent)
		return n
		
	# Convert this object to a dictionary.
	func toDict():
		var di = { n = name
		 	     , bC = blockClass
			     , pN = pairName
			     , tN = textureName
			     , bP = blockPos
			     , lE = laserExtent
			     }
		return di
			
	# Make this object from a dictionary.
	func fromDict( di ):
		name = di.n
		blockClass = di.bC
		pairName = di.pN
		textureName = di.tN
		blockPos = di.bP
		laserExtent = di.lE

