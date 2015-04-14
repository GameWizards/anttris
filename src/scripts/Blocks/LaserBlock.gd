extends "AbstractBlock.gd"

var mat
var fired = false
const beamScn = preload( "res://blocks/block.scn" )

func setTexture(color=Color(0.5, 0, 0)):
	var img = Image()
	var text = ImageTexture.new()
	mat = FixedMaterial.new()
	
	img.load("res://textures/Block_Laser.png")
	text.create_from_image(img)
	mat.set_texture(FixedMaterial.PARAM_DIFFUSE, text)
	
	
	mat.set_parameter(FixedMaterial.PARAM_EMISSION, color)
	self.get_node("MeshInstance").set_material_override(mat)

	return self
	
func setColor(col):
	mat.set_parameter(FixedMaterial.PARAM_EMISSION, col)

func activate(ev, click_pos, click_normal):
	if fired:
		return
	fired = true
		
	var tweenNode = newTweenNode()
	
	# shrink to 80% size, 0.5 sec
	var scaleTween = scaleTweenNode(0.8, 0.5, Tween.TRANS_ELASTIC)
	scaleTween.start()
	
	# fade emission color
	tweenNode.interpolate_method( self, "setColor", \
		self.mat.get_parameter(FixedMaterial.PARAM_EMISSION), Color(0.1, 0.1, 0.1), \
		0.5, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT )
	tweenNode.start()
		
	# fire laser beam
	var beam = beamScn.instance()
	beam.set_scale(Vector3(1, 0.9, 0.9))
	beam.set_translation(Vector3(0.1, 0, 0))
	beam.set_name(name + "_beam")
	beam.set_script(load("res://scripts/Blocks/Beam.gd"))

	add_child( beam )
	beam.fire(5)
	
	# connect to the tween_complete signal. 
	# delete the beam on completion, add its children to this node.
	scaleTween.connect("tween_complete", beam, "remove")
