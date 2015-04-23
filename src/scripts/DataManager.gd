var PuzzleManScript = preload( "res://scripts/PuzzleManager.gd" )

# Saves the config settings to a file.
func saveConfig( config ):
	var file = File.new()
	file.open( "config.cfg", File.WRITE )
	
	if file.is_open():
		file.store_var( config.name )
		file.store_var( config.soundvolume )
		file.store_var( config.musicvolume )
		file.store_var( config.portnumber )
		file.close()

# Loads the config settings from a file.
func loadConfig():
	var file = File.new()
	file.open( "config.cfg", File.READ )
	
	var config = {}
	
	if file.is_open():
		config.name = file.get_var()
		config.soundvolume = file.get_var()
		config.musicvolume = file.get_var()
		config.portnumber = file.get_var()
		file.close()
		
	return config
	
# Serializes the puzzle into a dictionary.
#function serializePuzzle():


# Deserializes the puzzle from a dictionary.
#function deserializePuzzle():


# Saves a puzzle to the file given.
func savePuzzle( name, puzzle ):
	print( puzzle.puzzleName )
	var file = File.new()
	file.open( name, File.WRITE )
	
	var di = puzzle.toDict()
	
	if file.is_open():
		file.store_var( di )
		#file.store_var( puzzle.puzzleName )
		#file.store_var( puzzle.puzzleLayers )
		#file.store_var( puzzle.blocks.size() )
		#for b in range( puzzle.blocks.size() ):
		#	file.store_var( puzzle.blocks[b].toDict() )
		file.close()

# Loads a puzzle for the file given.
func loadPuzzle( name ):
	var file = File.new()
	var puzzleMan = PuzzleManScript.new()
	var puzzle = puzzleMan.Puzzle.new()
	puzzle.puzzleMan = puzzleMan
	file.open( name, File.READ )
	
	if file.is_open():
		puzzle.fromDict( file.get_var() )
		#puzzle.puzzleName = file.get_var()
		#puzzle.puzzleLayers = file.get_var()
		#var blockNum = file.get_var()
		#for b in range( blockNum ):
		#	var b = puzzleMan.PickledBlock.new()
		#	b.fromDict( file.get_var() )
		#	puzzle.blocks.append( b )
		file.close()
	
	return puzzle