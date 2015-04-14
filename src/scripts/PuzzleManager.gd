const PUZZLE_5x5		= 5
const PUZZLE_7x7		= 7
const blockColors = ["Blue", "Orange", "Red", "Yellow"]

# Preload paired blocks
const pairedBlock = preload("Blocks/PairedBlock.gd")
const flyBlock = preload("Blocks/FlyawayTestBlock.gd")
const blockScn = preload( "res://blocks/block.scn" )


# Stores a puzzle in a convenient class.
class Puzzle:
	var puzzleType
	var blocks = []

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

# Generates a solveable puzzle.
func generatePuzzle( type ):
	var blockID = 0
	var puzzle = Puzzle.new()
	puzzle.puzzleType = type
	
	var middle = type / 2
	
	# create all possible positions
	var shape = []
	for x in range( type ):
		for y in range( type ):
			for z in range( type ):
				shape.append(Vector3(x,y,z))
	
	# assign blocks to positions
	var prevBlock = null
	var even = false
	for pos in shape:
		var x = pos.x
		var y = pos.y
		var z = pos.z
		if (x == middle && y == middle && z == middle):
			continue
		var b = PickledBlock.new()
		b.blockPos = pos
		b.name = "block" + str(blockID)
		
		blockID += 1
		puzzle.blocks.append( b )
			
		if (x == y and y == z):
			b.setBlockClass("LaserBlock")
		else:
			if even:
				var randColor = blockColors[randi() % blockColors.size()]
				b.setBlockClass("PairedBlock") \
					.setPairName(prevBlock.name) \
					.setTextureName(randColor)
	
				prevBlock.setBlockClass("PairedBlock") \
					.setPairName(b.name) \
					.setTextureName(randColor)
			even = not even
			prevBlock = b
				

	
	# TODO, proposed algorithm:
	# make blocks, pairs are adjacent
	# shuffle board, half the blocks pick a "nearby" block to swap places with
	# nearby = same layer, somewhere accessible to the user
	
	# Randomize the order of the blocks.
	#self.shuffleArray( puzzle.blocks )
	
	# Assign block types in pairs.
#	for i in range( 0, puzzle.blocks.size(), 2 ):
#		var randColor = blockColors[randi() % blockColors.size()]
#		puzzle.blocks[i].setBlockClass("PairedBlock") \
#			.setPairName(puzzle.blocks[i+1].name) \
#			.setTextureName(randColor)
#			
#		puzzle.blocks[i+1].setBlockClass("PairedBlock") \
#			.setPairName(puzzle.blocks[i].name) \
#			.setTextureName(randColor)
	
	return puzzle
	
# Determines if a puzzle is solveable.
func solvePuzzle( puzzle ):
	# Simply use the SolvePuzzleSteps function and return the solveable part.
	var ps = solvePuzzleSteps()
	return ps.solveable
	
# Determines if a puzzle is solveable and returns the steps needed to solve it.
func solvePuzzleSteps( puzzle ):
	var puzzleSteps = PuzzleSteps.new()
	puzzleSteps.solveable = true
	
	# SOLVER
	
	return puzzleSteps
	

class PickledBlock:
	var name
	var blockClass
	var pairName
	var textureName
	var blockPos
	
	func setName(n):
		name = n
		return self
		
	func setPairName(n):
		pairName = n
		return self
		
	func setBlockClass(c):
		blockClass = c
		return self
		
	func setTextureName(t):
		textureName = t
		return self
		
	func toString():
		return str(name) + ": " + str(blockClass)

	func toNode(gen):
		# instantiate a block scene, assign the appropriate script to it
		var n = blockScn.instance()
		n.set_script(load("res://scripts/Blocks/" + blockClass + ".gd"))
		
		# configure block node
		n.setName(name).setTexture()

		if blockClass == "PairedBlock":
			n.setPairName(pairName).setTexture(textureName)
		return n