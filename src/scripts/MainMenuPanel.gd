var mP = load( "res://scripts/MenuPanel.gd" ).new()

func _ready():
	# Get the GUI items.
	mP.menuList.append( get_node( "SP" ) )
	mP.menuList.append( get_node( "MP" ) )
	mP.menuList.append( get_node( "Editor" ) )
	mP.menuList.append( get_node( "Options" ) )
	mP.menuList.append( get_node( "Exit" ) )
	
	mP.makeMenu( self )