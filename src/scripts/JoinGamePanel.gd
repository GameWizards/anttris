var mP = load( "res://scripts/MenuPanel.gd" ).new()

func _ready():
	# Get the GUI items.
	mP.menuList.append( get_node( "IPAddress" ) )
	mP.menuList.append( get_node( "JoinGame" ) )
	mP.menuList.append( get_node( "MainMenu" ) )
	
	mP.makeMenu( self )