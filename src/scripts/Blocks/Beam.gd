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

func fire(start,end):
	#tweenNode = Tween.new()
	#add_child(tweenNode)
	tweenNodeScale = Tween.new()
	add_child(tweenNodeScale)
	
	set_translation( ( start * 2 + end * 2 ) / 2 )

	var gridMan = get_parent()

	# shrink, expand along one axis
	# assumes blocks are 1 unit
	var timeToFade = 0.5
	#end = end + end.normalized()
	
	# destroy blocks between the two lasers
	var alongAxis = 0
	if( end.y != start.y ):
		alongAxis = 1
	if( end.z != start.z ):
		alongAxis = 2
		
	var initScale = Vector3( 1, 1, 1 )
	var finalScale = Vector3( 0, 0, 0 )
	initScale[alongAxis] = abs( start[alongAxis] - end[alongAxis] ) * 2
	finalScale[alongAxis] = initScale[alongAxis]
		
	set_scale( initScale )

	tweenNodeScale.interpolate_method( self, "set_scale", \
		self.get_scale(), Vector3( 0, 0, 0 ), \
		timeToFade, Tween.TRANS_BOUNCE, Tween.EASE_OUT )
		
	var r = 1
	if end[alongAxis] - start[alongAxis] < 0:
		r = -1

	var pt = start
	pt[alongAxis] += r
	while pt[alongAxis] != end[alongAxis]:
		var pn = gridMan.get_block(pt)
		pt[alongAxis] += r
		if pn == null:
			continue
		var pn_go_away = pn.scaleTweenNode(0, randf() + 0.5, Tween.TRANS_EXPO)
		pn_go_away.start()
		pn_go_away.connect("tween_complete", pn, "remove_with_pop")

	# connect to the tween_complete signal.
	# delete the beam on completion, add its children to this node.
	tweenNodeScale.connect("tween_complete", self, "remove")

	# keep one end on parent. without this, the beam will be centered
	#tweenNode.interpolate_method( self, "set_translation", \
	#		self.get_translation(), end * 2, \
	#		timeToFade, Tween.TRANS_CIRC, Tween.EASE_IN_OUT )

	#tweenNode.start()
	tweenNodeScale.start()

