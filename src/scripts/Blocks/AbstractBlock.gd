extends RigidBody

var name
const far_away_corner = Vector3(80, 80, 80)

func setName(n):
	name = n
	set_name(n)
	return self

# catch clicks/taps
func _input_event( camera, ev, click_pos, click_normal, shape_idx ):
	if ((ev.type==InputEvent.MOUSE_BUTTON and ev.button_index==BUTTON_LEFT)
	or (ev.type==InputEvent.SCREEN_TOUCH)):
		activate(ev, click_pos, click_normal)

# returns a tween node that uniformly changes the object's scale
# call start() on the returned object
func scaleTweenNode(scale, time=1, transType=Tween.TRANS_BOUNCE):
	var tweenNode = newTweenNode()
	tweenNode.interpolate_method( self, "set_scale", \
		self.get_scale(), Vector3(scale, scale, scale), \
		time, transType, Tween.EASE_OUT )

	return tweenNode

# adds a tween transition node to the tree
func newTweenNode():
	var tween = Tween.new()
	add_child(tween)
	return tween

func setTexture():
	pass

func activate(ev, click_pos, click_normal):
	pass

func _ready():
	set_ray_pickable(true)
