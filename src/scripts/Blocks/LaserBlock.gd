extends "AbstractBlock.gd"

var mat
var vectToPair = Vector3()
var fired = false

const beamScn = preload( "res://blocks/block.scn" )
const Beam = preload("res://scripts/Blocks/Beam.gd")
const laserBlockImg = Image() # TODO preload this somewhere else

# color
func setTexture(color=Color(0.5, 0, 0)):
	var text = ImageTexture.new()
	mat = FixedMaterial.new()

	laserBlockImg.load("res://textures/Block_Laser.png")

	text.create_from_image(laserBlockImg)
	mat.set_texture(FixedMaterial.PARAM_DIFFUSE, text)

	mat.set_parameter(FixedMaterial.PARAM_EMISSION, color)
	self.get_node("MeshInstance").set_material_override(mat)

	return self

# sets light emission color
func setColor(col):
	mat.set_parameter(FixedMaterial.PARAM_EMISSION, col)

func setExtent(laserExtent):
	 vectToPair = laserExtent

# create a beam and activate it
func activate(ev, click_pos, click_normal):
	var pairNode = pairActivate(ev, click_pos, click_normal)
	if pairNode == null or pairNode.selected == false:
		return
	# shrink to 80% size, 0.5 sec
	scaleTweenNode(0.8, 0.5, Tween.TRANS_ELASTIC).start()

	var tweenNode = newTweenNode()
	# fade emission color
	tweenNode.interpolate_method( self, "setColor", \
		self.mat.get_parameter(FixedMaterial.PARAM_EMISSION), Color(0.1, 0.1, 0.1), \
		0.5, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT )
	tweenNode.start()

	if fired:
		return

	fired = true
	pairNode.fired = true
	pairNode.activate(ev, click_pos, click_normal)

	# fire laser beam
	var beam = beamScn.instance()

	beam.set_name(name + "_beam")
	beam.set_script(Beam)

	add_child( beam )
	beam.fire( vectToPair )

	get_parent().samplePlayer.play("soundslikewillem_hitting_slinky")
