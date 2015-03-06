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
var distance = 30.0            # starting distance of the camera from the target
var zoom_rate = 8            # the rate at which the camera zooms in and out of the target
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
	pos.z = distance;
      # set the position of the camera in its orbit and point it at the target
	look_at_from_pos(pos, target, up)


# called to handle a user input event
func _input(ev):
	# If the mouse has been moved
	#if (ev.type==InputEvent.MOUSE_MOTION and ev.button_mask == 1):
      # calculate the delta change from the last mouse movement
		#var mousedelta = (mouseposlast - ev.pos)
      # scale the mouse delta to a useful value
		#turn += mousedelta / orbitrate
      # record the last position of the mousedelta
		#mouseposlast = ev.pos
   # if the user spins the mouse wheel up move the camera closer
	if (ev.type==InputEvent.MOUSE_BUTTON and ev.button_index==BUTTON_WHEEL_UP):
		distance -= 0.1
   # if the user spins the mouse wheel down move the camera farther away
	elif (ev.type==InputEvent.MOUSE_BUTTON and ev.button_index==BUTTON_WHEEL_DOWN):
		distance += 0.1
   # if a cancel action is input close the application
	elif (ev.is_action("ui_cancel")):
		OS.get_main_loop().quit()
	else:
		return
	# must call method similar to this to prevent events from propagating
	# SceneTree.set_input_as_handled()

   # recalculate the camera position and direction
	recalculate_camera()

