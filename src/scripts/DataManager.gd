# Saves the config settings to a file.
static func saveConfig( config ):
	var file = File.new()
	file.open( "config.cfg", File.WRITE )

	if file.is_open():
		file.store_var( config.name )
		file.store_var( config.soundvolume )
		file.store_var( config.musicvolume )
		file.store_var( config.portnumber )
		file.close()

# Loads the config settings from a file.
static func loadConfig():
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

# Saves a puzzle to the file given.
static func savePuzzle( name, puzzle ):
	print( puzzle.puzzleName )
	var file = File.new()
	file.open( name, File.WRITE )

	var di = puzzle.toDict()

	if file.is_open():
		file.store_var( di )
		file.close()

# Loads a puzzle for the file given.
static func loadPuzzle( name ):
	var PuzzleManScript = preload( "res://scripts/PuzzleManager.gd" )

	var file = File.new()
	var puzzleMan = PuzzleManScript.new()
	var puzzle = puzzleMan.Puzzle.new()
	puzzle.puzzleMan = puzzleMan
	file.open( name, File.READ )

	if file.is_open():
		puzzle.fromDict( file.get_var() )
		file.close()

	return puzzle
