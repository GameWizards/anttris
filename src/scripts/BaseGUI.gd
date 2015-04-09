extends Control

var tween_in
var tween_out

# Initial setup.
func _ready():
	set_anchor_and_margin( MARGIN_RIGHT, ANCHOR_RATIO, 1 )
	set_anchor_and_margin( MARGIN_BOTTOM, ANCHOR_RATIO, 1 )
	set_opacity( 0.0 )
	hide()
	
	tween_in = Tween.new()
	add_child( tween_in )
	tween_in.interpolate_method( self, "set_opacity", 0.0, 1.0, 1.0, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT )
	
	tween_out = Tween.new()
	add_child( tween_out )
	tween_out.interpolate_method( self, "set_pos", Vector2( 0.0, 0.0 ), Vector2( -OS.get_video_mode_size().x, 0 ), 1.0, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT )
	tween_out.interpolate_method( self, "set_opacity", 1.0, 0.0, 0.75, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT )

# Fades the whole GUI in. This is the same for all GUI elements.
func guiIn():
	set_opacity( 0.0 )
	show()
	set_pos( Vector2( 0, 0 ) )
	tween_in.reset_all()
	tween_in.start()
	
# Zooms the whole GUI out. This is the same for all GUI elements.
func guiOut():
	tween_out.reset_all()
	tween_out.start()