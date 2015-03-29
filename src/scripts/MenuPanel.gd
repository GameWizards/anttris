# Need this script since GUI sizing is very buggy in the editor. Just clicking something changes the size.

var menuList = []

func makeMenu( panel ):
	# This is relative to the designed scale of 1024 x 768.
	var relativeWidthScale = OS.get_video_mode_size().x / 1024
	var relativeHeightScale = OS.get_video_mode_size().y / 768
	
	# Calculate the size of the panel.
	var width = OS.get_video_mode_size().x - 20 * relativeWidthScale
	var height = ( menuList.size() * 60 + 10 ) * relativeWidthScale
	
	# Update the size and position of the panel.
	panel.set_pos( Vector2( 10 * relativeWidthScale, OS.get_video_mode_size().y / 2.0 - height / 2.0 ) )
	panel.set_size( Vector2( width, height ) )
	
	# Set the size and position of all of the buttons.
	for item in range( menuList.size() ):
		menuList[item].set_pos( Vector2( 10 * relativeWidthScale, ( 10 + 60 * relativeHeightScale * item ) * relativeHeightScale ) )
		menuList[item].set_size( Vector2( width - ( 20 * relativeWidthScale ), 50 * relativeHeightScale ) )