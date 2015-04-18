extends "AbstractBlock.gd"

var mat
var fired = false

var vectToPair = Vector3()
var pairName = null
var selected = false

const beamScn = preload( "res://blocks/block.scn" )
const Beam = preload("res://scripts/Blocks/Beam.gd")
const laserBlockImg = Image() # TODO preload this somewhere else

# colorify and
func setTexture(color=Color(0.5, 0, 0)):
	var text = ImageTexture.new()
	mat = FixedMaterial.new()

	laserBlockImg.load("res://textures/Block_Laser.png")

	text.create_from_image(laserBlockImg)
	mat.set_texture(FixedMaterial.PARAM_DIFFUSE, text)

	mat.set_parameter(FixedMaterial.PARAM_EMISSION, color)
	self.get_node("MeshInstance").set_material_override(mat)

	return self

func setPairName(other):
	pairName = other
	return self

# sets light emission color
func setColor(col):
	mat.set_parameter(FixedMaterial.PARAM_EMISSION, col)

func setExtent(laserExtent):
	 vectToPair = laserExtent

# create a beam and activate it
func activate(ev, click_pos, click_normal):
	selected = true

	# get my pair sibling
	var pairNode = get_parent().get_node(pairName)

	# is my pair Nil?
	if not get_parent().has_node(pairName):
		scaleTweenNode(0.9, 0.2, Tween.TRANS_EXPO).start()
		return

	if not pairNode.selected:
		scaleTweenNode(1.1, 0.2, Tween.TRANS_EXPO).start()
		return

	if fired:
		return

	fired = true
	pairNode.activate(ev, click_pos, click_normal)
# BUG: firing two beams, one for each laser in the pair?

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

	beam.set_name(name + "_beam")
	beam.set_script(Beam)

	add_child( beam )
	beam.fire( vectToPair )

	get_parent().samplePlayer.play("soundslikewillem_hitting_slinky")
