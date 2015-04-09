var mP = load( "res://scripts/MenuPanel.gd" ).new()

func _ready():
	# Get the GUI items.
	mP.menuList.append( get_node( "OnlineName" ) )
	mP.menuList.append( get_node( "SoundVolume" ) )
	mP.menuList.append( get_node( "MusicVolume" ) )
	mP.menuList.append( get_node( "SaveQuit" ) )
	mP.menuList.append( get_node( "Cancel" ) )
	
	mP.makeMenu( self )