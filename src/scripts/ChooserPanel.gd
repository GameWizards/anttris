var mP = load( "res://scripts/MenuPanel.gd" ).new()

func _ready():
	# Get the GUI items.
	mP.menuList.append( get_node( "RandomPuzzle" ) )
	mP.menuList.append( get_node( "LoadPuzzle" ) )
	mP.menuList.append( get_node( "MainMenu" ) )
	
	mP.makeMenu( self )