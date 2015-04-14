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
	
	# shrink, expand along one axis
	var scale = 0.5
	tweenNodeScale.interpolate_method( self, "set_scale", \
		self.get_scale(), Vector3(extent, scale, scale), \
		0.5, Tween.TRANS_BOUNCE, Tween.EASE_OUT )
		
	# keep one end on parent. without this, the beam will be centered
	tweenNode.interpolate_method( self, "set_translation", \
			self.get_translation(), Vector3(extent, 0, 0), \
			0.2, Tween.TRANS_CIRC, Tween.EASE_IN_OUT )

	tweenNode.start()
	tweenNodeScale.start()
