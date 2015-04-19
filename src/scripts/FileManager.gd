# Loads a puzzle for the file given.
function loadPuzzle( name ):
	var file = File.new()
	file.open( name, File.READ )
	
	if file.is_open():
		puzzle = file.get_var()
		file.close()
	
	return puzzle
	
# Saves a puzzle to the file given.
function savePuzzle( name, puzzle ):
	var file = File.new()
	file.open( name, File.WRITE )
	
	if file.is_open():
		file.set_var( puzzle )
		file.close()