# Make this work on touch:
# catch InputEventScreenDrag, InputEventScreenTouch
#   write two-finger zoom
#
#
#
# limit zooming?
#
#
#
# THANKS TO
# Rook
# http://www.godotengine.org/forum/viewtopic.php?f=11&t=1580

# orbit camera function that uses the mouse, mouse wheel and mouse buttons to orbit around a
# target point that starts at the origin.
# credit to the forums and the documentation for various tips and pointers
extends Camera


# global working variables
var turn = Vector2( 0.0, 0.0 )            # the amount the mouse has turned
var mouseposlast = Input.get_mouse_pos()   # the mouses last position
var pos = Vector3(0.0,0.0,0.0)            # the position of the camera
var up = Vector3(0.0,1.0,0.0)            # the normalized 'up' vector pointing vertically
var target = Vector3(0.0,0.0,0.0)         # the look at target


# global tweakable parameters
var distance = { val = 30.0, max_ = 79, min_ = 15 }
var zoom_rate = 100            # the rate at which the camera zooms in and out of the target
var orbitrate = 20        # the rate the camera orbits the target when the mouse is moved
var target_move_rate = 1.0      # the rate the target look at point moves


# called once after node is setup
func _ready():
	set_process_input(true)      # process user input events here
	# Input.set_mouse_mode(2)      # mouse mode captured


# recalculates the camera position in orbiting the target and its orientation to look at the target
# credit to Stephen Tierney (Game Development Discussions website)
func recalculate_camera():
      # calculate the camera position as it orbits a sphere about the target
	#pos.x = distance * -sin(turn.x) * cos(turn.y)
	#pos.y = distance * -sin(turn.y)
	#pos.z = -distance * cos(turn.x) * cos(turn.y)
	pos = get_translation();
	pos.z = distance.val;
      # set the position of the camera in its orbit and point it at the target
	look_at_from_pos(pos, target, up)


# called to handle a user input event
func _input(ev):
   # if the user spins the mouse wheel up move the camera closer
	if (ev.type==InputEvent.MOUSE_BUTTON and ev.button_index==BUTTON_WHEEL_UP):
		if (distance.val > distance.min_):
			distance.val -= zoom_rate * get_process_delta_time()
   # if the user spins the mouse wheel down move the camera farther away
	elif (ev.type==InputEvent.MOUSE_BUTTON and ev.button_index==BUTTON_WHEEL_DOWN):
		if (distance.val < distance.max_):
			distance.val += zoom_rate * get_process_delta_time()
   # if a cancel action is input close the application
	elif (ev.is_action("ui_cancel")):
		OS.get_main_loop().quit()
	else:
		return

	recalculate_camera()

