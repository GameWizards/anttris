var PUZZLE_5x5
var PUZZLE_7x7

# Stores information about a single block for a puzzle.
class Block:
	var blockType
	var blockPos = Vector3( 0, 0, 0 )

# Stores a puzzle in a convenient class.
class Puzzle:
	var puzzle

# Holds all of the steps needed to solve a puzzle.
class PuzzleSteps:
	var solveable

# Generates a solveable puzzle.
func GeneratePuzzle( type ):
	var puzzle = Puzzle.new()
	
	# GENERATOR
	
	return puzzle
	
	
# Determines if a puzzle is solveable.
func SolvePuzzle( puzzle ):
	# Simply use the SolvePuzzleSteps function and return the solveable part.
	var ps = SolvePuzzleSteps()
	return ps.solveable
	
# Determines if a puzzle is solveable and returns the steps needed to solve it.
func SolvePuzzleSteps( puzzle ):
	puzzleSteps = PuzzleSteps.new()
	puzzleSteps.solveable = true
	
	# SOLVER
	
	return puzzleSteps