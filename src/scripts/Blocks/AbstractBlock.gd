
extends RigidBody

var name_int
var name
var pairName
var selected = false
var blockPos
var blockLayer
var blockType
const far_away_corner = Vector3(110, 110, 110)

var editor

static func nameToNodeName(n):
	return "block" + str(n)

func setName(n):
	name_int = n
	name = nameToNodeName(n)
	set_name(nameToNodeName(n))
	return self

func setPairName(n):
	pairName = nameToNodeName(n)
	return self

func setBlockLayer(n):
	blockLayer = n
	return self

func getBlockLayer():
	return blockLayer

func setBlockType( blockT ):
	blockType = blockT
	return self

func getBlockType():
	return blockType

func setSelected(sel):
	selected = sel
	return self

func forceClick():
	activate()
	get_parent().clickBlock( name )

func addNeighbor(editor, click_normal):
	var t = get_parent().get_parent().get_transform().inverse()
	var b = editor.newPickledBlock().setBlockPos(blockPos + t * click_normal)
	get_parent().add_block(b.toNode())


# catch clicks/taps
func _input_event( camera, ev, click_pos, click_normal, shape_idx ):
	if ((ev.type==InputEvent.MOUSE_BUTTON and ev.button_index==BUTTON_LEFT)
	or (ev.type==InputEvent.SCREEN_TOUCH)):
		if (get_parent().get_parent().active and ev.is_pressed()):
			if editor != null:
				if editor.shouldAddNeighbor():
					addNeighbor(editor, click_normal)
					return
				if editor.shouldReplaceSelf():
					addNeighbor(editor, 0 * click_normal)
					remove_with_pop(self, null)
					return
				if editor.shouldRemoveSelf():
					remove_with_pop(self, null)
					return
			else:
				forceClick()

# returns this block's pairNode or null
func pairActivate():
	selected = true

	# is my pair Nil?
	if pairName == null or get_parent() == null or not get_parent().has_node(pairName):
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

func remove_with_pop(node, key=null):
	get_parent().samplePlayer.play("deraj_pop_sound")
	get_parent().remove_block(self)

func _ready():
	editor = get_tree().get_root().get_node("EditorSpatial")
	set_ray_pickable(true)
