var PuzzleManScript = preload( "res://scripts/PuzzleManager.gd" )

# Saves a puzzle to the file given.
function savePuzzle( name, puzzle ):
	var file = File.new()
	file.open( name, File.WRITE )
	
	if file.is_open():
		file.store_var( puzzle.puzzleName )
		file.store_var( puzzle.puzzleLayers )
		file.store_var( puzzle.blocks.size() )
		for b in range( puzzle.blocks.size() ):
			file.store_var( puzzle.blocks[b].toDict() )
		file.close()

# Loads a puzzle for the file given.
function loadPuzzle( name ):
	var file = File.new()
	var puzzleMan = PuzzleManScript.new()
	var puzzle = puzzleMan.Puzzle.new()
	file.open( name, File.READ )
	
	if file.is_open():
		puzzle.puzzleName = file.get_var()
		puzzle.puzzleLayers = file.get_var()
		var blockNum = file.get_var()
		for b in range( blockNum ):
			var b = puzzleMan.PickledBlock.new()
			b.fromDict( file.get_var() )
			puzzle.blocks.append( b )
		file.close()
	
	return puzzle