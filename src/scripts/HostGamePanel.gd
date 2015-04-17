var mP = load( "res://scripts/MenuPanel.gd" ).new()


func _ready():
	# Get the GUI items.
	mP.menuList.append( get_node( "Waiting" ) )
	mP.menuList.append( get_node( "MainMenu" ) )
	
	mP.makeMenu( self )