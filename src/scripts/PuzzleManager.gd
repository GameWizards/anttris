const DIFF_EASY		= 0
const DIFF_MEDIUM	= 1
const DIFF_HARD		= 2

# this order is important
const BLOCK_LASER	= 0
const BLOCK_WILD	= 1
const BLOCK_PAIR	= 2
const BLOCK_GOAL	= 3
const BLOCK_BLOCK   = 4

const SOLVER_ERROR_NONE				= 0
const SOLVER_ERROR_MISSING_PAIR		= 1

const blockColors = ["Blue", "Orange", "Red", "Gray", "Purple", "Green"]

# Preload paired blocks
const blockScn = preload( "res://blocks/block.scn" )
const blockScripts = [ preload( "Blocks/LaserBlock.gd" )
			   	      , preload( "Blocks/WildBlock.gd" )
			   	      , preload( "Blocks/PairedBlock.gd" )
			   	      , preload( "Blocks/LaserBlock.gd" )
			   	      ]

# Hash map of all possible positions
var shape = {}

# Calculates the layer that a block is on.
static func calcBlockLayer( x, y, z ):
	return max( max( abs( x ), abs( y ) ), abs( z ) )
# THIS IS EVERYWHERE, ANY BETTER WAY TO HAVE FUNCTIONS BETWEEN SCRIPTS?
static func calcBlockLayerVec( pos ):
	return max( max( abs( pos.x ), abs( pos.y ) ), abs( pos.z ) )

# Stores a puzzle in a convenient class.
class Puzzle:

	var puzzleName			# The name of the puzzle.
	var puzzleLayers		# The amount of layers the puzzle has.
	var pairCount = []		# The amount of pair blocks on each layer.
	var shape = {}			# All blocks indexed by position
	var lasers = []			# Laser connections.
	var puzzleMan			# Stores the puzzle manager for making pickled blocks.

	# Converts a puzzle to a dictionary.
	func toDict():
		var blocksArray = []
		for k in shape.keys():
			if shape[k] == null:
				continue
			blocksArray.append(shape[k].toDict())

		var di = { pN = puzzleName
		 	     , pL = puzzleLayers
				 , bL = blocksArray
				 , pC = pairCount
				 , lS = lasers
			     }
		return di

	# Converts a dictionary to a puzzle.
	func fromDict( di ):
		print(di)
		puzzleName = di.pN
		puzzleLayers = di.pL
		pairCount = di.pC
		lasers = di.lS

		for block in di.bL:
			var nb = puzzleMan.PickledBlock.new()
			nb.fromDict( block )
			shape[nb.blockPos] = nb
		return

	# Class that stores a solution or the errors in a puzzle.
	class PuzzleSteps:
		var solveable = false
		var error = SOLVER_ERROR_NONE
		var errorBlock = null
		var solveSteps = []

	# THIS IS EVERYWHERE, ANY BETTER WAY TO HAVE FUNCTIONS BETWEEN SCRIPTS?
	# duplicate of the global definition above? Either way godot is chill and
	# doesn't complain
	func calcBlockLayerVec( pos ):
		return max( max( abs( pos.x ), abs( pos.y ) ), abs( pos.z ) )

	# Determines if a puzzle is solveable.
	func solvePuzzle():
		# Simply use the solvePuzzleSteps function and return the solveable part.
		var ps = self.solvePuzzleSteps()
		return ps.solveable

	# Determines if a puzzle is solveable and returns the steps needed to solve it.
	func solvePuzzleSteps():
		var puzzleSteps = PuzzleSteps.new()

		var pairs = []

		# Add new dictionary for each later.
		for l in range( puzzleLayers + 1 ):
			pairs.append( {} )

		# Gather paired blocks from the puzzle.
		for k in shape.keys():
			var b = shape[k]
			if b.blockClass == BLOCK_PAIR:
				b.solverFlag = false
				pairs[calcBlockLayerVec(b.blockPos)][b.name] = b

		# Make sure each pair block has a valid pair on the same layer.
		for l in pairs:
			for p in l:
				if l.has( l[p].pairName ):
					if( not l[p].solverFlag ):
						l[p].solverFlag = true
						l[l[p].pairName].solverFlag = true
						puzzleSteps.solveSteps.append( [ l[p].blockPos, l[l[p].pairName].blockPos ] )
				else:
					puzzleSteps.error = SOLVER_ERROR_MISSING_PAIR
					puzzleSteps.errorBlock = l[p]
					return puzzleSteps

		puzzleSteps.solveable = true
		return puzzleSteps

# Randomly shuffle an array.
func shuffleArray( arr ):
	for i in range( arr.size() - 1, 1, -1 ):
		var swapVal = randi() % (i + 1)
		var temp = arr[swapVal]
		arr[swapVal] = arr[i]
		arr[i] = temp

# Determines the block type based on puzzle size and difficulty.
func getBlockType( difficulty, pos ):
	# Determine if this is the goal block.
	if pos.x == 0 and pos.y == 0 and pos.z == 0:
		return BLOCK_GOAL

	# Determine the layer this block is on.
	var layer = calcBlockLayerVec( pos )

	# Determine how many blocks are on the outer part of the layer.
	var layerCount = 0
	if abs( pos.x ) == layer:
		layerCount += 1
	if abs( pos.y ) == layer:
		layerCount += 1
	if abs( pos.z ) == layer:
		layerCount += 1

	# Determine if this block is a laser.
	if difficulty == DIFF_EASY or difficulty == DIFF_MEDIUM:
		if layerCount == 3:
			return BLOCK_LASER

	if difficulty == DIFF_HARD:
		if abs( pos.x ) == abs( pos.z ) and pos.y == 0:
			return BLOCK_LASER

	# Determine if this block is a wild block.
	if difficulty == DIFF_EASY:
		if layerCount == 2:
			return BLOCK_WILD

	if difficulty == DIFF_MEDIUM:
		if layerCount == 2:
			if pos.y == layer || pos.y == -layer:
				return BLOCK_WILD

	if difficulty == DIFF_HARD:
		if layerCount == 1:
			if pos.y == 0:
				return BLOCK_WILD

	# Otherwise it's a normal block.
	return BLOCK_PAIR

# Generates a solveable puzzle.
func generatePuzzle( layers, difficulty ):
	var blockID = 0
	var puzzle = Puzzle.new()
	puzzle.puzzleName = "RANDOM PUZZLE"
	puzzle.puzzleLayers = layers
	
	var glyphOn = []
	for g in range( blockColors.size() ):
		glyphOn.append( 0 )

	# Create all possible positions.
	var layeredblocks = []
	for l in range( 0, layers + 1 ):
		layeredblocks.append( [] )
		puzzle.pairCount.append( 0 )
	for x in range( -layers, layers + 1 ):
		for y in range( -layers, layers + 1 ):
			for z in range( -layers, layers + 1 ):
				layeredblocks[calcBlockLayer( x, y, z )].append(Vector3(x,y,z))

	# Generate laser lines.
	for l in range( 1, layers + 1 ):
		if difficulty == DIFF_MEDIUM or difficulty == DIFF_EASY:
			for lx in [ -l, l ]:
				for ly in [ -l, l ]:
					puzzle.lasers.append( [Vector3( lx, ly, lx ), Vector3( lx*-1, ly, lx )] )
					puzzle.lasers.append( [Vector3( lx, ly, lx ), Vector3( lx, ly, lx*-1 )] )

		if difficulty == DIFF_EASY:
			for lx in [ -l, l ]:
				for lz in [ -l, l ]:
					puzzle.lasers.append( [Vector3( lx, l, lz ), Vector3( lx, -l, lz )] )

		if difficulty == DIFF_HARD:
			for lx in [ -l, l ]:
					puzzle.lasers.append( [Vector3( lx, 0, lx ), Vector3( lx*-1, 0, lx )] )
					puzzle.lasers.append( [Vector3( lx, 0, lx ), Vector3( lx, 0, lx*-1 )] )

	# Assign block types based on position.
	for l in range( 0, layers + 1 ):
		# Randomize the pairs.
		shuffleArray( layeredblocks[l] )
		# print( "NUM ", layeredblocks[l].size() )
		var prevBlock = null
		var even = false
		for pos in layeredblocks[l]:
			var x = pos.x
			var y = pos.y
			var z = pos.z

			var t = getBlockType( difficulty, pos )

			if t == BLOCK_GOAL:
				continue

			var b = PickledBlock.new()
			b.blockPos = pos
			b.name = blockID

			blockID += 1
			puzzle.shape[pos] = b

			if t == BLOCK_LASER:
				b.setBlockClass(BLOCK_LASER)\
					.setLaserExtent( Vector3( 0, 1, 0 ) )
				continue

			if t == BLOCK_WILD:
				b.setBlockClass(BLOCK_WILD) \
					.setTextureName(blockColors[randi() % blockColors.size()])
				continue

			if even:
				# Count this pair.
				puzzle.pairCount[l] += 1

				var randColor = ( randi() % blockColors.size() )
				var randMaterial = blockColors[randColor] + str( glyphOn[randColor] + 1 )
				glyphOn[randColor] += 1
				glyphOn[randColor] %= 3
				b.setBlockClass(BLOCK_PAIR) \
					.setPairName(prevBlock.name) \
					.setTextureName(randMaterial)

				prevBlock.setBlockClass(BLOCK_PAIR) \
					.setPairName(b.name) \
					.setTextureName(randMaterial)
			even = not even
			prevBlock = b

	return puzzle

# Storage class for blocks in a puzzle.
class PickledBlock:
	var name
	var blockClass = BLOCK_PAIR
	var pairName
	var textureName = "Red"
	var blockPos
	var laserExtent
	var solverFlag		# Keeps track of this block, only user for the solver.

	func setName(n):
		name = n
		return self

	func setPairName(n):
		pairName = n
		return self

	func setLaserExtent(n):
		laserExtent = n
		return self

	func setBlockPos(n):
		blockPos = n
		return self

	func setBlockClass(c):
		blockClass = c
		return self

	func setTextureName(t):
		textureName = t
		return self

	func toString():
		return str(name) + ": " + str(blockClass) + " @ " + str(blockPos)

	func toNode():
		# instantiate a block scene, assign the appropriate script to it
		var n = blockScn.instance()
		n.set_script(blockScripts[blockClass])

		n.set_translation(blockPos * 2)
		n.blockPos = blockPos

		n.setName(str(name)).setTexture( "Red1" )

		n.setBlockType( blockClass )

		if blockClass == BLOCK_PAIR:
			n.setPairName(pairName).setTexture(textureName)

		if blockClass == BLOCK_WILD:
			n.setTexture(textureName)

		if blockClass == BLOCK_LASER:
			n.setPairName(pairName).setExtent(laserExtent)
		return n

	# test me plz
	func fromNode(n):
		blockPos = n.blockPos

		name = n.name_int

		blockClass = n.getBlockType()

		if blockClass == BLOCK_PAIR:
			pairName = n.pairName
			textureName = n.textureName

		if blockClass == BLOCK_WILD:
			textureName = n.textureName

		if blockClass == BLOCK_LASER:
			pairName = n.pairName

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

