

# global working variables
var turn = Vector2( 0.0, 0.0 )            # the amount the mouse has turned
var mouseposlast = Input.get_mouse_pos()   # the mouses last position

# global tweakable parameters
var orbitrate = 10        # the rate the camera orbits the target when the mouse is moved
var active = true
var offClick = false
var selectedBlocks = []

func _ready():
	# Initalization here
	set_process_input(true)      # process user input events here

# called to handle a user input event
func _input(ev):
	if (not active):
		return
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

	if (ev.type==InputEvent.SCREEN_DRAG or ev.type==InputEvent.MOUSE_MOTION or ev.type==InputEvent.JOYSTICK_MOTION or ev.type==InputEvent.SCREEN_TOUCH):
		mouseposlast = ev.pos
	# Android does not like this: Input.get_mouse_pos()

func clearSelection():
	for bl in selectedBlocks:
		var blo = get_node("GridMan/" + bl)
		print("this bothers Hugo")
		blo.setSelected(false)
		blo.scaleTweenNode(1.0).start()
	selectedBlocks = []
	
func addSelected(bl):
	selectedBlocks.append(bl)