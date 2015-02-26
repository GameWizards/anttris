extends RigidBody

func _input_event( camera, ev, click_pos, click_normal, shape_idx ):
	if (ev.type==InputEvent.MOUSE_BUTTON and ev.button_index==BUTTON_LEFT):
		var s = 0.1
		set_scale(Vector3( s, s, s ))
	
func _ready():
	set_ray_pickable(true)