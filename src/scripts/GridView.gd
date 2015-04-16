extends Spatial

# global working variables
var turn = Vector2( 0.0, 0.0 )            # the amount the mouse has turned
var mouseposlast = Input.get_mouse_pos()   # the mouses last position

# global tweakable parameters
var orbitrate = 10        # the rate the camera orbits the target when the mouse is moved


func _ready():
	# Initalization here
	set_process_input(true)      # process user input events here
	
# called to handle a user input event
func _input(ev):
	# If the mouse has been moved
	if (ev.type==InputEvent.SCREEN_DRAG or (ev.type==InputEvent.MOUSE_MOTION and ev.button_mask == 1)):
		# calculate the delta change from the last mouse movement
		var mousedelta = (mouseposlast - ev.pos)
		# scale the mouse delta to a useful value
		turn = mousedelta / orbitrate
		# perform the rotation
		var currentTransform = get_transform().basis
		var dtime = get_process_delta_time()
		currentTransform = Matrix3( Vector3(0, 1, 0), PI * turn.x * dtime ) * currentTransform
		currentTransform = Matrix3( Vector3(1, 0, 0), PI * turn.y * dtime ) * currentTransform
		set_transform( Transform( currentTransform ) )
		
	# record the last position of the mousedelta
	mouseposlast = ev.pos 
	# Android does not like this: Input.get_mouse_pos()