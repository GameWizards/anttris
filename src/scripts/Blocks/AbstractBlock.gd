extends RigidBody

var name
var pairName
var selected = false
var blockPos
const far_away_corner = Vector3(80, 80, 80)

func nameToNodeName(n):
	return "block" + str(n)

func setName(n):
	name = nameToNodeName(n)
	set_name(nameToNodeName(n))
	return self

func setPairName(n):
	pairName = nameToNodeName(n)
	return self

# catch clicks/taps
func _input_event( camera, ev, click_pos, click_normal, shape_idx ):
	if ((ev.type==InputEvent.MOUSE_BUTTON and ev.button_index==BUTTON_LEFT)
	or (ev.type==InputEvent.SCREEN_TOUCH)):
		activate(ev, click_pos, click_normal)

# returns this block's pairNode or null
func pairActivate(ev, click_pos, click_normal):
	selected = true

	# is my pair Nil?
	if pairName == null or get_parent() == null or not get_parent().has_node(str(pairName)):
		scaleTweenNode(0.9, 0.2, Tween.TRANS_EXPO).start()
		return null

	# get my pair node
	var pairNode = get_parent().get_node(pairName)

	# enlarge if the other guy's unselected
	if not pairNode.selected:
		scaleTweenNode(1.1, 0.2, Tween.TRANS_EXPO).start()
	return pairNode


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

func remove_with_pop(node, key):
	get_parent().samplePlayer.play("deraj_pop_sound")
	get_parent().remove_block(self)

func _ready():
	set_ray_pickable(true)
	#var img;
	#img.load("res://textures/Block_" + textureName + ".png")
