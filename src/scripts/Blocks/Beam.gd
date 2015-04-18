extends RigidBody

var tweenNode
var tweenNodeScale

func _ready():
	# very bright material
	var mat = FixedMaterial.new()
	mat.set_parameter(FixedMaterial.PARAM_EMISSION, Color(0.6, 0, 0))
	self.get_node("MeshInstance").set_material_override(mat)

# to connect to the tween_complete signal, we need a function with these two arguments
func remove(node, key):
	remove_and_skip()

func fire(extent):
	tweenNode = Tween.new()
	add_child(tweenNode)
	tweenNodeScale = Tween.new()
	add_child(tweenNodeScale)

	var gridMan = get_tree().get_root().get_node( "Spatial/GridView/GridMan" )

	# shrink, expand along one axis
	# assumes blocks are 1 unit
	var timeToFade = 0.5
	extent = extent + extent.normalized()

	tweenNodeScale.interpolate_method( self, "set_scale", \
		self.get_scale(), extent, \
		timeToFade, Tween.TRANS_BOUNCE, Tween.EASE_OUT )

	# destroy blocks between the two lasers
	var alongAxis = extent.abs().max_axis()
	var r
	if extent[alongAxis] < 0:
		r = range(extent[alongAxis] + 2, 0)
	else:
		r = range(1, extent[alongAxis] - 1)

	var pt = get_parent().blockPos
	for i in r:
		pt += extent.normalized()
		var pn = gridMan.get_block(pt)
		var pn_go_away = pn.scaleTweenNode(0, timeToFade*randf() + 0.1, Tween.TRANS_EXPO)
		pn_go_away.start()
		pn_go_away.connect("tween_complete", pn, "removeQ")

	# connect to the tween_complete signal.
	# delete the beam on completion, add its children to this node.
	tweenNodeScale.connect("tween_complete", self, "remove")

	# keep one end on parent. without this, the beam will be centered
	tweenNode.interpolate_method( self, "set_translation", \
			self.get_translation(), extent, \
			timeToFade, Tween.TRANS_CIRC, Tween.EASE_IN_OUT )

	tweenNode.start()
	tweenNodeScale.start()

