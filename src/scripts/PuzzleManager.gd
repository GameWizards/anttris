var PUZZLE_5x5		= 5
var PUZZLE_7x7		= 7

var BLOCK_RED		= 0
var BLOCK_GREEN		= 1
var BLOCK_BLUE		= 2
var BLOCK_YELLOW	= 3
var BLOCK_ORANGE	= 4
var BLOCK_PURPLE	= 5

# Stores information about a single block for a puzzle.
class Block:
	var blockType = 0
	var blockPos = Vector3( 0, 0, 0 )

# Stores a puzzle in a convenient class.
class Puzzle:
	var puzzleSize
	var blocks = []

# Holds all of the steps needed to solve a puzzle.
class PuzzleSteps:
	var solveable
	
# Randomly shuffle an array.
func shuffleArray( arr ):
	for i in range( arr.size() - 1, 1, -1 ):
		print( "SWAP" )
		var swapVal = randi() % (i + 1)
		var temp = arr[swapVal]
		arr[swapVal] = arr[i]
		arr[i] = temp

# Generates a solveable puzzle.
func generatePuzzle( type ):
	var puzzle = Puzzle.new()
	puzzle.puzzleSize = type
	
	var middle = type / 2
	
	# Collect all of the block positions.
	for x in range( type ):
		for y in range( type ):
			for z in range( type ):
				if !(x == middle && y == middle && z == middle):
					var tb = Block.new()
					tb.blockPos = Vector3( x, y, z )
					puzzle.blocks.append( tb )
	
	# Randomize the order of the blocks.
	self.shuffleArray( puzzle.blocks )
	
	# Assign block types in pairs.
	for i in range( 0, puzzle.blocks.size(), 2 ):
		var randBlock = randi() % 6
		puzzle.blocks[i].blockType = randBlock
		puzzle.blocks[i+1].blockType = randBlock
	
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