
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

func forceClick(click_normal=null):
	var network = Globals.get("Network")
	if (not network == null and get_node("../../../../Puzzle").mainPuzzle and network.isNetwork):
			network.sendBlockUpdate(blockPos)

	if click_normal != null and editor != null:
		if editor.shouldAddNeighbor():
			addNeighbor(editor, click_normal)
			return
		if editor.shouldReplaceSelf() or editor.shouldRemoveSelf():
			# lasers cannot be removed by the editor
			if blockType == get_parent().get_parent().get_parent().puzzleMan.BLOCK_LASER:
				return

			# maybe replace self
			if editor.shouldReplaceSelf():
				addNeighbor(editor, 0 * click_normal)
			if pairName != null:
				var pair = get_parent().get_node(pairName)
				if pair != null:
					pair.request_remove()
			request_remove()
			return
	else:
		activate()
		get_parent().clickBlock( name )

func addNeighbor(editor, click_normal):
	var t = get_parent().get_parent().get_transform().inverse()
	editor.addBlock(blockPos + t * click_normal)


# catch clicks/taps
func _input_event( camera, ev, click_pos, click_normal, shape_idx ):
	if ((ev.type==InputEvent.MOUSE_BUTTON and ev.button_index==BUTTON_LEFT)
	or (ev.type==InputEvent.SCREEN_TOUCH)):
		if (get_parent().get_parent().active and ev.is_pressed()):
			forceClick(click_normal)

# returns this block's pairNode or null
func pairActivate():
	selected = true

	# is my pair Nil?
	if not get_parent().has_node(str(pairName)):
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

func request_remove(node=null, key=null):
	if node == null:
		node = self
	var n = scaleTweenNode(0.001, 0.25, Tween.TRANS_QUART)
	n.start()
	n.connect("tween_complete", get_parent(), "remove_block")

func _ready():
	if get_tree().get_root().has_node("EditorSpatial"):
		editor = get_tree().get_root().get_node("EditorSpatial")
	set_ray_pickable(true)
